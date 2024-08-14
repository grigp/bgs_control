import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class BluetoothOffScreen extends StatelessWidget {
  final BluetoothAdapterState adapterState;

  const BluetoothOffScreen({
    super.key,
    required this.adapterState,
  });

  @override
  Widget build(BuildContext context) {
    String? state = adapterState.toString().split(".").last;
    return ScaffoldMessenger(
      child: Scaffold(
        backgroundColor: Colors.lightBlue,
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Icon(
                Icons.bluetooth_disabled,
                size: 200.0,
                color: Colors.white54,
              ),
              Text(
                'Адаптер Bluetooth $state не доступен',
                style: Theme.of(context)
                    .primaryTextTheme
                    .titleSmall
                    ?.copyWith(color: Colors.white),
              ),
              if (Platform.isAndroid)
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: ElevatedButton(
                    child: const Text('Включить'),
                    onPressed: () async {
                      try {
                        await FlutterBluePlus.turnOn();
                      } catch (e) {
//            Snackbar.show(ABC.a, prettyException("Ошибка включения:", e), success: false);
                      }
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
