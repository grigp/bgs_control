import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';


class FoundDeviceTitle extends StatefulWidget {
  const FoundDeviceTitle({
    super.key,
    required this.result,
    this.onTap,
    this.onSelect,
    this.onDelete,
  });

  final ScanResult result;
  final VoidCallback? onTap;
  final VoidCallback? onSelect;
  final VoidCallback? onDelete;

  @override
  State<FoundDeviceTitle> createState() => _FoundDeviceTitleState();
}

class _FoundDeviceTitleState extends State<FoundDeviceTitle> {
  BluetoothConnectionState _connectionState =
      BluetoothConnectionState.disconnected;

  late StreamSubscription<BluetoothConnectionState>
      _connectionStateSubscription;

  @override
  void initState() {
    super.initState();

    _connectionStateSubscription =
        widget.result.device.connectionState.listen((state) {
      _connectionState = state;
      setState(() {});
    });
  }

  @override
  void dispose() {
    _connectionStateSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        GestureDetector(
          onTap: () {
            if (widget.result.advertisementData.connectable) {
              widget.onTap?.call();
            }
          },
          child: _buildTitle(context, theme),
        ),
        const Spacer(),
        PopupMenuButton(
          icon: const Icon(Icons.more_horiz),
          onSelected: (PopupMenu item) {
            widget.onDelete?.call();
          },
          itemBuilder: (BuildContext context) => <PopupMenuEntry<PopupMenu>>[
            const PopupMenuItem<PopupMenu>(
              value: PopupMenu.delete,
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

  Widget _buildTitle(BuildContext context, ThemeData theme) {
    if (widget.result.device.platformName.isNotEmpty) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(
              left: 0,
              top: 10,
              right: 10,
              bottom: 10,
            ),
            child: Text(
              widget.result.device.platformName,
              style: theme.textTheme.headlineLarge,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          // _buildConnectButton(context),
        ],
      );
    } else {
      return Text(widget.result.device.remoteId.str);
    }
  }

}

enum PopupMenu { delete }
