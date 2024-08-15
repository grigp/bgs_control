import 'dart:async';

import 'package:bgs_control/utils/styles.dart';
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
    var adv = widget.result.advertisementData;
    return ExpansionTile(
      title: _buildTitle(context),
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

  Widget _buildTitle(BuildContext context) {
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
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w900,
                color: Colors.teal.shade900,
              ),
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
    return Row(
      children: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.teal.shade900,
            foregroundColor: Colors.white,
          ),
          onPressed: (widget.result.advertisementData.connectable)
              ? widget.onTap
              : null,
          child: _connectionState == BluetoothConnectionState.connected
              ? const Text('Отключить')
              : const Text('Подключить'),
        ),
        const Spacer(flex: 1),
        if (_connectionState == BluetoothConnectionState.connected)
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.teal.shade900,
              foregroundColor: Colors.white,
            ),
            onPressed: (widget.result.advertisementData.connectable)
                ? widget.onSelect
                : null,
            child: const Text('Выбрать'),
          ),
        const Spacer(flex: 2),
      ],
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
