import 'dart:async';
import 'dart:io';

import 'package:bgs_control/features/device_info_screen/view/device_info_screen.dart';
import 'package:bgs_control/features/log_screen/view/log_screen.dart';
import 'package:bgs_control/features/select_device_screen/features/add_new_device_bottom_sheet/add_new_device_bottom_sheet.dart';
import 'package:bgs_control/features/select_device_screen/widgets/found_device_title.dart';
import 'package:bgs_control/features/select_device_screen/widgets/missing_device_title.dart';
import 'package:bgs_control/features/uikit/texel_button.dart';
import 'package:bgs_control/repositories/bgs_connect/ble_service.dart';
import 'package:bgs_control/repositories/bgs_list/bgs_list.dart';
import 'package:bgs_control/utils/extra.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:get_it/get_it.dart';

import '../../../repositories/bgs_property_storage/bgs_property_storage.dart';
import '../../../repositories/logger/communication_logger.dart';
import '../../../repositories/running_manager/device_program_executor.dart';
import '../../../repositories/running_manager/running_manager.dart';
import '../../../utils/baseutils.dart';
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

  int _devicesCount = 0;
  late BluetoothDevice _device;
  bool _isFirstRun = true;

  @override
  void dispose() {
    GetIt.I<BleService>().scanningStop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    var retval = PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        showDialog<String>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: const Text(
              'Выйти из программы?',
              textScaler: TextScaler.linear(1.0),
            ),
            actions: <Widget>[
              TexelButton.accent(
                onPressed: () => Navigator.pop(context, 'Cancel'),
                text: 'Нет',
                width: 120,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 22),
                child: TextButton(
                  onPressed: () {
                    exit(0);
                  },
                  child: const Text('Да'),
                ),
              ),
            ],
          ),
        );
      },
      child: Scaffold(
        body: SafeArea(
          child: RefreshIndicator(
            onRefresh: onRefresh,
            child: Stack(
              children: [
                _scanResultCount() > 0
                    ? Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 18),
                              child: Row(
                                children: [
                                  const SizedBox(width: 10),
                                  Text(
                                    widget.title,
                                    style: theme.textTheme.titleMedium,
                                    textScaler: const TextScaler.linear(1.0),
                                  ),
                                  const Spacer(),
                                  if (kDebugMode)
                                    GestureDetector(
                                      onTap: () {
                                        MaterialPageRoute route =
                                            MaterialPageRoute(
                                          builder: (context) => const LogScreen(
                                            title: 'Лог обмена данными',
                                          ),
                                          settings: const RouteSettings(
                                            name: '/log_comm',
                                          ),
                                        );
                                        Navigator.of(context).push(route);
                                      },
                                      child: const Icon(Icons.book),
                                    ),
                                ],
                              ),
                            ),
                            ListView(
                              padding: const EdgeInsets.only(),
                              shrinkWrap: true,
                              children: <Widget>[
                                ..._buildScanResultTiles(context),
                              ],
                            ),
                            if (_missingDevices.isNotEmpty)
                              ExpansionTile(
                                title: Text(
                                  'Подключенные ранее',
                                  style: theme.textTheme.titleSmall,
                                  textScaler: const TextScaler.linear(1.0),
                                ),
                                children: <Widget>[
                                  SizedBox(
                                    width: double.infinity,
                                    child: ListView(
                                      padding: const EdgeInsets.only(),
                                      shrinkWrap: true,
                                      children: <Widget>[
                                        ..._buildMissingDevicesTiles(context),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                          ],
                        ),
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
                            textScaler: const TextScaler.linear(1.0),
                          ),
                          const Spacer(),
                        ],
                      ),
                Positioned(
                  bottom: 10,
                  right: 20,
                  left: 20,
                  child: TexelButton.secondary(
                    text: 'Добавить стимулятор',
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

    /// Запускаем через 500 мс, чтобы, если включено несколько БГС, они все появились в списке
    Timer(const Duration(milliseconds: 500), () {
      /// Если одно устройство в списке, то сразу подключаемся на него.
      if (_devicesCount == 1 && _isFirstRun) {
        _isFirstRun = false;
        onConnectPressed(_device);
      }
    });

    return retval;
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
    _isFirstRun = true;

    /// Убрать, если захочется, чтобы автоматически переходило только в первый раз
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
      /// Если программа не завершена
      if (driver.stage().duration > -1) {
        /// Если это не индивидуальный режим
        final bool? isCont = await _showContinueProgramDialog();
        if (isCont!) {
          /// Выбрали в диалоге "Продолжить программу"
          _runSelectProgramScreen(driver, driver.program.uid);
        } else {
          /// Выбрали в диалоге "Начать новую программу"
          driver.resetProgram();
          _runSelectProgramScreen(driver, "");
        }
      } else {
        _runSelectProgramScreen(driver, "");
      }
    } else {
      _runSelectProgramScreen(driver, "");
    }

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
      ),
      settings: const RouteSettings(name: '/execute'),
    );
    Navigator.of(context).push(route);
  }

  void _runSelectProgramScreen(
      DeviceProgramExecutor driver, String uidProgram) {
    MaterialPageRoute route = MaterialPageRoute(
      builder: (context) => SelectProgramScreen(
        title: 'Выбор программы',
        driver: driver,
        uidProgram: uidProgram,
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
        title: const Text(
          'Продолжить выполнение прерванной программы?',
          textScaler: const TextScaler.linear(1.0),
        ),
        actions: <Widget>[
          TexelButton.accent(
            onPressed: () => Navigator.pop(context, false),
            text: 'Нет',
            width: 120,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22),
            child: TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Да'),
            ),
          ),
        ],
      ),
    );
  }

  void onDeletePressed(BluetoothDevice device) {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text(
          'Удалить стимулятор из списка?',
          textScaler: const TextScaler.linear(1.0),
        ),
        content: Text(
          getShortDeviceName(device.advName),
          style: const TextStyle(fontSize: 24),
          textScaler: const TextScaler.linear(1.0),
        ),
        actions: <Widget>[
          TexelButton.accent(
            onPressed: () => Navigator.pop(context, 'Cancel'),
            text: 'Отмена',
            width: 120,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22),
            child: TextButton(
              onPressed: () {
                GetIt.I<BgsList>().delete(device.advName);
                onRefresh();
                Navigator.pop(context, 'OK');
              },
              child: const Text('Да'),
            ),
          ),
        ],
      ),
    );
  }

  void onPropertyPressed(String dvcName) async {
    MaterialPageRoute route =
    MaterialPageRoute(
      builder: (context) => DeviceInfoScreen(
        title: 'Параметры стимулятора',
        dvcName: dvcName,
      ),
      settings: const RouteSettings(
        name: '/dvc_settings',
      ),
    );
    Navigator.of(context).push(route);
  }

  void onDeleteMissingPressed(String deviceName) {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text(
          'Удалить стимулятор из списка?',
          textScaler: TextScaler.linear(1.0),
        ),
        content: Text(
          getShortDeviceName(deviceName),
          style: const TextStyle(fontSize: 24),
          textScaler: const TextScaler.linear(1.0),
        ),
        actions: <Widget>[
          TexelButton.accent(
            onPressed: () => Navigator.pop(context, 'Cancel'),
            text: 'Отмена',
            width: 120,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22),
            child: TextButton(
              onPressed: () {
                GetIt.I<BgsList>().delete(deviceName);
                onRefresh();
                Navigator.pop(context, 'OK');
              },
              child: const Text('Да'),
            ),
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
      // showDragHandle: true,
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
        .map((r) {
      _device = r.device;
      return FoundDeviceTitle(
        result: r,
        onTap: () => onConnectPressed(r.device),
        onSelect: () => onSelectPressed(r.device),
        onDelete: () => onDeletePressed(r.device),
        onProperty: () => onPropertyPressed(r.device.advName),
      );
    }).toList();

    _missingDevices = [];
    for (int i = 0; i < list.length; ++i) {
      _missingDevices.add(list[i]);
    }
    for (int i = 0; i < retval.length; ++i) {
      _missingDevices.remove(retval[i].result.device.advName);
    }

    _devicesCount = retval.length;

    return retval;
  }

  List<Widget> _buildMissingDevicesTiles(BuildContext context) {
    return _missingDevices
        .map((deviceName) => MissingDeviceTitle(
              deviceName: deviceName,
              onDelete: () => onDeleteMissingPressed(deviceName),
              onProperty: () => onPropertyPressed(deviceName),
            ))
        .toList();
  }
}
