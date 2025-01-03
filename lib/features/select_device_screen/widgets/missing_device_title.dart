import 'package:flutter/material.dart';

import '../../../utils/baseutils.dart';

class MissingDeviceTitle extends StatelessWidget {
  const MissingDeviceTitle({
    super.key,
    required this.deviceName,
    required this.onDelete,
  });

  final String deviceName;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Row(
          children: [
            const SizedBox(width: 10),
            Image.asset(
              'lib/assets/bgs/BGS_64.png',
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
                onDelete?.call();
              },
              itemBuilder: (BuildContext context) =>
                  <PopupMenuEntry<DeviceActions>>[
                const PopupMenuItem<DeviceActions>(
                  value: DeviceActions.delete,
                  child: ListTile(
                    leading: Icon(Icons.delete),
                    title: Text(
                      'Удалить',
                      textScaler: TextScaler.linear(1.0),
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

enum DeviceActions { delete }
