import 'package:bgs_control/repositories/bgs_connect/ble_service.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import 'widgets/wgt_main.dart';
import 'widgets/wgt_wait.dart';

class AddNewDeviceBottomSheet extends StatefulWidget {
  const AddNewDeviceBottomSheet({
    super.key,
  });

  @override
  State<AddNewDeviceBottomSheet> createState() => _AddNewDeviceBottomSheet();
}

class _AddNewDeviceBottomSheet extends State<AddNewDeviceBottomSheet> {
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

  @override
  Widget build(BuildContext context) {
    List<String> list = GetIt.I<BleService>()
        .scanResultList
        .value
        .map(
          (r) => r.device.advName,
        )
        .toList();

    return (list.isNotEmpty) ? WgtMain(list: list) : const WgtWait();
  }

  void update() async {
    setState(() {});
  }

  Future<void> onScanPressed() async {
    try {
      await GetIt.I<BleService>().bleStartScan();
    } catch (e) {
      // Snackbar.show(ABC.b, prettyException("Start Scan Error:", e),
      //     success: false);
    }
    setState(() {}); //  это не надо скорее всего
  }
}
