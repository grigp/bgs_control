import 'package:flutter/material.dart';

import '../texel_button.dart';

Future<bool?> safeLevelDialog(BuildContext context) async {
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
        'Увеличение мощности воздействия может быть небезопасным.\nПродолжить увеличение мощности воздействия?',
        style: TextStyle(fontSize: 20),
        textScaler:  TextScaler.linear(1.0),
      ),
      actions: <Widget>[
        TexelButton.accent(
          onPressed: () => Navigator.pop(context, false),
          text: 'Нет',
          width: 120,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 22),
          child: TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              'Да',
            ),
            // width: 120,
          ),
        ),
      ],
    ),
  );
}
