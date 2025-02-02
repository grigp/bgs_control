import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

import '../../../utils/baseutils.dart';

class FoundDeviceTitle extends StatefulWidget {
  const FoundDeviceTitle({
    super.key,
    required this.result,
    this.onTap,
    this.onSelect,
    this.onDelete,
    this.onProperty,
  });

  final ScanResult result;
  final VoidCallback? onTap;
  final VoidCallback? onSelect;
  final VoidCallback? onDelete;
  final VoidCallback? onProperty;

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
    return GestureDetector(
      onTap: () {
        if (widget.result.advertisementData.connectable) {
          widget.onTap?.call();
        }
      },
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.transparent,
        ),
        child: Column(
          children: [
            Row(
              children: [
                const SizedBox(width: 10),
                _buildTitle(context, theme),
                const Spacer(),
                PopupMenuButton(
                  icon: const Icon(Icons.more_horiz),
                  onSelected: (DeviceActions item) {
                    if (item == DeviceActions.delete) {
                      widget.onDelete?.call();
                    } else if (item == DeviceActions.property){
                      widget.onProperty?.call();
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
            const Padding(
              padding: EdgeInsets.only(left: 76),
              child: Divider(
                height: 0,
                indent: 0,
                thickness: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTitle(BuildContext context, ThemeData theme) {
    if (kDebugMode) {
      print('>>>>>>>>> ${widget.result.device.advName}');
    }
    if (widget.result.device.advName.isNotEmpty) {
      //platformName.isNotEmpty) {
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
            child: Row(
              children: [
                Image.asset(
                  'lib/assets/bgs/BGS_128.png',
                  width: 56,
                  height: 56,
                ),
                const SizedBox(width: 10),
                Text(
                  'texel № ${getStimulatorNumber(widget.result.device.advName)}', //.platformName)}',
                  style: theme.textTheme.titleLarge,
                  overflow: TextOverflow.ellipsis,
                  textScaler: const TextScaler.linear(1.0),
                ),
              ],
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

enum DeviceActions { delete, property }
