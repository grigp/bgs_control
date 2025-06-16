import 'package:flutter/material.dart';

import '../texel_button.dart';

Future<bool?> shutdownByLowLevelBatteryDialog(BuildContext context) async {
  return await showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) => AlertDialog(
      title: const Text(
        'Предупреждение',
        style: TextStyle(fontSize: 24),
        textScaler:  TextScaler.linear(1.0),
      ),
      content: const Text(
        'Стимулятор отключился из за низкого заряда аккумулятора.',
        style: TextStyle(fontSize: 20),
        textScaler:  TextScaler.linear(1.0),
      ),
      actions: <Widget>[
        TexelButton.accent(
          onPressed: () => Navigator.pop(context, false),
          text: 'Закрыть',
          width: 120,
        ),
      ],
    ),
  );
}
