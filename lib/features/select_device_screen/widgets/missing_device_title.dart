import 'package:flutter/material.dart';

class MissingDeviceTitle extends StatelessWidget{
  const MissingDeviceTitle({
    super.key,
    required this.deviceName,
    required this.onDelete,
  });

  final String deviceName;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    return Row(
        children: [
          Text(deviceName),
          const Spacer(),
          PopupMenuButton(
            icon: const Icon(Icons.more_horiz),
            onSelected: (DeviceActions item) {
              onDelete?.call();
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<DeviceActions>>[
              const PopupMenuItem<DeviceActions>(
                value: DeviceActions.delete,
                child: ListTile(
                  leading: Icon(Icons.delete),
                  title: Text('Удалить'),
                ),
              ),
            ],
          ),
        ],
      );
  }
}

enum DeviceActions { delete }
