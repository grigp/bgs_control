import 'dart:async';
import 'dart:io';

import 'package:bgs_control/features/log_screen/view/log_screen.dart';
import 'package:bgs_control/features/select_device_screen/features/add_new_device_bottom_sheet/add_new_device_bottom_sheet.dart';
import 'package:bgs_control/features/select_device_screen/widgets/found_device_title.dart';
import 'package:bgs_control/features/select_device_screen/widgets/missing_device_title.dart';
import 'package:bgs_control/features/uikit/styles.dart';
import 'package:bgs_control/features/uikit/texel_button.dart';
import 'package:bgs_control/repositories/bgs_connect/ble_service.dart';
import 'package:bgs_control/repositories/bgs_list/bgs_list.dart';
import 'package:bgs_control/repositories/methodic_programs/model/methodic_program.dart';
import 'package:bgs_control/utils/extra.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:get_it/get_it.dart';

import '../../../repositories/logger/communication_logger.dart';
import '../../../repositories/running_manager/device_program_executor.dart';
import '../../../repositories/running_manager/running_manager.dart';
import '../../execute_screen/view/execute_screen.dart';
import '../../select_program_screen/view/select_program_screen.dart';

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

    /// Если у нас нет своих стимуляторов то вызовем диалог добавления
    Future.delayed(const Duration(milliseconds: 500)).then((_) {
      var list = GetIt.I<BgsList>().getList();
      if (list.isEmpty) {
        _addDeviceDialog(context);
      }
    });
  }

  List<String> _missingDevices = [];
  bool _isShowMissingDevices = false;
  late StreamSubscription _subsDisconnect;

  @override
  void dispose() {
    GetIt.I<BleService>().scanningStop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        showDialog<String>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: const Text('Выйти из программы?'),
            actions: <Widget>[
              TexelButton.accent(
                onPressed: () => Navigator.pop(context, 'Cancel'),
                text: 'Нет',
                width: 120,
              ),
              TexelButton.secondary(
                onPressed: () {
                  exit(0);
                },
                text: 'Да',
                width: 120,
              ),
            ],
          ),
        );
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            widget.title,
            style: theme.textTheme.titleMedium,
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                MaterialPageRoute route = MaterialPageRoute(
                  builder: (context) => const LogScreen(
                    title: 'Лог обмена данными',
                  ),
                  settings: const RouteSettings(name: '/log_comm'),
                );
                Navigator.of(context).push(route);
              },
              child: const Icon(Icons.book),
            ),
          ],
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
                          ListView(
                            shrinkWrap: true,
                            children: <Widget>[
                              ..._buildScanResultTiles(context),
                              const SizedBox(height: 50),
                            ],
                          ),
                          if (_missingDevices.isNotEmpty)
                            ExpansionTile(
                              title: Text(
                                'Подключенные ранее',
                                style: theme.textTheme.titleLarge,
                              ),
                              children: <Widget>[
                                SizedBox(
                                  width: double.infinity,
                                  height: 200,
                                  child: ListView(
                                    shrinkWrap: true,
                                    children: <Widget>[
                                      ..._buildMissingDevicesTiles(context),
                                      const SizedBox(height: 50),
                                    ],
                                  ),
                                )
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
                  child: TexelButton.secondary(
                    //.accent(
                    text: 'Добавить устройство',
                    onPressed: () {
                      _addDeviceDialog(context);
                    },
                  ),
                ),
              ],
            ),
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

  void onConnectPressed(BluetoothDevice device) async {
    if (!device.isConnected) {
      await device.connectAndUpdateStream().catchError((e) {
        // Snackbar.show(ABC.c, prettyException("Connect Error:", e),
        //     success: false);
      });
      GetIt.I<CommunicationLogger>().log('-- connect');
      onSelectPressed(device);

      // Переход на следующий экран
      // MaterialPageRoute route = MaterialPageRoute(
      //     builder: (context) => DeviceScreen(device: device),
      //     settings: RouteSettings(name: '/DeviceScreen'));
      // Navigator.of(context).push(route);
    } else {
      device.disconnectAndUpdateStream().catchError((e) {});
    }
  }

  void onSelectPressed(BluetoothDevice device) async {
    var driver = GetIt.I<RunningManager>().openDevice(device);

    if (!driver.isOver()) {
      final bool? isCont = await _showContinueProgramDialog();
      if (isCont!) {
        _runExecuteScreen(driver);
      } else {
        driver.resetProgram();
        _runSelectProgramScreen(driver);
      }
    } else {
      _runSelectProgramScreen(driver);
    }
    // _runSelectProgramScreen(driver);

    // MaterialPageRoute route = MaterialPageRoute(
    //   builder: (context) => SelectProgramScreen(
    //     title: 'Выбор методики',
    //     driver: driver,
    //   ),
    //   settings: const RouteSettings(name: '/select_method'),
    // );
    // Navigator.of(context).push(route);

    /// Будем получать сообщения о дисконнекте
    _subsDisconnect = device.connectionState.listen((event) {
      if (event == BluetoothConnectionState.disconnected) {
        GetIt.I<CommunicationLogger>().log('-- disconnect');
        Navigator.of(context).popUntil(ModalRoute.withName('/select'));
        subsDisconnectStop();
        // try {
        //   Navigator.of(context).popUntil(ModalRoute.withName('/select'));
        // } catch (e) {
        //   print('---------------- error this page is active -----------------------------');
        // }
      }
    });
  }

  void _runExecuteScreen(DeviceProgramExecutor driver) {
    MaterialPageRoute route = MaterialPageRoute(
      builder: (context) => ExecuteScreen(
        title: 'Execution',
        driver: driver,
        isSetProgram: false,
      ),
      settings: const RouteSettings(name: '/execute'),
    );
    Navigator.of(context).push(route);
  }

  void _runSelectProgramScreen(DeviceProgramExecutor driver) {
    MaterialPageRoute route = MaterialPageRoute(
      builder: (context) => SelectProgramScreen(
        title: 'Выбор методики',
        driver: driver,
      ),
      settings: const RouteSettings(name: '/select_method'),
    );
    Navigator.of(context).push(route);
  }

  void subsDisconnectStop() {
    _subsDisconnect.cancel();
  }

  Future<bool?> _showContinueProgramDialog() async {
    return await showDialog<bool>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Продолжить выполнение прерванной программы?'),
        actions: <Widget>[
          TexelButton.accent(
            onPressed: () => Navigator.pop(context, false),
            text: 'Нет',
            width: 120,
          ),
          TexelButton.accent(
            onPressed: () => Navigator.pop(context, true),
            text: 'Да',
            width: 120,
          ),
        ],
      ),
    );
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
          TexelButton.accent(
            onPressed: () => Navigator.pop(context, 'Cancel'),
            text: 'Отмена',
            width: 120,
          ),
          TexelButton.secondary(
            onPressed: () {
              GetIt.I<BgsList>().delete(device.advName);
              onRefresh();
              Navigator.pop(context, 'OK');
            },
            text: 'OK',
            width: 120,
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
          TexelButton.accent(
            onPressed: () => Navigator.pop(context, 'Cancel'),
            text: 'Отмена',
            width: 120,
          ),
          TexelButton.secondary(
            onPressed: () {
              GetIt.I<BgsList>().delete(deviceName);
              onRefresh();
              Navigator.pop(context, 'OK');
            },
            text: 'OK',
            width: 120,
          ),
        ],
      ),
    );
  }

  void _addDeviceDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return const AddNewDeviceBottomSheet();
      },
      showDragHandle: true,
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
          (r) => FoundDeviceTitle(
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
        .map((deviceName) => MissingDeviceTitle(
              deviceName: deviceName,
              onDelete: () => onDeleteMissingPressed(deviceName),
            ))
        .toList();
  }
}
