import 'dart:async';

import 'package:bgs_control/features/direct_control_screen/view/direct_control_screen.dart';
import 'package:bgs_control/features/select_device_screen/features/add_new_device_bottom_sheet/add_new_device_bottom_sheet.dart';
import 'package:bgs_control/features/select_device_screen/widgets/missing_result_tile.dart';
import 'package:bgs_control/features/uikit/styles.dart';
import 'package:bgs_control/features/uikit/texel_button.dart';
import 'package:bgs_control/repositories/bgs_connect/ble_service.dart';
import 'package:bgs_control/repositories/bgs_list/bgs_list.dart';
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

  List<String> _missingDevices = [];
  bool _isShowMissingDevices = false;

  @override
  void dispose() {
    GetIt.I<BleService>().scanningStop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          style: theme.textTheme.titleMedium,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: RefreshIndicator(
          onRefresh: onRefresh,
          child: Stack(
            children: [
              _scanResultCount() > 0
                  ? Column(
                      children: [
                        // const SizedBox(height: 40),
                        // SizedBox(
                        //   width: 200,
                        //   height: 200,
                        //   child: Image.asset('images/connected_device.png'),
                        // ),
                        // Expanded(
                        //   child: ListView(
                        // Text(
                        //   'Доступные стимуляторы',
                        //   style: TextStyle(
                        //     fontSize: 20,
                        //     color: Colors.teal.shade900,
                        //   ),
                        // ),
                        ListView(
                          shrinkWrap: true,
                          children: <Widget>[
                            ..._buildScanResultTiles(context),
                            const SizedBox(height: 50),
                          ],
                        ),
//                        ),
                        if (_missingDevices.isNotEmpty)
                          SizedBox(
                            width: double.infinity,
                            height: 20,
                            child: ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  _isShowMissingDevices =
                                      !_isShowMissingDevices;
                                });
                              },
                              child: (_isShowMissingDevices)
                                  ? const Icon(Icons.arrow_drop_up)
                                  : const Icon(Icons.arrow_drop_down),
                            ),
                          ),
                        if (_missingDevices.isNotEmpty && _isShowMissingDevices)
                          Text(
                            'Подключенные ранее стимуляторы',
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.teal.shade900,
                            ),
                          ),
                        if (_missingDevices.isNotEmpty && _isShowMissingDevices)
                          ListView(
                            shrinkWrap: true,
                            children: <Widget>[
                              ..._buildMissingDevicesTiles(context),
                              const SizedBox(height: 50),
                            ],
                          ),
                      ],
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Spacer(),
                        SizedBox(
                          width: 250,
                          height: 250,
                          child: Image.asset('images/connect_device.png'),
                        ),
                        const Center(
                          child: SizedBox(
                            width: 150,
                            height: 150,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'Поиск стимуляторов',
                          style: theme.textTheme.headlineMedium,
                        ),
                        const Spacer(),
                      ],
                    ),
              Positioned(
                bottom: 20,
                right: 20,
                left: 20,
                child: TexelButton.accent(
                  text: 'Добавить устройство',
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (BuildContext context) {
                        return const AddNewDeviceBottomSheet();
                      },
                      showDragHandle: true,
                    );
                  },
                ),
                // ElevatedButton(
                //   onPressed: () {
                //     showModalBottomSheet(
                //       context: context,
                //       builder: (BuildContext context) {
                //         return const AddNewDeviceBottomSheet();
                //       },
                //       barrierColor: Colors.teal.shade900,
                //       showDragHandle: true,
                //     );
                //   },
                //   style: _scanResultCount() > 0
                //       ? controlButtonStyleSecondary
                //       : controlButtonStylePrimary,
                //   child: const Text(
                //     'Добавить устройство',
                //     style: TextStyle(fontSize: 18),
                //   ),
                // ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void init() {
    try {
      GetIt.I<BleService>().scanningStart(update);
    } catch (e) {
      //      Snackbar.show(ABC.b, prettyException("Scan Error:", e), success: false);
    }
    onScanPressed();
  }

  void update() async {
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> onScanPressed() async {
    try {
      await GetIt.I<BleService>().bleStartScan();
    } catch (e) {
      // Snackbar.show(ABC.b, prettyException("Start Scan Error:", e),
      //     success: false);
    }
    setState(() {});
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
    setState(() {});
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

  void onDeletePressed(BluetoothDevice device) {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Удалить стимулятор из списка?'),
        content: Text(
          device.advName,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w900,
            color: Colors.teal.shade900,
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'Cancel'),
            style: messageButtonStylePrimary(),
            child: const Text('Отмена'),
          ),
          TextButton(
            onPressed: () {
              GetIt.I<BgsList>().delete(device.advName);
              onRefresh();
              Navigator.pop(context, 'OK');
            },
            style: messageButtonStyleSecondary(),
            child: const Text('ОК'),
          ),
        ],
      ),
    );
  }

  void onDeleteMissingPressed(String deviceName) {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Удалить стимулятор из списка?'),
        content: Text(
          deviceName,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w900,
            color: Colors.teal.shade900,
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'Cancel'),
            style: messageButtonStylePrimary(),
            child: const Text('Отмена'),
          ),
          TextButton(
            onPressed: () {
              GetIt.I<BgsList>().delete(deviceName);
              onRefresh();
              Navigator.pop(context, 'OK');
            },
            style: messageButtonStyleSecondary(),
            child: const Text('ОК'),
          ),
        ],
      ),
    );
  }

  int _scanResultCount() {
    var l = GetIt.I<BgsList>().getList();
    var list = GetIt.I<BleService>()
        .scanResultList
        .value
        .where(
          (r) => l.contains(r.device.advName),
        )
        .map(
          (r) => r.device.advName,
        )
        .toList();
    return list.length;
  }

  List<Widget> _buildScanResultTiles(BuildContext context) {
    var list = GetIt.I<BgsList>().getList();
    var retval = GetIt.I<BleService>()
        .scanResultList
        .value
        .where((r) => list.contains(r.device.advName))
        .map(
          (r) => ScanResultTile(
            result: r,
            onTap: () => onConnectPressed(r.device),
            onSelect: () => onSelectPressed(r.device),
            onDelete: () => onDeletePressed(r.device),
          ),
        )
        .toList();

    _missingDevices = [];
    for (int i = 0; i < list.length; ++i) {
      _missingDevices.add(list[i]);
    }
    for (int i = 0; i < retval.length; ++i) {
      _missingDevices.remove(retval[i].result.device.advName);
    }
    return retval;
  }

  List<Widget> _buildMissingDevicesTiles(BuildContext context) {
    return _missingDevices
        .map((deviceName) => MissingResultTile(
              deviceName: deviceName,
              onDelete: () => onDeleteMissingPressed(deviceName),
            ))
        .toList();
  }
}
