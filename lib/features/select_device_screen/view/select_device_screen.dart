import 'dart:async';

import 'package:bgs_control/features/device_control_screen/view/device_control_screen.dart';
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
  List<ScanResult> _scanResults = [];

  // bool _isScanning = false;
  // late StreamSubscription<List<ScanResult>> _scanResultsSubscription;
  // late StreamSubscription<bool> _isScanningSubscription;

  @override
  void initState() {
    super.initState();

    init();

//     _scanResultsSubscription = FlutterBluePlus.scanResults.listen((results) {
//       _scanResults = results;
//       if (mounted) {
//         setState(() {});
//       }
//     }, onError: (e) {
// //      Snackbar.show(ABC.b, prettyException("Scan Error:", e), success: false);
//     });
//
//     _isScanningSubscription = FlutterBluePlus.isScanning.listen((state) {
//       _isScanning = state;
//       if (mounted) {
//         setState(() {});
//       }
//     });
//
//    onScanPressed();
  }

  void init() async {
    _scanResults = await GetIt.I<BleService>().scanningStart(update);
    await onScanPressed();
  }

  void update() {
    print('----------- update $mounted');
    if (mounted) {
      setState(() {});
    }
  }

  Future onScanPressed() async {
    GetIt.I<BleService>().bleStartScan();
    // try {
    //   await FlutterBluePlus.startScan(
    //     timeout: const Duration(seconds: 15),
    //     androidUsesFineLocation: true,
    //     withKeywords: ['BG_'],
    //   );
    // } catch (e) {
    //   // Snackbar.show(ABC.b, prettyException("Start Scan Error:", e),
    //   //     success: false);
    // }
    if (mounted) {
      setState(() {});
    }
  }

  Future onStopPressed() async {
    GetIt.I<BleService>().bleStopScan();
    // try {
    //   FlutterBluePlus.stopScan();
    // } catch (e) {
    //   // Snackbar.show(ABC.b, prettyException("Stop Scan Error:", e),
    //   //     success: false);
    // }
  }

  Future<void> onRefresh() async {
    GetIt.I<BleService>().bleStartScan();
  //  if (_isScanning == true) return;
  //  FlutterBluePlus.startScan(timeout: const Duration(seconds: 15));
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
      builder: (context) => DeviceControlScreen(
        title: 'Direct',
        device: device,
      ),
      settings: const RouteSettings(name: '/control'),
    );
    Navigator.of(context).push(route);
  }

  @override
  void dispose() {
    // _scanResultsSubscription.cancel();
    // _isScanningSubscription.cancel();
    GetIt.I<BleService>().scanningStop();

    super.dispose();
  }

  List<Widget> _buildScanResultTiles(BuildContext context) {
    return _scanResults
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
