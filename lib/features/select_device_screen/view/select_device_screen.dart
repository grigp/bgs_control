import 'dart:async';

import 'package:bgs_control/features/device_control_screen/view/device_control_screen.dart';
import 'package:bgs_control/features/direct_control_screen/view/direct_control_screen.dart';
import 'package:bgs_control/repositories/bgs_connect/ble_service.dart';
import 'package:bgs_control/utils/extra.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:get_it/get_it.dart';

import '../widgets/scan_result_tile.dart';

class SelectDeviceScreen extends StatefulWidget {
  const SelectDeviceScreen({
    super.key,
    required this.title,
  });

  final String title;

  @override
  State<StatefulWidget> createState() => _SelectDeviceScreenState();
}

class _SelectDeviceScreenState extends State<SelectDeviceScreen> {

  @override
  void initState() {
    super.initState();

    init();
  }

  void init() {
    try {
      GetIt.I<BleService>().scanningStart(update);
    } catch (e) {
      //      Snackbar.show(ABC.b, prettyException("Scan Error:", e), success: false);
    }
    onScanPressed();
  }

  void update() async { //  это не надо скорее всего
    if (mounted) {
      setState(() {});  //  это не надо скорее всего
    }
  }

  Future<void> onScanPressed() async {
    try {
      await GetIt.I<BleService>().bleStartScan();
    } catch (e) {
      // Snackbar.show(ABC.b, prettyException("Start Scan Error:", e),
      //     success: false);
    }
    setState(() {});  //  это не надо скорее всего
  }

  Future onStopPressed() async {
    try {
      GetIt.I<BleService>().bleStopScan();
    } catch (e) {
      // Snackbar.show(ABC.b, prettyException("Stop Scan Error:", e),
      //     success: false);
    }
  }

  Future<void> onRefresh() async {
    await GetIt.I<BleService>().bleStartScan();
    setState(() {});  //  это не надо скорее всего
  }

  void onConnectPressed(BluetoothDevice device) {
    if (!device.isConnected) {
      device.connectAndUpdateStream().catchError((e) {
        // Snackbar.show(ABC.c, prettyException("Connect Error:", e),
        //     success: false);
      });
      // Переход на следующий экран
      // MaterialPageRoute route = MaterialPageRoute(
      //     builder: (context) => DeviceScreen(device: device),
      //     settings: RouteSettings(name: '/DeviceScreen'));
      // Navigator.of(context).push(route);
    } else {
      device.disconnectAndUpdateStream().catchError((e) {});
    }
  }

  void onSelectPressed(BluetoothDevice device) {
    MaterialPageRoute route = MaterialPageRoute(
      builder: (context) => DirectControlScreen(
        title: 'Direct',
        device: device,
      ),
      settings: const RouteSettings(name: '/direct_control'),
    );
    Navigator.of(context).push(route);

    device.connectionState.listen((event) {
      if (event == BluetoothConnectionState.disconnected) {
        Navigator.of(context).popUntil(ModalRoute.withName('/select'));
        // try {
        //   Navigator.of(context).popUntil(ModalRoute.withName('/select'));
        // } catch (e) {
        //   print('---------------- error this page is active -----------------------------');
        // }
      }
    });
  }

  @override
  void dispose() {
    GetIt.I<BleService>().scanningStop();
    super.dispose();
  }

  List<Widget> _buildScanResultTiles(BuildContext context) {
    return GetIt.I<BleService>().scanResultList.value
        .map(
          (r) => ScanResultTile(
            result: r,
            onTap: () => onConnectPressed(r.device),
            onSelect: () => onSelectPressed(r.device),
          ),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: RefreshIndicator(
        onRefresh: onRefresh,
        child: ListView(
          children: <Widget>[..._buildScanResultTiles(context)],
        ),
      ),
    );
  }
}
