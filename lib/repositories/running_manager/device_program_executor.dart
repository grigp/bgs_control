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

  /// завершена ли программа
  int _playingTime = 0;

  /// Время процесса
  int _stageStartTime = 0;

  /// Время начала этапа
  late Timer _timer;

  bool _isWorkAuto = false;
  double _averagePower = 0;
  double _maxPower = 0;
  int _statCount = 0;

  // late Isolate _isolate;
  // final receivePort = ReceivePort();

  /// Запуск программы
  Future<bool> connect() async {
    if (await _connect.init(device)){
      device.connectionState.listen((event) {
        _isConnected = event == BluetoothConnectionState.connected;
      });
      return true;
    }
    return false;
  }

  void disconnect(bool isReset) {
    // if (_isConnected) {
    if (isReset) {
      _connect.reset();
    }
    _connect.done();
    _isConnected = false;

    device.disconnectAndUpdateStream().catchError((e) {});
    // }
  }

  void run() async {
    if (program.uid != '' && _isConnected) {
      _uuidGetData = const Uuid().v1();
      _connect.addHandler(_uuidGetData, onGetData);

      _timer = Timer.periodic(const Duration(seconds: 1), onTimer);
      _connect.resetChargeLevel();

      _isPlaying = true;
      if (_isOver) {
        _idxStage = 0;
        _playingTime = 0;
        _stageStartTime = 0;
        _statCount = 0;
        _averagePower = 0;
        _maxPower = 0;
      }
      _isOver = false;
      _setParamsStageToDevice();
      _progDuration = _programDuration();
      _setWorkManagerTask(_progDuration - 2000);

      /// на 2 сек меньше
//      _setWorkManagerTask(program.stage(_idxStage).duration - 2000); /// на 2 сек меньше
      _duration = program.stage(_idxStage).duration;

      // _isolate = await Isolate.spawn(onTimerIsolate, receivePort.sendPort);
    }
  }

  void stop() {
    _timer.cancel();
    Workmanager().cancelAll();
    _isPlaying = false;
    // _idxStage = -1;
    // _playingTime = 0;
    if (program.uid != '' && _isConnected) {
      _connect.removeHandler(_uuidGetData);
    }
  }

  void pause() {
    if (program.uid != '') {
      _isPlaying = !_isPlaying;
      reset();
    }
  }

  void resetProgram() {
    _idxStage = 0;
    _playingTime = 0;
    _stageStartTime = 0;
    _statCount = 0;
    _averagePower = 0;
    _maxPower = 0;
    _isOver = true;
  }

  /// Задает программу, по которой нужно двигаться
  void setProgram(MethodicProgram prg) {
    if (prg.uid != program.uid) {
      resetProgram();
    }
    program = prg;
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
    var dp = await GetIt.I<BgsPropertyStorage>().getProperty(_connect.device.advName);
    _connect.setTimeUseDevice(dp.timeUseDevice);
  }

  Future saveSettings() async {
    /// Сохраним параметры стимулятора. Главное - время работы
    GetIt.I<BgsPropertyStorage>().saveProperty(
        BgsProperty(
          bgsName: _connect.device.advName,
          deviceNumber: _connect.deviceNumber(),
          firmwareNumber: _connect.firmwareNumber(),
          timeUseDevice: _connect.timeUseDevice(),
        )
    );
  }

  void setPower(double power) {
    _connect.setPower(power);
  }

  void reset() async {
    _connect.reset();
  }

  void setConnectionFailureMode(ConnectionFailureMode mode) async {
    _connect.setConnectionFailureMode(mode);
  }

  void setModeDepecated(int idxAM, int idxFM, int idxIntencity) async {
    _connect.setModeDepecated(idxAM, idxFM, idxIntencity);
  }

  void setMode(bool isAM, bool isFM, AmMode amMode, double idxFreq,
      Intensivity intensity) async {
    _connect.setMode(isAM, isFM, amMode, idxFreq, intensity);
  }

  int n = 0;

  void onGetData(BlockData data) {
    if (kDebugMode) {
      print('------------------------------------ getdata : ${++n}');
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
    if (kDebugMode) {
      print(
          '---------------------------- isPlaying: $_isPlaying      timer:  $_playingTime');
    }
    if (_isPlaying) {
      ++_playingTime;
      if (_duration > 0 && (stageTime() >= _duration / 1000)) {
        /// Если это не последний этап
        if (_idxStage + 1 < program.stagesCount()) {
          ++_idxStage;
          _setParamsStageToDevice();
          //_setWorkManagerTask(program.stage(_idxStage).duration - 2000);
          _stageStartTime = _playingTime;
          _duration = program.stage(_idxStage).duration;
        } else {
          /// Все этапы прошли - выходим
          setPower(0);
          Workmanager().cancelAll();
          _isPlaying = false;
          _isOver = true;
        }
      }
      // // Быстрое завеершение программы
      // // TODO: Убрать!!!
      // if (_playingTime == 10){
      //   /// Все этапы прошли - выходим
      //   setPower(0);
      //   _isPlaying = false;
      //   _isOver = true;
      // }
    }

    if (_idxStage == -1) {
      Workmanager().cancelAll();
      timer.cancel();
    }
  }

  // static void onTimerIsolate(SendPort sendPort){
  //   int n = 0;
  //   Timer.periodic(const Duration(seconds: 1), (Timer timer){
  //     print('---------------------------- isolate ${++n}');
  //   });
  // }

  void _setParamsStageToDevice() {
    double idxFreq = 7;
    var stage = program.stage(_idxStage);
    for (final element in freqValue.entries) {
      if (element.value == stage.frequency) {
        idxFreq = element.key;
      }
    }
    setMode(
      stage.isAm,
      stage.isFm,
      stage.amMode,
      idxFreq,
      stage.intensity,
    );
  }

  void _setWorkManagerTask(int duration) {
    Workmanager().cancelAll();
    Workmanager().registerOneOffTask(
      "counter_texel",
      "counter_texel",
      inputData: {'time': duration},
    );
  }

  bool isWorkAuto() => _isWorkAuto;

  void setIsWorkAuto(bool isWorkAuto) {
    _isWorkAuto = isWorkAuto;
  }

  int _programDuration() {
    int pd = 0;
    for (int i = 0; i < program.stagesCount(); ++i) {
      pd += program.stage(i).duration;
    }
    return pd;
  }

  int deviceNumber() {
    return _connect.deviceNumber();
  }

  int firmwareNumber() {
    return _connect.firmwareNumber();
  }
}
