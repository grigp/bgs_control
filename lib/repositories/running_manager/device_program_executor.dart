import 'dart:async';

//import 'dart:isolate';

import 'package:bgs_control/repositories/bgs_property_storage/bgs_property_storage.dart';
import 'package:bgs_control/repositories/methodic_programs/model/methodic_program.dart';
import 'package:bgs_control/utils/extra.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:get_it/get_it.dart';
import 'package:uuid/uuid.dart';
import 'package:workmanager/workmanager.dart';

import '../bgs_connect/bgs_connect.dart';
import '../bgs_connect/bgs_defines.dart';

/// Класс управления устройством при проведении методики
class DeviceProgramExecutor {
  /// При создании задается только устройство, программа назначается позже
  /// И при одном сеансе могут быть назначены разные программы
  DeviceProgramExecutor({
    required this.device,
  });

  final BgsConnect _connect = BgsConnect();
  final BluetoothDevice device;
  late MethodicProgram program = MethodicProgram(
    uid: '',
    statsTitle: '',
    title: '',
    description: '',
    image: '',
    mpk: MethodicProgramKind.mpkNormal,
  );
  bool _isConnected = false;
  String _uuidGetData = '';

  /// Управление процессом выполнения программы
  int _idxStage = 0;

  /// Номер этапа
  int _duration = 0;

  /// Длительность этапа
  int _progDuration = 0;

  /// Длительность программы
  bool _isPlaying = false;

  /// Идет ли процесс или поставлен на паузу
  bool _isOver = true;

  /// Время выполнения программы
  int _playingTime = 0;

  /// Время прохождения этапа из предыдущего пакета данных
  int _prevTime = 0;

  /// Результирующее время выполнения программы
  int _programTime = 0;

  /// Время процесса
  int _stageStartTime = 0;

  /// Необходимость прочитать позицию из прибора
  /// Инициируется в run(), читается в getData()
  bool _isReadPositionFromDevice = false;

  double _averagePower = 0;
  double _maxPower = 0;
  int _statCount = 0;

  /// Костыль, запрещающий воспринимать кнопку пауза на приборе быстрее, чем заданное время от нажатия ее в программе
  bool _isPauseHandling = true;

  /// Запуск программы
  Future<bool> connect() async {
    if (await _connect.init(device)) {
      device.connectionState.listen((event) {
        _isConnected = event == BluetoothConnectionState.connected;
      });
      return true;
    }
    return false;
  }

  Future disconnect() async {
    // if (_isConnected) {
    _connect.done();
    _isConnected = false;

    await _connect.removeHandlers();
    await device.disconnectAndUpdateStream().catchError((e) {});
    // }
  }

  void run(bool isNewProgram) async {
    print('---------------------- dpe.run()    ${program.uid}  $_isConnected');
    if (program.uid != '' && _isConnected) {
      _addHandler();

      _connect.resetChargeLevel();

      /// Программа стартует в режиме паузы.
      /// Чтобы ее запустить, надо нажать на кнопку Play [>]
      /// Предварительно не помешало бы установить нужный уровень мощности
      if (isNewProgram) {
        _isPlaying = false;
        if (_isOver) {
          _idxStage = 0;
          _playingTime = 0;
          _stageStartTime = 0;
          _prevTime = 0;
          _statCount = 0;
          _averagePower = 0;
          _maxPower = 0;
        }
        _isOver = false;
      } else {
        _isPlaying = true;
        _isReadPositionFromDevice = true;
      }

      _progDuration = _programDuration();
      setWorkManagerTask(_progDuration - 2000);

      /// на 2 сек меньше
//      setWorkManagerTask(program.stage(_idxStage).duration - 2000); /// на 2 сек меньше
      _duration = program.stage(_idxStage).duration;
    }
  }

  /// Останавливает выполнение программы.
  /// Если isPause == true, запретим реагировать на кнопку pause на приборе на 2 секунды
  Future stop(bool isPause) async {
    if (isPause) {
      /// Запретим реагировать на кнопку pause на приборе на 2 секунды
      _isPauseHandling = false;
      Timer(const Duration(seconds: 2), () {
        _isPauseHandling = true;
      });
    } else {
      _isPlaying = false;
    }

    Workmanager().cancelAll();
    stopProgram();
    _idxStage = 0;
    _playingTime = 0;
    _stageStartTime = 0;
    _prevTime = 0;
    _statCount = 0;
    _averagePower = 0;
    _maxPower = 0;
    if (program.uid != '' && _isConnected) {
      _connect.removeHandler(_uuidGetData);
    }
  }

  /// Переключение режима паузы
  Future pause() async {
    if (program.uid != '') {
      _isPlaying = !_isPlaying;
      await _connect.pause(_isPlaying);

      /// Запретим реагировать на кнопку pause на приборе на 2 секунды
      _isPauseHandling = false;
      Timer(const Duration(seconds: 2), () {
        _isPauseHandling = true;
      });
    }
  }

  void playAfterChangeProgram() {
    _connect.pause(true);
    _isPlaying = true;
    _addHandler();
  }

  void resetProgram() {
    _idxStage = 0;
    _playingTime = 0;
    _stageStartTime = 0;
    _statCount = 0;
    _averagePower = 0;
    _maxPower = 0;
    _isOver = false;
  }

  /// Задает программу, по которой нужно двигаться
  void setProgram(MethodicProgram prg, bool isWriteToDevice) {
    if (prg.uid != program.uid) {
      resetProgram();
    }
    program = prg;

    /// Записываем программу в устройство
    if (isWriteToDevice && prg.stagesCount() > 0) {
      _connect.setProgram(prg);
    }
  }

  /// Прерывает программу, выполняемую в настоящий момент в устройстве
  /// И переводит его в режим ожидания
  void stopProgram() {
    _connect.stopProgram();
  }

  /// Запрашивает пакет данных о параметрах программы
  /// (целевая мощность + длительности этапов)
  void getProgramParams() async {
    _connect.getProgramParams();
  }

  /// Целевая мощность, получаемая по запросу
  int targetPower() {
    return _connect.targetPower();
  }

  /// Кол-во этапов программы, получаемые по запросу
  int stagesCount() {
    return _connect.stagesCount();
  }

  /// Длительность этапа программы, получаемые по запросу
  double stageDuration(int stage) {
    return _connect.stageDuration(stage);
  }

  /// Возвращает название устройства
  String deviceName() {
    return device.advName;
  }

  /// Возвращает признак, проходит ли процесс
  bool isPlaying() => _isPlaying;

  /// Возвращает признак, завершена ли программа
  bool isOver() => _isOver;

  /// Возвращает время течения процесса
  int playingTime() => _playingTime;

  /// Результирующее время выполнения программы
  int programTime() => _programTime;

  /// Общая длительность программы
  int programDuration() => _progDuration ~/ 1000;

  /// Время этапа
  int stageTime() => _playingTime - _stageStartTime;

  /// Номер этапа
  int idxStage() => _idxStage;

  /// Средняя мощность
  double averagePower() => _averagePower / _statCount;

  /// Максимальная мощность
  double maxPower() => _maxPower;

  /// Текущий этап
  ProgramStage stage() => program.stage(_idxStage);

  Future addHandler(String uid, Function handler) async {
    await _connect.addHandler(uid, handler);
  }

  Future removeHandler(String uid) async {
    await _connect.removeHandler(uid);
  }

  Future initSettings() async {
    /// Получиим параметры стимулятора. Главное - время работы
    var dp = await GetIt.I<BgsPropertyStorage>()
        .getProperty(_connect.device.advName);
    _connect.setTimeUseDevice(dp.timeUseDevice);
  }

  Future saveSettings() async {
    /// Сохраним параметры стимулятора. Главное - время работы
    GetIt.I<BgsPropertyStorage>().saveProperty(BgsProperty(
      bgsName: _connect.device.advName,
      firmwareNumber: _connect.firmwareNumber(),
      timeUseDevice: _connect.timeUseDevice(),
    ));
  }

  Future setPower(double power) async {
    _connect.setPower(power);
  }

  void reset() async {
    _connect.reset();
  }

  int n = 0;

  void onGetData(BlockData data) {
    if (kDebugMode) {
      print(
          '--------------------- getdata : ${++n} -- metUid: ${data.methodUid}  stage: ${data.stage}  duration: ${program.stage(_idxStage).duration}  time: ${data.playingTime}');
      print(
          '------ from device - stagesCount: ${_connect.stagesCount()}  duration: ${_connect.stageDuration(_idxStage)}');
    }

    if (program.stage(_idxStage).duration == 0 &&
        _connect.stageDuration(_idxStage) > 0) {
      program.setDuration(_idxStage, _connect.stageDuration(_idxStage).toInt());
      _progDuration = _programDuration();
    }

    /// Если восстанаовливаем соединение, то данные о иекущей позиции рассчитать
    if (_isReadPositionFromDevice) {
      _stageStartTime = 0;
      _prevTime = 0;
      for (int i = 0; i < program.stagesCount(); ++i) {
        if (i == data.stage) break;
        _stageStartTime += program.stage(i).duration ~/ 1000;
      }
      _isReadPositionFromDevice = false;
    }

    /// Отработка нажатия кнопки на приборе
    if (data.isPause && _isPauseHandling) {
      _isPlaying = false;
    }

    if (_isPlaying) {
      /// Если в пакете код методики == 0, то методика зкончилась, иначе она идет
      if (data.methodUid != 0) {
        /// Время этапа меньше, чем в предыдущем пакете - перешли к новому этапу
        if (data.playingTime.toInt() + 1 < _prevTime) {
          _stageStartTime = _stageStartTime + _prevTime;
        }
        _playingTime = _stageStartTime + data.playingTime.toInt() + 1;
        _prevTime = data.playingTime.toInt() + 1;
        _idxStage = data.stage;
        _duration = program.stage(_idxStage).duration;
      } else {
        /// Методика зкончилась
        Workmanager().cancelAll();
        if (_isPauseHandling) {
          _isPlaying = false;
        }
        _programTime = _playingTime;
        _playingTime = 0;
        _isOver = true;
      }
    }

    /// Набор статистики
    if (_isPlaying) {
      if (data.power > _maxPower) {
        _maxPower = data.power;
      }
      _averagePower += data.power;
      ++_statCount;
    }
  }

  void setWorkManagerTask(int duration) {
    Workmanager().cancelAll();
    Workmanager().registerOneOffTask(
      "counter_texel",
      "counter_texel",
      inputData: {'time': duration},
    );
  }

  void resetWorkManagerTask() {
    Workmanager().cancelAll();
  }

  int _programDuration() {
    int pd = 0;
    for (int i = 0; i < program.stagesCount(); ++i) {
      pd += program.stage(i).duration;
    }
    return pd;
  }

  int firmwareNumber() {
    return _connect.firmwareNumber();
  }

  void _addHandler() {
    _uuidGetData = const Uuid().v1();
    _connect.addHandler(_uuidGetData, onGetData);
  }
}
