import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class DeviceControlScreen extends StatefulWidget {
  const DeviceControlScreen({
    super.key,
    required this.title,
    required this.device,
  });

  final String title;
  final BluetoothDevice device;

  @override
  State<DeviceControlScreen> createState() => _DeviceControlScreenState();
}

class _DeviceControlScreenState extends State<DeviceControlScreen> {
  List<int> _value = [];
  int _dataCount = 0;

  Future<void> _getServices() async {
    List<BluetoothService> services = await widget.device.discoverServices();
    for (var service in services) {
      if (service.uuid.toString() == 'ffe0') {
        var characteristics = service.characteristics;
        for (BluetoothCharacteristic c in characteristics) {
          final subscription = c.lastValueStream.listen((value) async {
            setState(() {
              _value = value;
              ++_dataCount;
            });
            // var uuid = c.uuid;
            // print('--- uuid : $uuid    value : ${value}');
          });
          widget.device.cancelWhenDisconnected(subscription);
          await c.setNotifyValue(true);
        }
      }
    }
  }

  String getValue() {
    String retval = '';
    for (int i = 0; i < _value.length; ++i) {
      retval = '$retval${_value[i]} ';
    }
    return retval;
  }

  @override
  void initState() {
    super.initState();
    _getServices();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('${widget.title}  :  ${widget.device.advName}'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Center(
            child: Column(
              children: [
                Text(
                  getValue(),
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                Text(
                  'Принято пакетов : $_dataCount',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
