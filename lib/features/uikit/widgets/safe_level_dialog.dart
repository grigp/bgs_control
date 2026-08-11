import 'package:flutter/material.dart';

import '../../../generated/l10n.dart';
import '../texel_button.dart';

Future<bool?> safeLevelDialog(BuildContext context) async {
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
        S.of(context).askSafeLevel,
        style: const TextStyle(fontSize: 20),
        textScaler:  const TextScaler.linear(1.0),
      ),
      actions: <Widget>[
        TexelButton.accent(
          onPressed: () => Navigator.pop(context, false),
          text: S.of(context).no,
          width: 120,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 22),
          child: TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(
              S.of(context).yes,
            ),
            // width: 120,
          ),
        ),
      ],
    ),
  );
}
