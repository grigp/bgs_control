import 'dart:async';
//import 'dart:isolate';

import 'package:bgs_control/repositories/methodic_programs/model/methodic_program.dart';
import 'package:bgs_control/utils/extra.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:uuid/uuid.dart';

import '../bgs_connect/bgs_connect.dart';

/// Класс управления устройством при проведении методики
class DeviceProgramExecutor  {
  /// При создании задается только устройство, программа назначается позже
  /// И при одном сеансе могут быть назначены разные программы
  DeviceProgramExecutor({
    required this.device,
  });

  final BgsConnect _connect = BgsConnect();
  final BluetoothDevice device;
  late MethodicProgram program = MethodicProgram(
      uid: '', statsTitle: '', title: '', description: '', image: '');
  bool _isConnected = false;
  String _uuidGetData = '';

  /// Управление процессом выполнения программы
  int _idxStage = -1;  /// Номер этапа
  int _duration = 0;   /// Длительность этапа
  bool _isPlaying = false;      /// Идет ли процесс или поставлен на паузу
  bool _isOver = false;         /// завершена ли программа
  int _playingTime = 0;         /// Время процесса
  int _stageStartTime = 0;      /// Время начала этапа
  late Timer _timer;

  // late Isolate _isolate;
  // final receivePort = ReceivePort();


  /// Запуск программы
  void connect() {
    // if (!_isConnected) {  События в stream(.listen) срабатывает до connect при последующих запусках
      _connect.init(device);
      device.connectionState.listen((event) {
        _isConnected = event == BluetoothConnectionState.connected;
      });
    // }
  }

  void disconnect() {
    // if (_isConnected) {
      _connect.reset();
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

      _isPlaying = true;
      _isOver = false;
      _idxStage = 0;
      _playingTime = 0;
      _stageStartTime = 0;
      _setParamsStageToDevice();
      _duration = program.stage(_idxStage).duration;

      // _isolate = await Isolate.spawn(onTimerIsolate, receivePort.sendPort);
    }
  }

  void stop() {
    _timer.cancel();
    _isPlaying = false;
    _idxStage = -1;
    _playingTime = 0;
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

  /// Задает программу, по которой нужно двигаться
  void setProgram(MethodicProgram prg) {
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

  /// Время этапа
  int stageTime() => _playingTime - _stageStartTime;

  /// Номер этапа
  int idxStage() => _idxStage;

  /// Текущий этап
  ProgramStage stage() => program.stage(_idxStage);

  Future addHandler(String uid, Function handler) async {
    await _connect.addHandler(uid, handler);
  }

  Future removeHandler(String uid) async {
    await _connect.removeHandler(uid);
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

  void setMode(bool isAM, bool isFM, AmMode amMode, double idxFreq, Intensivity intensity) async {
    _connect.setMode(isAM, isFM, amMode, idxFreq, intensity);
  }

  int n = 0;
  void onGetData(BlockData data) {
    print('------------------------------------ getdata : ${++n}');

  }

  void onTimer(Timer timer) async {
    print('---------------------------- isPlaying: $_isPlaying      timer:  $_playingTime');
    if (_isPlaying) {
      ++_playingTime;
      if (_duration > 0 && (stageTime() >= _duration / 1000)){
        /// Если это не последний этап
        if (_idxStage + 1 < program.stagesCount()) {
          ++_idxStage;
          _setParamsStageToDevice();
          _stageStartTime = _playingTime;
          _duration = program.stage(_idxStage).duration;
        } else {
          /// Все этапы прошли - выходим
          setPower(0);
          _isPlaying = false;
          _isOver = true;
        }
      }
    }

    if (_idxStage == -1){
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
        stage.isAm, stage.isFm, stage.amMode, idxFreq, stage.intensity);
  }
}
