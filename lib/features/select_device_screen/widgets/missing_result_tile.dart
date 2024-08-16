import 'package:bgs_control/features/uikit/styles.dart';
import 'package:flutter/material.dart';

class MissingResultTile extends StatefulWidget {
  const MissingResultTile({
    super.key,
    required this.deviceName,
    required this.onDelete,
  });

  final String deviceName;
  final VoidCallback? onDelete;

  @override
  State<MissingResultTile> createState() => _MissingResultTileState();
}

class _MissingResultTileState extends State<MissingResultTile> {
  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(widget.deviceName),
      children: <Widget>[
        SizedBox(
          width: 200,
          child: TextButton.icon(
            onPressed: () {
              widget.onDelete?.call();
            },
            style: deleteDeviceButtonStyle(),
            label: const Text('Удалить'),
            icon: const Icon(Icons.delete),
          ),
        ),
      ],
    );
  }
}
