import 'package:bgs_control/features/uikit/texel_button.dart';
import 'package:flutter/material.dart';

class MissingResultTile extends StatelessWidget {
  const MissingResultTile({
    super.key,
    required this.deviceName,
    required this.onDelete,
  });

  final String deviceName;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(deviceName),
      children: <Widget>[
        SizedBox(
          width: 200,
          child: TexelButton.secondary(
            text: 'Удалить',
            onPressed: () => onDelete?.call(),
            icon: const Icon(Icons.delete),
          ),
          // TextButton.icon(
          //   onPressed: () {
          //     widget.onDelete?.call();
          //   },
          //   style: deleteDeviceButtonStyle(),
          //   label: const Text('Удалить'),
          //   icon: const Icon(Icons.delete),
          // ),
        ),
      ],
    );
  }
}
