import 'dart:async';

import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class BgsConnect{
  BgsConnect({required this.device, required this.sendData}){
    _init();
  }

  final BluetoothDevice device;
  List<int> _value = [];
  late Function sendData;
  late BluetoothCharacteristic _characteristic;

  int _curPower = 0;
  int _targetPower = 0;
  
  Future<void> _init() async {
    List<BluetoothService> services = await device.discoverServices();
    services.forEach((service) async {
      if (service.uuid.toString() == 'ffe0') {
        var characteristics = service.characteristics;
        for (BluetoothCharacteristic c in characteristics) {
          _characteristic = c;
          final subscription = c.lastValueStream.listen((value) async {
            _value = value;
            sendData(_value);
            // setState(() {
            //   _value = value;
            //   ++_dataCount;
            // });
            // var uuid = c.uuid;
            // print('--- uuid : $uuid    value : ${value}');
          });

          device.cancelWhenDisconnected(subscription);
          await c.setNotifyValue(true);
        }
      }
    });
  }

  Future<void> write(List<int> command) async {
    await _characteristic.write(command);
  }

  void setPower(double power) {
    _targetPower = power.toInt();
    _curPower = _value[5];
    if (power != _curPower) {
      Timer.periodic(const Duration(milliseconds: 1000),
          (timer) {
            if (_curPower < _targetPower){
              ++_curPower;
            } else {
              --_curPower;
            }
            write([0x91, _curPower]);
            if (_curPower == _targetPower){
              timer.cancel();
            }
          }  
      );
    }
  }

}