import 'package:flutter_blue_plus/flutter_blue_plus.dart';

import 'device_program_executor.dart';

class RunningManager {
  final List<DeviceProgramExecutor> _control = [];

  String _connectedDevice = '';

  /// Открывает устройство и создает драйвет в списке
  DeviceProgramExecutor openDevice(BluetoothDevice device) {
    _connectedDevice = device.advName;

    /// Ищем в списке и возвращаем, если есть
    for (int i = 0; i < _control.length; ++i) {
      if (_control[i].deviceName() == device.advName) {
        return _control[i];
      }
    }

    /// Не нашли - создаем новый
    var retval = DeviceProgramExecutor(device: device);
    _control.add(retval);

    return retval;
  }

  void closeDevice(BluetoothDevice device) {
    for (int i = 0; i < _control.length; ++i) {
      if (_control[i].deviceName() == device.advName) {
        _control.removeAt(i);
        break;
      }
    }
  }

  String getConnectedDeviceName() {
    return _connectedDevice;
  }

  void disconnectDevice(String dn) {
    if (dn == _connectedDevice) {
      _connectedDevice = '';
    }
  }

  void stopAll() {
    for (int i = 0; i < _control.length; ++i) {
      _control[i].reset();//.setPower(0);
    }
  }
}
