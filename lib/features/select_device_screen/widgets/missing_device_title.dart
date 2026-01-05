import 'package:flutter/material.dart';

import '../../../utils/baseutils.dart';

class MissingDeviceTitle extends StatelessWidget {
  const MissingDeviceTitle({
    super.key,
    required this.deviceName,
    required this.onDelete,
    required this.onProperty,
  });

  final String deviceName;
  final VoidCallback? onDelete;
  final VoidCallback? onProperty;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Row(
          children: [
            const SizedBox(width: 10),
            Image.asset(
              'images/device.png',
              width: 56,
              height: 56,
            ),
            const SizedBox(width: 10),
            Text(
              getShortDeviceName(deviceName),
              style: theme.textTheme.titleLarge,
            ),
            const Spacer(),
            PopupMenuButton(
              icon: const Icon(Icons.more_horiz),
              onSelected: (DeviceActions item) {
                if (item == DeviceActions.delete) {
                  onDelete?.call();
                } else if (item == DeviceActions.property){
                  onProperty?.call();
                }
              },
              itemBuilder: (BuildContext context) =>
                  <PopupMenuEntry<DeviceActions>>[
                const PopupMenuItem<DeviceActions>(
                  value: DeviceActions.delete,
                  child: ListTile(
                    leading: Icon(Icons.delete),
                    title: Text(
                      'Удалить',
                    ),
                  ),
                ),
                const PopupMenuItem<DeviceActions>(
                  value: DeviceActions.property,
                  child: ListTile(
                    leading: Icon(Icons.settings),
                    title: Text(
                      'Свойства',
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 10),
          ],
        ),
        const SizedBox(height: 6),
        const Padding(
          padding: EdgeInsets.only(left: 76),
          child: Divider(
            height: 0,
            indent: 0,
            thickness: 1,
          ),
        ),
      ],
    );
  }
}

enum DeviceActions { delete, property }
