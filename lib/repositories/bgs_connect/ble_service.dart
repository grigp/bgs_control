import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class BleService {
  BleService();

  ValueListenable<List<ScanResult>> get scanResultList => _scanResultList;
  int get scanResultListSize => _scanResults.length;
  final _scanResultList = ValueNotifier<List<ScanResult>>([]);

  List<ScanResult> _scanResults = []; //  это не надо скорее всего
  late StreamSubscription<List<ScanResult>> _scanResultsSubscription;
  late StreamSubscription<bool> _isScanningSubscription;
  bool _isScanning = false;

  List<ScanResult> scanningStart(Function update) {
    _scanResultsSubscription = FlutterBluePlus.scanResults.listen((results) {
      _scanResults = results;
      _scanResultList.value = results;
      update();
    }, onError: (e) {
      throw e;
//      Snackbar.show(ABC.b, prettyException("Scan Error:", e), success: false);
    });

    _isScanningSubscription = FlutterBluePlus.isScanning.listen((state) {
      _isScanning = state;
      update();//  это не надо скорее всего
    });

    return _scanResults;
  }

  void scanningStop() {
    _scanResultsSubscription.cancel();
    _isScanningSubscription.cancel();
  }

  Future<void> bleStartScan() async {
    if (_isScanning) return;
    try {
      await FlutterBluePlus.startScan(
        timeout: const Duration(seconds: 15),
        androidUsesFineLocation: true,
        // withKeywords: ['BG_'],
      );
    } catch (e) {
      // Snackbar.show(ABC.b, prettyException("Start Scan Error:", e),
      //     success: false);
    }
  }

  Future<void> bleStopScan() async {
    try {
      await FlutterBluePlus.stopScan();
    } catch (e) {
      // Snackbar.show(ABC.b, prettyException("Stop Scan Error:", e),
      //     success: false);
    }
  }
}
