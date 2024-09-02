import 'package:bgs_control/repositories/methodic_programs/model/methodic_program.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class DeviceDriver{
  DeviceDriver({
    required this.device,
    required this.program,
  });

  final BluetoothDevice device;
  final MethodicProgram program;

  void run(){

  }

  void stop(){

  }

  void pause(){

  }
}