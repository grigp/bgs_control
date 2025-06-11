import 'dart:async';
import 'dart:io';

import 'package:bgs_control/features/device_info_screen/view/device_info_screen.dart';
import 'package:bgs_control/features/log_screen/view/log_screen.dart';
import 'package:bgs_control/features/select_device_screen/features/add_new_device_bottom_sheet/add_new_device_bottom_sheet.dart';
import 'package:bgs_control/features/select_device_screen/widgets/found_device_title.dart';
import 'package:bgs_control/features/select_device_screen/widgets/missing_device_title.dart';
import 'package:bgs_control/features/uikit/texel_button.dart';
import 'package:bgs_control/repositories/app_monitor/app_monitor.dart';
import 'package:bgs_control/repositories/bgs_connect/ble_service.dart';
import 'package:bgs_control/repositories/bgs_list/bgs_list.dart';
import 'package:bgs_control/repositories/methodic_programs/model/methodic_program.dart';
import 'package:bgs_control/utils/extra.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:get_it/get_it.dart';

import '../../../repositories/logger/communication_logger.dart';
import '../../../repositories/running_manager/device_program_executor.dart';
import '../../../repositories/running_manager/running_manager.dart';
import '../../../utils/base_defines.dart';
import '../../../utils/baseutils.dart';
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
    GetIt.I<BgsList>().setNotifier(_onBgsListUpdated);

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
    var retval = PopScope<Object?>(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, Object? result) async {
        if (didPop) {
          return;
        }
        final bool shouldPop = await _showBackDialog() ?? false;
        if (context.mounted && shouldPop) {
          exit(0);
        }
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
//                                  if (kDebugMode)
                                  GestureDetector(
                                    onTap: () {
                                      pushScreen(
                                        context,
                                        (context, animation,
                                                secondaryAnimation) =>
                                            const LogScreen(
                                          title: 'Лог обмена данными',
                                        ),
                                        '/log_comm',
                                        ShiftDirection.rightToLeft,
                                      );
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
    await _onRefresh(true);
  }

  Future<void> _onRefresh(bool isFirstRun) async {
    _isFirstRun = isFirstRun;

    /// Убрать, если захочется, чтобы автоматически переходило только в первый раз
    await GetIt.I<BleService>().bleStartScan();
    setState(() {});
  }

  void onConnectPressed(BluetoothDevice device) async {
    if (!device.isConnected) {
      bool connectErr = false;
      await device.connectAndUpdateStream().catchError((e) {
        connectErr = true;
        // Snackbar.show(ABC.c, prettyException("Connect Error:", e),
        //     success: false);
      });
      if (logSubject == LogSubject.lsComm || logSubject == LogSubject.lsAll) {
        GetIt.I<CommunicationLogger>().log('-- connect : ${device.advName}');
      }
      onSelectPressed(device);
    } else {
      device.disconnectAndUpdateStream().catchError((e) {});
    }
  }

  void onSelectPressed(BluetoothDevice device) async {
    var driver = GetIt.I<RunningManager>().openDevice(device);

    _runSelectProgramScreen(driver, "");

    /// Будем получать сообщения о дисконнекте
    _subsDisconnect = device.connectionState.listen(
      (event) async {
        if (event == BluetoothConnectionState.disconnected) {
          _onDisconnect(device);
        } else if (event == BluetoothConnectionState.connected) {
          if (kDebugMode) {
            print(
                '!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! onSelectPressed.connect');
          }
        }
      },
    );
  }

  /// Действия по дисконнекту
  void _onDisconnect(BluetoothDevice device) async {
    if (kDebugMode) {
      print(
          '!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! onSelectPressed.disconnect');
    }
    if (logSubject == LogSubject.lsComm || logSubject == LogSubject.lsAll) {
      GetIt.I<CommunicationLogger>().log('-- disconnect : ${device.advName}');
    }
    var dn = GetIt.I<RunningManager>().getConnectedDeviceName();
    if (dn == device.advName) {
      GetIt.I<RunningManager>().disconnectDevice(dn);

      /// Сообщение об обрыве связи
      //    await _alertConnectionFailure();
      if (kDebugMode) {
        print('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!');
        print('   communication failure : $dn');
        print('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!');
      }

      Navigator.of(context).popUntil(ModalRoute.withName('/select'));

      Timer(const Duration(seconds: 2), () {
        if (kDebugMode) {
          print('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!');
          print('!!!!!               reconnect                      !!!!!!!!!');
          print('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!');
        }
        onConnectPressed(device);
      });
    }

    // try {
    //   Navigator.of(context).popUntil(ModalRoute.withName('/select'));
    // } catch (e) {
    //   print('---------------- error this page is active -----------------------------');
    // }

    _subsDisconnectStop();
  }

  void _runSelectProgramScreen(
      DeviceProgramExecutor driver, String uidProgram) {
    bool isRunned =
        GetIt.I<AppMonitor>().isWindowOpened(AppWindows.awSelectProgram);
    if (!isRunned) {
      pushScreen(
        context,
        (context, animation, secondaryAnimation) => SelectProgramScreen(
          title: 'Выбор программы',
          driver: driver,
          uidProgram: uidProgram,
        ),
        '/select_method',
        ShiftDirection.rightToLeft,
      );
    }
  }

  void _subsDisconnectStop() {
    _subsDisconnect.cancel();
  }

  Future<bool?> _showContinueProgramDialog() async {
    return await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => AlertDialog(
        title: const Text(
          'Продолжить выполнение прерванной программы?',
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
              child: const Text(
                'Да',
              ),
            ),
          ),
        ],
      ),
    );
  }

  void onDeletePressed(BluetoothDevice device) {
    showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => AlertDialog(
        title: const Text(
          'Удалить стимулятор из списка?',
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
              onPressed: () async {
                await GetIt.I<BgsList>().delete(device.advName);
                _onRefresh(false);
                Navigator.pop(context, 'OK');
              },
              child: const Text(
                'Да',
              ),
            ),
          ),
        ],
      ),
    );
  }

  void onPropertyPressed(String dvcName) async {
    pushScreen(
      context,
      (context, animation, secondaryAnimation) => DeviceInfoScreen(
        title: 'Параметры стимулятора',
        dvcName: dvcName,
      ),
      '/dvc_settings',
      ShiftDirection.rightToLeft,
    );
  }

  void onDeleteMissingPressed(String deviceName) {
    showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => AlertDialog(
        title: const Text(
          'Удалить стимулятор из списка?',
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
                _onRefresh(false);
                Navigator.pop(context, 'OK');
              },
              child: const Text(
                'Да',
              ),
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
      return Visibility(
        visible: list.contains(r.device.advName),
        child: FoundDeviceTitle(
          result: r,
          onTap: () => onConnectPressed(r.device),
          onSelect: () => onSelectPressed(r.device),
          onDelete: () => onDeletePressed(r.device),
          onProperty: () => onPropertyPressed(r.device.advName),
        ),
      );
    }).toList();

    _missingDevices = [];
    for (int i = 0; i < list.length; ++i) {
      _missingDevices.add(list[i]);
    }
    for (int i = 0; i < retval.length; ++i) {
      _missingDevices
          .remove((retval[i].child as FoundDeviceTitle).result.device.advName);
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

  Future<bool?> _showBackDialog() {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => AlertDialog(
        title: const Text(
          'Выйти из программы?',
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
              child: const Text(
                'Да',
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onBgsListUpdated() {
    setState(() {
      _isFirstRun = false;
    });
  }

  Future _alertConnectionFailure() async {
    await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Предупреждение'),
        titleTextStyle: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
        content: const Text(
            'Произошло отключение от стимулятора из за проблем со связью.\n'
            'Поднесите телефон ближе к стимулятору и подключите его заново'),
        contentTextStyle: const TextStyle(
          fontSize: 20,
          color: Colors.black,
        ),
        actions: <Widget>[
          TexelButton.accent(
            onPressed: () => Navigator.pop(context, 'Ok'),
            text: 'OK',
            width: 120,
          ),
        ],
      ),
    );
  }
}
