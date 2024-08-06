import 'dart:async';

import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class BleService {
  BleService();

  List<ScanResult> _scanResults = [];
  late StreamSubscription<List<ScanResult>> _scanResultsSubscription;
  late StreamSubscription<bool> _isScanningSubscription;
  bool _isScanning = false;

  Future<List<ScanResult>> scanningStart(Function update) async {
    _scanResultsSubscription = FlutterBluePlus.scanResults.listen((results) {
      _scanResults = results;
      update();
    }, onError: (e) {
//      Snackbar.show(ABC.b, prettyException("Scan Error:", e), success: false);
    });

    _isScanningSubscription = FlutterBluePlus.isScanning.listen((state) {
      _isScanning = state;
      update();
    });

    return _scanResults;
  }

  void scanningStop() {
    _scanResultsSubscription.cancel();
    _isScanningSubscription.cancel();
  }

  void bleStartScan() async {
    if (_isScanning) return;
    try {
      await FlutterBluePlus.startScan(
        timeout: const Duration(seconds: 15),
        androidUsesFineLocation: true,
        withKeywords: ['BG_'],
      );
    } catch (e) {
      // Snackbar.show(ABC.b, prettyException("Start Scan Error:", e),
      //     success: false);
    }
  }

  void bleStopScan() async {
    try {
      FlutterBluePlus.stopScan();
    } catch (e) {
      // Snackbar.show(ABC.b, prettyException("Stop Scan Error:", e),
      //     success: false);
    }
  }
}
