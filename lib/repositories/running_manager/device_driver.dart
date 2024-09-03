import 'package:bgs_control/repositories/methodic_programs/model/methodic_program.dart';
import 'package:bgs_control/utils/extra.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:get_it/get_it.dart';

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

  /// Запуск программы
  void connect() {
    if (!_isConnected){
      GetIt.I<BgsConnect>().init(device);
      device.connectionState.listen((event) {
        _isConnected = event == BluetoothConnectionState.connected;
      });
    }
  }

  void disconnect() {
    if (_isConnected){
      if (_isConnected) {
        GetIt.I<BgsConnect>().reset();
        GetIt.I<BgsConnect>().stop();

        device.disconnectAndUpdateStream().catchError((e) {});
      }
    }
  }

  void run(){
    if (program.uid != '' && _isConnected){
    }
  }

  void stop(){
    if (program.uid != '' && _isConnected){
    }
  }

  void pause() {
    if (program.uid != ''){

    }
  }

  void setProgram(MethodicProgram prg) {
    program = prg;
  }

  String deviceName(){
    return device.advName;
  }

}
