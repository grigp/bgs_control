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

  /// Время начала этапа
  late Timer _timer;

  double _averagePower = 0;
  double _maxPower = 0;
  int _statCount = 0;

  // late Isolate _isolate;
  // final receivePort = ReceivePort();

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
    if (program.uid != '' && _isConnected) {
      _uuidGetData = const Uuid().v1();
      _connect.addHandler(_uuidGetData, onGetData);

      _timer = Timer.periodic(const Duration(seconds: 1), onTimer);
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

      // _isolate = await Isolate.spawn(onTimerIsolate, receivePort.sendPort);
    }
  }

  Future stop() async {
    _timer.cancel();
    Workmanager().cancelAll();
    _isPlaying = false;
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

  void pause() {
    if (program.uid != '') {
      _isPlaying = !_isPlaying;
      _connect.pause(_isPlaying);
    }
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
          '--------------------- getdata : ${++n} -- metUid: ${data.methodUid}  stage: ${data.stage}  time: ${data.playingTime}');
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
        _isPlaying = false;
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

  void onTimer(Timer timer) async {
    // if (kDebugMode) {
    //   print(
    //       '---------------------------- isPlaying: $_isPlaying      timer:  $_playingTime');
    // }
    // if (_isPlaying) {
    //   ++_playingTime;
    //   if (_duration > 0 && (stageTime() >= _duration / 1000)) {
    //     /// Если это не последний этап
    //     if (_idxStage + 1 < program.stagesCount()) {
    //       ++_idxStage;
    //       _stageStartTime = _playingTime;
    //       _duration = program.stage(_idxStage).duration;
    //     } else {
    //       /// Все этапы прошли - выходим
    //       setPower(0);
    //       Workmanager().cancelAll();
    //       _isPlaying = false;
    //       _programTime = _playingTime;
    //       _playingTime = 0;
    //       _isOver = true;
    //     }
    //   }
    // }
    //
    // if (_idxStage == -1) {
    //   Workmanager().cancelAll();
    //   timer.cancel();
    // }
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
}
