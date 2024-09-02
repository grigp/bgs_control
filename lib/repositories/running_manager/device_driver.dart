import 'package:bgs_control/repositories/methodic_programs/model/methodic_program.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

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

  /// Запуск программы
  void run() {
    if (program.uid != ''){

    }
  }

  void stop() {
    if (program.uid != ''){

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
