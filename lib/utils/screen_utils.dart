import 'package:flutter/material.dart';

import '../features/uikit/texel_button.dart';
import '../generated/l10n.dart';

Future<bool?> isWorkToGo(BuildContext context) async {
  return await showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) => AlertDialog(
      title: Text(
        S.of(context).askSwitchToOfflineMode,
      ),
      content: Text(
        S.of(context).stimulationWillBeContinue,
      ),
      actions: <Widget>[
        TexelButton.accent(
          onPressed: () async {
            Navigator.pop(context, true);
          },
          text: S.of(context).yes,
          width: 120,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 22),
          child: TextButton(
            onPressed: () {
              Navigator.pop(context, false);
            },
            child: Text(
              S.of(context).no,
            ),
            // width: 120,
          ),
        ),
      ],
    ),
  );
}
