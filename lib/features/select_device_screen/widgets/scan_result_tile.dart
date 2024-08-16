import 'dart:async';

import 'package:bgs_control/assets/colors/colors.dart';
import 'package:bgs_control/features/uikit/texel_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class ScanResultTile extends StatefulWidget {
  const ScanResultTile({
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
  State<ScanResultTile> createState() => _ScanResultTileState();
}

class _ScanResultTileState extends State<ScanResultTile> {
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
    var adv = widget.result.advertisementData;
    return ExpansionTile(
      title: _buildTitle(context, theme),
      subtitle: _getSubTitleButtons(context),
      children: <Widget>[
        // if (adv.advName.isNotEmpty)
        //   _buildAdvRow(context, 'Название', adv.advName),
        // if (adv.txPowerLevel != null)
        //   _buildAdvRow(context, 'Tx Power Level', '${adv.txPowerLevel}'),
        // if ((adv.appearance ?? 0) > 0)
        //   _buildAdvRow(
        //     context,
        //     'Appearance',
        //     '0x${adv.appearance!.toRadixString(16)}',
        //   ),
        // if (adv.msd.isNotEmpty)
        //   _buildAdvRow(
        //     context,
        //     'Manufacturer Data',
        //     _getNiceManufacturerData(adv.msd),
        //   ),
        // if (adv.serviceUuids.isNotEmpty)
        //   _buildAdvRow(
        //     context,
        //     'Service UUIDs',
        //     _getNiceServiceUuids(adv.serviceUuids),
        //   ),
        // if (adv.serviceData.isNotEmpty)
        //   _buildAdvRow(
        //     context,
        //     'Service Data',
        //     _getNiceServiceData(adv.serviceData),
        //   ),
        Container(
          padding: const EdgeInsets.only(bottom: 5),
          width: 200,
          child: TexelButton.secondary(
            onPressed: () => widget.onDelete?.call(),
            text: 'Удалить',
            icon: const Icon(Icons.delete, color: filledAccentButtonColor),
            height: 40,
          ),
        ),
      ],
    );
  }

  String _getNiceHexArray(List<int> bytes) {
    return '[${bytes.map((i) => i.toRadixString(16).padLeft(2, '0')).join(', ')}]';
  }

  String _getNiceManufacturerData(List<List<int>> data) {
    return data.map((val) => _getNiceHexArray(val)).join(', ').toUpperCase();
  }

  String _getNiceServiceData(Map<Guid, List<int>> data) {
    return data.entries
        .map((v) => '${v.key}: ${_getNiceHexArray(v.value)}')
        .join(', ')
        .toUpperCase();
  }

  String _getNiceServiceUuids(List<Guid> serviceUuids) {
    return serviceUuids.join(', ').toUpperCase();
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
              style: theme.textTheme.labelMedium,
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

  Widget _getSubTitleButtons(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _getOnOffButton(),
        // ElevatedButton(
        //   style: ElevatedButton.styleFrom(
        //     backgroundColor: Colors.teal.shade900,
        //     foregroundColor: Colors.white,
        //   ),
        //   onPressed: (widget.result.advertisementData.connectable)
        //       ? widget.onTap
        //       : null,
        //   child: _connectionState == BluetoothConnectionState.connected
        //       ? const Text('Отключить')
        //       : const Text('Подключить'),
        // ),
        const SizedBox(height: 5),
        if (_connectionState == BluetoothConnectionState.connected)
          TexelButton.accent(
            onPressed: (widget.result.advertisementData.connectable)
                ? widget.onSelect
                : null,
            text: 'Выбрать',
            width: 115,
            height: 40,
          ),
        // ElevatedButton(
        //   style: ElevatedButton.styleFrom(
        //     backgroundColor: Colors.teal.shade900,
        //     foregroundColor: Colors.white,
        //   ),
        //   onPressed: (widget.result.advertisementData.connectable)
        //       ? widget.onSelect
        //       : null,
        //   child: const Text('Выбрать'),
        // ),
      ],
    );
  }

  Widget _getOnOffButton() {
    return _connectionState == BluetoothConnectionState.connected
        ? TexelButton.secondary(
            onPressed: (widget.result.advertisementData.connectable)
                ? widget.onTap
                : null,
            text: 'Отключить',
            width: 150,
            height: 40,
          )
        : TexelButton.accent(
            onPressed: (widget.result.advertisementData.connectable)
                ? widget.onTap
                : null,
            text: 'Подключить',
            width: 150,
            height: 40,
          );
  }

  Widget _buildAdvRow(BuildContext context, String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(title, style: Theme.of(context).textTheme.bodySmall),
          const SizedBox(
            width: 12.0,
          ),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.apply(color: Colors.black),
              softWrap: true,
            ),
          ),
        ],
      ),
    );
  }
}
