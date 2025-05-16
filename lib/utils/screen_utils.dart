import 'package:flutter/material.dart';

import '../features/uikit/texel_button.dart';

Future<bool?> isWorkToGo(BuildContext context) async {
  return await showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) => AlertDialog(
      title: const Text(
        'Перейти в режим автономной работы?',
      ),
      content: const Text(
        'При этом воздействие будет продолжено',
      ),
      actions: <Widget>[
        TexelButton.accent(
          onPressed: () async {
            Navigator.pop(context, true);
          },
          text: 'Да',
          width: 120,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 22),
          child: TextButton(
            onPressed: () {
              Navigator.pop(context, false);
            },
            child: const Text(
              'Нет',
            ),
            // width: 120,
          ),
        ),
      ],
    ),
  );
}
