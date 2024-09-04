import 'dart:async';

import 'package:bgs_control/repositories/methodic_programs/model/methodic_program.dart';
import 'package:bgs_control/utils/extra.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:get_it/get_it.dart';
import 'package:uuid/uuid.dart';

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
      uid: '', statsTitle: '', title: '', description: '', image: '');
  bool _isConnected = false;
  String _uuidGetData = '';

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

  void run() {
    if (program.uid != '' && _isConnected) {
      _uuidGetData = const Uuid().v1();
      _connect.addHandler(_uuidGetData, onGetData);

      Timer.periodic(const Duration(seconds: 1), onTimer);
    }
  }

  void stop() {
    if (program.uid != '' && _isConnected) {
      _connect.removeHandler(_uuidGetData);
    }
  }

  void pause() {
    if (program.uid != '') {}
  }

  /// Задает программу, по которой нужно двигаться
  void setProgram(MethodicProgram prg) {
    program = prg;
  }

  String deviceName() {
    return device.advName;
  }

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

  void setMode(bool isAM, bool isFM, AmMode amMode, double idxFreq, Intensity intensity) async {
    _connect.setMode(isAM, isFM, amMode, idxFreq, intensity);
  }

  void onGetData(BlockData data) {}

  void onTimer(Timer timer) async {}
}
