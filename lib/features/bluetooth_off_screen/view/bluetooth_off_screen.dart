import 'dart:io';

import 'package:bgs_control/assets/colors/colors.dart';
import 'package:bgs_control/features/uikit/texel_button.dart';
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
        backgroundColor: backgroundTestColor,
        body: SafeArea(
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const Icon(
                  Icons.bluetooth_disabled,
                  size: 200.0,
                  color: black,
                ),
                Padding(
                  padding: const EdgeInsets.all(14),
                  child: Text(
                    'Включите Bluetooth, чтобы подключить стимулятор',
                    style: Theme.of(context)
                        .primaryTextTheme
                        .titleMedium
                        ?.copyWith(color: black),
                    textAlign: TextAlign.center,
                  ),
                ),
                if (Platform.isAndroid)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 20,
                    ),
                    child: TexelButton.black(
                      text: 'Включить',
                      onPressed: () async {
                        try {
                          await FlutterBluePlus.turnOn();
                        } catch (e) {
                          // Snackbar.show(ABC.a, prettyException("Ошибка включения:", e), success: false);
                        }
                      },
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
