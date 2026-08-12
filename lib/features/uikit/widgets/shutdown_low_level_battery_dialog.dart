import 'package:flutter/material.dart';

import '../../../generated/l10n.dart';
import '../texel_button.dart';

Future<bool?> shutdownByLowLevelBatteryDialog(BuildContext context) async {
  return await showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) => AlertDialog(
      title: Text(
        S.of(context).warning,
        style: const TextStyle(fontSize: 24),
        textScaler:  const TextScaler.linear(1.0),
      ),
      content: Text(
        S.of(context).stimulatorTurnedOffLowBattery,
        style: const TextStyle(fontSize: 20),
        textScaler:  const TextScaler.linear(1.0),
      ),
      actions: <Widget>[
        TexelButton.accent(
          onPressed: () => Navigator.pop(context, false),
          text: S.of(context).close,
          width: 120,
        ),
      ],
    ),
  );
}
