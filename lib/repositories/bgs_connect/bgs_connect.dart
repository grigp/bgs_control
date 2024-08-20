import 'dart:async';

import 'package:flutter_blue_plus/flutter_blue_plus.dart';

import '../../utils/charge_values.dart';
import 'package:uuid/data.dart';
import 'package:uuid/uuid.dart';
import 'package:uuid/rng.dart';
enum AmMode { am_11, am_31, am_51 }

enum Intensity { one, two, free, four }

Map<AmMode, String> amModeNames = <AmMode, String>{
  AmMode.am_11: '1:1',
  AmMode.am_31: '3:1',
  AmMode.am_51: '5:1',
};

Map<double, double> freqValue = <double, double>{
  0: 15,
  1: 30,
  2: 60,
  3: 90,
  4: 120,
  5: 180,
  6: 350
};

/// Класс функций, вызываемых при получении данных
class Handler {
  const Handler({
    required this.uid,
    required this.handler,
  });

  final String uid;
  final Function handler;
}

/// Режим работы при потере связи
/// cfmResetPower - сбрасывать мощность
/// cfmWorking - продолжать работу
enum ConnectionFailureMode { cfmResetPower, cfmWorking }

/// Класс пакета данных от устройства
class BlockData {
  const BlockData({
    required this.power,
    required this.isAM,
    required this.isFM,
    required this.amMode,
    required this.idxFreq,
    required this.isPowerReset,
    required this.intensity,
    required this.chargeLevel,
    required this.source,
  });

  final double power;
  final bool isAM;
  final bool isFM;
  final AmMode amMode;
  final double idxFreq;
  final bool isPowerReset;
  final Intensity intensity;
  final double chargeLevel;
  final List<int> source;
}

class BgsConnect {
  BgsConnect();

  late BluetoothDevice device;
  List<int> _value = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
//  late Function sendData;
  final List<Handler> _dataHandlers = [];
  late BluetoothCharacteristic _characteristic;
  late StreamSubscription _subscription;

//  late StreamSubscription<BluetoothConnectionState> _streamConnect;

  int _curPower = 0;
  int _targetPower = 0;
  bool _isSending = false;

  var uid = const Uuid().v1();  //TODO: Убрать!!!

  Future<void> init(BluetoothDevice device) async {
    this.device = device;

    // _streamConnect = device.connectionState.listen((event) {
    //   if (event == BluetoothConnectionState.disconnected) {
    //     print('--------------------------------------------------------------------------');
    //     print('--------------- ${event == BluetoothConnectionState.connected} -----------');
    //     print('--------------------------------------------------------------------------');
    //     disconnect();
    //   }
    // });

    List<BluetoothService> services = await device.discoverServices();
    for (var service in services) {
      if (service.uuid.toString() == 'ffe0') {
        var characteristics = service.characteristics;
        for (BluetoothCharacteristic c in characteristics) {
          _characteristic = c;
          _isSending = true;
          final subscription = c.lastValueStream.listen((value) async {
            if (_isSending && value.length == 14) {
              _value = value;
              for (int i = 0; i < _dataHandlers.length; ++i){
                _dataHandlers[i].handler(_createBlockData(_value));
              }
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
    }
    // services.forEach((service) async {});
  }

  // void disconnect() {
  //   _streamConnect.cancel();
  // }

  void stop() {
    _isSending = false;
    _subscription.cancel();
  }

  Future addHandler(String uid, Function handler) async {
    _dataHandlers.add(Handler(uid: uid, handler: handler));
  }

  Future removeHandler(String uid) async {
    for (int i = 0; i < _dataHandlers.length; ++i) {
      if (_dataHandlers[i].uid == uid) {
        _dataHandlers.removeAt(i);
      }
    }
  }

  Future<void> write(List<int> command) async {
    if (!_isSending) return;
    await _characteristic.write(command, withoutResponse: true);
  }

  void setPower(double power) {
    _targetPower = power.toInt();
    _curPower = _value[5];
    if (power != _curPower) {
      Timer.periodic(const Duration(milliseconds: 1000), (timer) async {
        if (_curPower < _targetPower) {
          ++_curPower;
        } else {
          _curPower = _targetPower;
        }
        await write([0x91, _curPower]);
        if (_curPower == _targetPower) {
          timer.cancel();
        }
      });
    }
  }

  void reset() async {
    await write([0x91, 0x00]);
  }

  void setConnectionFailureMode(ConnectionFailureMode mode) async {
    if (mode == ConnectionFailureMode.cfmResetPower) {
      await write([0xBB, 0x5B]);
    } else if (mode == ConnectionFailureMode.cfmWorking) {
      await write([0xBB, 0x00]);
    }
  }

  void setMode(int idxAM, int idxFM, int idxIntencity) async {
    await write([0xA1, idxAM]);
    await write([0xA2, idxFM]);
    await write([0xA3, idxIntencity]);
  }

  BlockData _createBlockData(List<int> value) {
    var power = value[5].toDouble();

    var isAM = value[9] > 0;
    AmMode amMode;
    if (isAM) {
      amMode = AmMode.values[value[9] - 1];
    } else {
      amMode = AmMode.am_11;
    }

    var isFM = value[10] == 7;
    double idxFreq = 0;
    if (!isFM) {
      idxFreq = value[10].toDouble();
    }

    bool isPowerReset = false;
    if ((value[4] & 0x80) != 0) {
      isPowerReset = true;
    }

    var intensity = Intensity.values[value[11]];
    var chargeLevel = getChargeLevelByADC(value[3]);

    return BlockData(
      power: power,
      isAM: isAM,
      isFM: isFM,
      amMode: amMode,
      idxFreq: idxFreq,
      isPowerReset: isPowerReset,
      intensity: intensity,
      chargeLevel: chargeLevel,
      source: value,
    );
  }
}
