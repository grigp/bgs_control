import 'dart:async';

import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class BgsConnect{
  BgsConnect(){
  }

  late BluetoothDevice device;
  List<int> _value = [0,0,0,0,0,0,0,0,0,0,0,0,0,0];
  late Function sendData;
  late BluetoothCharacteristic _characteristic;
  late StreamSubscription _subscription;

  int _curPower = 0;
  int _targetPower = 0;
  bool _isSending = false;
  
  Future<void> init(BluetoothDevice device, Function sendData) async {
    this.device = device;
    this.sendData = sendData;

    List<BluetoothService> services = await device.discoverServices();
    services.forEach((service) async {
      if (service.uuid.toString() == 'ffe0') {
        var characteristics = service.characteristics;
        for (BluetoothCharacteristic c in characteristics) {
          _characteristic = c;
          _isSending = true;
          final subscription = c.lastValueStream.listen((value) async {
            if (_isSending && value.length == 14) {
              _value = value;
              sendData(_value);
            }
            // setState(() {
            //   _value = value;
            //   ++_dataCount;
            // });
            // var uuid = c.uuid;
            // print('--- uuid : $uuid    value : ${value}');
          });

          _subscription = subscription;
          device.cancelWhenDisconnected(subscription);
          await c.setNotifyValue(true);

          reset();
        }
      }
    });
  }

  void stop() {
    _isSending = false;
    _subscription.cancel();
  }

  Future<void> write(List<int> command) async {
    if (_isSending) {
      await _characteristic.write(command, withoutResponse: true);
    }
  }

  void setPower(double power) {
    _targetPower = power.toInt();
    _curPower = _value[5];
    if (power != _curPower) {
      Timer.periodic(const Duration(milliseconds: 1000),
          (timer) async {
            if (_curPower < _targetPower){
              ++_curPower;
            } else {
              _curPower = _targetPower;
            }
            await write([0x91, _curPower]);
            if (_curPower == _targetPower){
              timer.cancel();
            }
          }  
      );
    }
  }

  void reset() async {
    await write([0x91, 0x00]);
  }

  void setMode(int idxAM, int idxFM, int idxIntencity) async {
    await write([0xA1, idxAM]);
    await write([0xA2, idxFM]);
    await write([0xA3, idxIntencity]);
  }
}