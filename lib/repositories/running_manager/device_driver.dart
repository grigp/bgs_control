import 'dart:async';

import 'package:bgs_control/repositories/methodic_programs/model/methodic_program.dart';
import 'package:bgs_control/utils/extra.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:get_it/get_it.dart';
import 'package:uuid/uuid.dart';

import '../bgs_connect/bgs_connect.dart';

/// Класс управления устроййством - драйвер
class DeviceDriver {
  /// При создании задается только устройство, программа назначается позже
  /// И при одном сеансе могут быть назначены разные программы
  DeviceDriver({
    required this.device,
  });

  final BluetoothDevice device;
  late MethodicProgram program = MethodicProgram(
      uid: '', statsTitle: '', title: '', description: '', image: '');
  bool _isConnected = false;
  String _uuidGetData = '';

  /// Запуск программы
  void connect() {
    // if (!_isConnected) {  События в stream(.listen) срабатывает до connect при последующих запусках
      GetIt.I<BgsConnect>().init(device);
      device.connectionState.listen((event) {
        _isConnected = event == BluetoothConnectionState.connected;
      });
    // }
  }

  void disconnect() {
    // if (_isConnected) {
      GetIt.I<BgsConnect>().reset();
      GetIt.I<BgsConnect>().stop();
      _isConnected = false;

      device.disconnectAndUpdateStream().catchError((e) {});
    // }
  }

  void run() {
    if (program.uid != '' && _isConnected) {
      _uuidGetData = const Uuid().v1();
      GetIt.I<BgsConnect>().addHandler(_uuidGetData, onGetData);

      Timer.periodic(const Duration(seconds: 1), onTimer);
    }
  }

  void stop() {
    if (program.uid != '' && _isConnected) {
      GetIt.I<BgsConnect>().removeHandler(_uuidGetData);
    }
  }

  void pause() {
    if (program.uid != '') {}
  }

  void setProgram(MethodicProgram prg) {
    program = prg;
  }

  String deviceName() {
    return device.advName;
  }

  void onGetData(BlockData data) {}

  void onTimer(Timer timer) async {}
}
