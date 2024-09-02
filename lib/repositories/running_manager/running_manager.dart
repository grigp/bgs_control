import 'package:flutter_blue_plus/flutter_blue_plus.dart';

import 'device_driver.dart';

class RunningManager {
  List<DeviceDriver> _control = [];

  /// Открывает устройство и создает драйвет в списке
  DeviceDriver openDevice(BluetoothDevice device) {
    /// Ищем в списке и возвращаем, если есть
    for (int i = 0; i < _control.length; ++i) {
      if (_control[i].deviceName() == device.advName) {
        return _control[i];
      }
    }

    /// Не нашли - создаем новый
    var retval = DeviceDriver(device: device);
    _control.add(retval);
    return retval;
  }

  void closeDevice(BluetoothDevice device) {
    for (int i = 0; i < _control.length; ++i) {
      if (_control[i].deviceName() == device.advName){
        _control.removeAt(i);
        break;
      }
    }
  }

}