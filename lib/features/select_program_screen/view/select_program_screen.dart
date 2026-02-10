import 'dart:async';

import 'package:bgs_control/features/execute_screen/view/execute_screen.dart';
import 'package:bgs_control/features/program_params_screen/view/program_params_screen.dart';
import 'package:bgs_control/features/select_program_screen/widgets/direct_title.dart';
import 'package:bgs_control/features/select_program_screen/widgets/program_title.dart';
import 'package:bgs_control/features/select_program_screen/widgets/togo_title.dart';
import 'package:bgs_control/features/togo_params_screen/view/togo_params_screen.dart';
import 'package:bgs_control/repositories/app_monitor/app_monitor.dart';
import 'package:bgs_control/repositories/methodic_programs/model/methodic_program.dart';
import 'package:bgs_control/repositories/methodic_programs/storage/program_storage.dart';
import 'package:bgs_control/repositories/methodic_programs/storage/select_program_manager.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:uuid/uuid.dart';

import '../../../assets/colors/colors.dart';
import '../../../dev/LogUtils.dart';
import '../../../repositories/bgs_connect/bgs_connect.dart';
import '../../../repositories/logger/communication_logger.dart';
import '../../../repositories/methodic_programs/model/select_item_info.dart';
import '../../../repositories/running_manager/device_program_executor.dart';
import '../../../repositories/running_manager/running_manager.dart';
import '../../../utils/Constants.dart';
import '../../../utils/baseutils.dart';
import '../../../utils/charge_values.dart';
import '../../device_info_screen/view/device_info_screen.dart';
import '../../direct_control_screen/view/direct_control_screen.dart';
import '../../uikit/texel_button.dart';
import '../../uikit/widgets/back_screen_button.dart';
import '../../uikit/widgets/charge_message_widget.dart';

class SelectProgramScreen extends StatefulWidget {
  const SelectProgramScreen({
    super.key,
    required this.title,
    required this.driver,
    required this.uidProgram,
  });

  final String title;
  final DeviceProgramExecutor driver;
  final String uidProgram;

  @override
  State<SelectProgramScreen> createState() => _SelectProgramScreenState();
}

class _SelectProgramScreenState extends State<SelectProgramScreen>
    with TickerProviderStateMixin {
  List<MethodicProgram> _programs = [];
  List<SelectItemInfo> _selectItems = [];

  bool _isConnected = false;
  String _uuidGetData = '';
  double _chargeLevel = 101;
  double _chargeValue = 0;
  int _curMethodic = 0;

  late PageController _pageViewController;
  late TabController _tabController;
  int _currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    /// ToDO: нехорошо. надо думать, как избавиться от этого сообщения при проведении программы
    if (kDebugMode) {
      print(
          '======================================= select program build =========================');
    }

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, Object? result) async {
        if (didPop) {
          return;
        }
        GetIt.I<RunningManager>()
            .disconnectDevice(widget.driver.device.advName);
        Navigator.pop(context);
      },
      child: Scaffold(
        backgroundColor: backgroundTestColor,
        body: SafeArea(
          bottom: false,
          child: Stack(
            children: [
              if (_chargeValue > 0)
                Container(
                  width: double.infinity,
                  color: backgroundTestColor,
                  child: Image.asset(
                    'images/select_method.png',
                    fit: BoxFit.cover,
                  ),
                ),
              Positioned(
                top: 10,
                left: 10,
                child: BackScreenButton(
                  onBack: () {
                    GetIt.I<RunningManager>()
                        .disconnectDevice(widget.driver.device.advName);
                    Navigator.pop(context);
                  },
                  hasBackground: true,
                ),
              ),
              if (_chargeValue > 0)
                Column(
                  mainAxisAlignment: MainAxisAlignment.start, //.center,
                  children: <Widget>[
                    Expanded(
                      flex: 4,
                      child: Container(),
                    ),
                    Expanded(
                      flex: 6,
                      child: Container(
                        decoration: BoxDecoration(
                          color: backgroundColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Stack(
                          alignment: Alignment.bottomCenter,
                          children: <Widget>[
                            PageView(
                              controller: _pageViewController,
                              onPageChanged: _handlePageViewChanged,
                              children: <Widget>[
                                Center(child: _getAvaiableProgramWidget()),
                                Center(child: _getSelectProgramWidget()),
                              ],
                            ),
                            PageIndicator(
                              tabController: _tabController,
                              currentPageIndex: _currentPageIndex,
                              onUpdateCurrentPageIndex: _updateCurrentPageIndex,
                              isOnDesktopAndWeb: _isOnDesktopAndWeb,
                            ),
                          ],
                        ),

                        //                      child: _getSelectProgramWidget(),
                      ),
                    ),
                  ],
                ),
              if (_chargeValue == 0)
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Spacer(),
                    SizedBox(
                      width: 160,
                      height: 160,
                      child: Image.asset('images/connect_to_device.png'),
                    ),
                    const Spacer(),
                    const Center(
                      child: SizedBox(
                        width: 150,
                        height: 150,
                        child: CircularProgressIndicator(
                          strokeWidth: 8,
                          strokeCap: StrokeCap.round,
                          color: black,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      'Подключение к стимулятору ${getShortDeviceName(widget.driver.deviceName())}',
                      style: theme.textTheme.headlineMedium,
                      textAlign: TextAlign.center,
                      textScaler: const TextScaler.linear(1.0),
                    ),
                    const Spacer(),
                    const SizedBox(height: 20),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  /// Возвращает виджет со списком программ
  Widget _getAvaiableProgramWidget() {
    final theme = Theme.of(context);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 8,
          ),
          child: Row(
            children: [
              Text(
                'Доступные программы',
                style: theme.textTheme.titleMedium,
                textScaler: const TextScaler.linear(1.0),
              ),
              const Spacer(),
              if (_chargeValue > 0)
                GestureDetector(
                  onTap: () {
                    pushScreen(
                      context,
                      (context, animation, secondaryAnimation) =>
                          DeviceInfoScreen(
                        title: 'Параметры стимулятора',
                        dvcName: widget.driver.deviceName(),
                      ),
                      '/dvc_settings',
                      ShiftDirection.rightToLeft,
                    );
                  },
                  child: Row(
                    children: [
                      if (_chargeLevel <= Constants.chargeAlarmBoundLevel)
                        Icon(
                          Icons.warning,
                          color: Colors.red.shade800,
                        ),
                      Icon(
                        getChargeIconByLevel(_chargeLevel),
                        size: 16,
                        color: _chargeLevel > Constants.chargeAlarmBoundLevel
                            ? Colors.black
                            : Colors.red.shade800,
                      ),
                      Text(
                        '${_chargeLevel.toInt()}%',
                        style: TextStyle(
                          fontSize: 14,
                          color: _chargeLevel > Constants.chargeAlarmBoundLevel
                              ? Colors.black
                              : Colors.red.shade800,
                        ),
                        textScaler: const TextScaler.linear(1.0),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
        if (_chargeLevel <= Constants.chargeAlarmBoundLevel)
          const ChargeMessageWidget(),
        const Divider(
          height: 0,
          indent: 0,
          thickness: 1,
        ),
        Expanded(
          child: SafeArea(
            child: ListView(
              padding: const EdgeInsets.only(bottom: 20),
              shrinkWrap: true,
              children: <Widget>[
                ..._buildProgramTiles(context),
                ..._buildHandleProgram(context),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// Возвращает виджет со списком программ
  Widget _getSelectProgramWidget() {
    final theme = Theme.of(context);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 8,
          ),
          child: Row(
            children: [
              Text(
                'Выберите желаемый тип воздействия',
                style: theme.textTheme.titleMedium,
                textScaler: const TextScaler.linear(1.0),
              ),
              const Spacer(),
              if (_chargeValue > 0)
                GestureDetector(
                  onTap: () {
                    pushScreen(
                      context,
                          (context, animation, secondaryAnimation) =>
                          DeviceInfoScreen(
                            title: 'Параметры стимулятора',
                            dvcName: widget.driver.deviceName(),
                          ),
                      '/dvc_settings',
                      ShiftDirection.rightToLeft,
                    );
                  },
                  child: Row(
                    children: [
                      if (_chargeLevel <= Constants.chargeAlarmBoundLevel)
                        Icon(
                          Icons.warning,
                          color: Colors.red.shade800,
                        ),
                      Icon(
                        getChargeIconByLevel(_chargeLevel),
                        size: 16,
                        color: _chargeLevel > Constants.chargeAlarmBoundLevel
                            ? Colors.black
                            : Colors.red.shade800,
                      ),
                      Text(
                        '${_chargeLevel.toInt()}%',
                        style: TextStyle(
                          fontSize: 14,
                          color: _chargeLevel > Constants.chargeAlarmBoundLevel
                              ? Colors.black
                              : Colors.red.shade800,
                        ),
                        textScaler: const TextScaler.linear(1.0),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
        if (_chargeLevel <= Constants.chargeAlarmBoundLevel)
          const ChargeMessageWidget(),
        const Divider(
          height: 0,
          indent: 0,
          thickness: 1,
        ),
        Expanded(
          child: SafeArea(
            child: ListView(
              padding: const EdgeInsets.only(bottom: 20),
              shrinkWrap: true,
              children: <Widget>[
                ..._buildSelectProgramMenu(context),
               ],
            ),
          ),
        ),
      ],
    );
  }

  Future alertLowEnergy() async {
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
            'Низкий заряд аккумулятора.\nСтимулятор может отключиться в любой момент'),
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

  @override
  void initState() {
    super.initState();
    _pageViewController = PageController();
    _tabController = TabController(length: 2, vsync: this);

    GetIt.I<AppMonitor>().setWindowStatus(AppWindows.awSelectProgram, true);
    readPrograms();
    _readSelectProgramItems();
    _initConnect();
  }

  @override
  void dispose() {
    GetIt.I<AppMonitor>().setWindowStatus(AppWindows.awSelectProgram, false);
    _doDispose();
    _pageViewController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  Future _doDispose() async {
    GetIt.I<RunningManager>().disconnectDevice(widget.driver.device.advName);
    _isConnected = false;
    await widget.driver.removeHandler(_uuidGetData);
    await widget.driver.disconnect();
  }

  void readPrograms() async {
    _programs = GetIt.I<ProgramStorage>().getPrograms();
  }

  void _readSelectProgramItems() async {
    _selectItems = await GetIt.I<SelectProgramManager>().getItemsByParent(-1);
  }

  void _initConnect() async {
    if (await widget.driver.connect()) {
      _uuidGetData = const Uuid().v1();
      widget.driver.addHandler(_uuidGetData, onGetData);
      _isConnected = true;

      /// Запуск программы автоматически, если указан ее uid
      if (widget.uidProgram != "") {
        for (int i = 0; i < _programs.length; ++i) {
          if (widget.uidProgram == _programs[i].uid) {
            Timer(
              const Duration(milliseconds: 100),
              () async {
                if (_chargeLevel <= Constants.chargeBreakBoundLevel) {
                  await alertLowEnergy();
                }
                _runProgramWithParams(_programs[i]);
              },
            );
          }
        }
      }
    }
  }

  void _showLostConnectError() {
    showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => AlertDialog(
        title: const Text(
          'Не удалось подключиться к стимулятору',
        ),
        content: const Text(
          'Попробуйте повторить попытку',
        ),
        actions: <Widget>[
          TexelButton.accent(
            onPressed: () => Navigator.pop(context, 'Cancel'),
            text: 'Ок',
            width: 120,
          ),
        ],
      ),
    );
  }

  void onGetData(BlockData data) {
    if (_isConnected) {
      if (kDebugMode) {
        print(
            '<<<<<<<<<<<<<< sps:onGetData.  met: "${data.methodUid}" met old: $_curMethodic     ${data.stage} - ${data.playingTime} >>>>>>>>>>>>>>>>');
      }

      /// На приборе выполняется одна из методик
      if (data.methodUid != _curMethodic && data.methodUid > 0) {
        /// Запустить одну из предустановленных методик
        if (data.methodUid < methodicUidToGo) {
          var idx = _getMethodisIdx(data.methodUid);
          if (idx >= 0) {
            _curMethodic = data.methodUid;
            _runProgram(_programs[idx]);
          }
        } else

        /// Запустить индивидуальный режим
        if (data.methodUid == methodicUidToGo) {
          _curMethodic = data.methodUid;
          var program = MethodicProgram.togo(data.isAM, data.isFM, data.amMode,
              data.intensivity, data.freq, 0);
          _runProgram(program);
        } else

        /// Запустить режим прямого управления
        if (data.methodUid == methodicUidDirect) {
          _curMethodic = data.methodUid;
          _runDirectControl(false);
        }
      }
      setState(() {
        _chargeLevel = data.chargeLevel;
        _chargeValue = data.chargeValue;
      });
    } else {
      if (logSubject == LogSubject.lsComm || logSubject == LogSubject.lsAll) {
        GetIt.I<CommunicationLogger>()
            .log('SelectProgramScreen.onGetData - set state after dispose');
      }
    }
  }

  /// Возвращает индекс методики с uid == uidMethodic и -1, если не нашла
  int _getMethodisIdx(int uidMethodic) {
    for (int i = 0; i < _programs.length; ++i) {
      if (int.parse(_programs[i].uid) == uidMethodic) {
        return i;
      }
    }
    return -1;
  }

  List<Widget> _buildProgramTiles(BuildContext context) {
    return _programs
        .mapIndexed(
          (program, index) => ProgramTitle(
            program: program,
            isLast: index == _programs.length - 1,
            onTap: () async {
              if (_chargeLevel <= Constants.chargeBreakBoundLevel) {
                await alertLowEnergy();
              }

              /// Если запустили повторно незавершенную программу
              if (program.uid == widget.driver.program.uid &&
                  widget.driver.playingTime() > 0) {
                /// Спросим, надо ли ее продолжить
                final bool? isCont = await _showContinueProgramDialog();

                /// И, если не надо
                if (!isCont!) {
                  /// Сбросить программу
                  widget.driver.resetProgram();
                }
              }

              /// Ну и запустить экран выполнения
              _curMethodic = int.parse(program.uid);
              _runProgramWithParams(program);
            },
          ),
        )
        .toList();
  }

  List<Widget> _buildHandleProgram(BuildContext context) {
    List<Widget> list = [];
    //list.add(TogoTitle(onTap: _runToGoMode));
    list.add(
      DirectTitle(
        onTap: () async {
          final bool? isRun = await _askRunDCMode();
          if (isRun!) {
            _runDirectControl(true);
          }
        },
      ),
    );
    return list;
  }

  List<Widget> _buildSelectProgramMenu(BuildContext context) {
    return _programs
        .mapIndexed(
          (program, index) => ProgramTitle(
        program: program,
        isLast: index == _programs.length - 1,
        onTap: () async {
          if (_chargeLevel <= Constants.chargeBreakBoundLevel) {
            await alertLowEnergy();
          }

          /// Если запустили повторно незавершенную программу
          if (program.uid == widget.driver.program.uid &&
              widget.driver.playingTime() > 0) {
            /// Спросим, надо ли ее продолжить
            final bool? isCont = await _showContinueProgramDialog();

            /// И, если не надо
            if (!isCont!) {
              /// Сбросить программу
              widget.driver.resetProgram();
            }
          }

          /// Ну и запустить экран выполнения
          _curMethodic = int.parse(program.uid);
          _runProgramWithParams(program);
        },
      ),
    )
        .toList();
  }

  void _runToGoMode() async {
    if (_chargeLevel <= Constants.chargeBreakBoundLevel) {
      await alertLowEnergy();
    }
    _curMethodic = methodicUidToGo;
    pushScreen(
      context,
      (context, animation, secondaryAnimation) => TogoParamsScreen(
        title: 'Индивидуальный режим',
        driver: widget.driver,
      ),
      '/togo_control',
      ShiftDirection.rightToLeft,
    );
  }

  void _runDirectControl(bool isNewProgram) async {
    if (_chargeLevel <= Constants.chargeBreakBoundLevel) {
      await alertLowEnergy();
    }
    _curMethodic = methodicUidDirect;
    pushScreen(
      context,
      (context, animation, secondaryAnimation) => DirectControlScreen(
        title: 'Direct',
        driver: widget.driver,
        isNewProgram: isNewProgram,
      ),
      '/direct_control',
      ShiftDirection.rightToLeft,
    );
  }

  Future<bool?> _askRunDCMode() async {
    return await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Запустить выполнение произвольной программы?'),
        actions: <Widget>[
          TexelButton.accent(
            onPressed: () => Navigator.pop(context, true),
            text: 'Да',
            width: 120,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22),
            child: TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text(
                'Нет',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<bool?> _showContinueProgramDialog() async {
    return await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Продолжить выполнение прерванной программы?'),
        actions: <Widget>[
          TexelButton.accent(
            onPressed: () => Navigator.pop(context, true),
            text: 'Да',
            width: 120,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22),
            child: TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text(
                'Нет',
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Запускает программу с использованием окан параметров программы
  void _runProgramWithParams(MethodicProgram program) {
    pushScreen(
      context,
      (context, animation, secondaryAnimation) => ProgramParamsScreen(
        title: 'Программа ${program.title}',
        driver: widget.driver,
        program: program,
      ),
      '/program_control',
      ShiftDirection.rightToLeft,
    );
  }

  /// Запускает программу напрямую
  void _runProgram(MethodicProgram program) {
    pushScreen(
      context,
      (context, animation, secondaryAnimation) => ExecuteScreen(
        title: 'Execution',
        driver: widget.driver,
        program: program,
        isNewProgram: false,
      ),
      '/execute',
      ShiftDirection.rightToLeft,
    );
  }

  void _handlePageViewChanged(int currentPageIndex) {
    if (!_isOnDesktopAndWeb) {
      return;
    }
    _tabController.index = currentPageIndex;
    setState(() {
      _currentPageIndex = currentPageIndex;
    });
  }

  void _updateCurrentPageIndex(int index) {
    _tabController.index = index;
    _pageViewController.animateToPage(
      index,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }

  bool get _isOnDesktopAndWeb => true;
// bool get _isOnDesktopAndWeb =>
//     kIsWeb ||
//     switch (defaultTargetPlatform) {
//       TargetPlatform.macOS ||
//       TargetPlatform.linux ||
//       TargetPlatform.windows =>
//         true,
//       TargetPlatform.android ||
//       TargetPlatform.iOS ||
//       TargetPlatform.fuchsia =>
//         false,
//     };
}

class PageIndicator extends StatelessWidget {
  const PageIndicator({
    super.key,
    required this.tabController,
    required this.currentPageIndex,
    required this.onUpdateCurrentPageIndex,
    required this.isOnDesktopAndWeb,
  });

  final int currentPageIndex;
  final TabController tabController;
  final void Function(int) onUpdateCurrentPageIndex;
  final bool isOnDesktopAndWeb;

  @override
  Widget build(BuildContext context) {
    if (!isOnDesktopAndWeb) {
      return const SizedBox.shrink();
    }
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          IconButton(
            splashRadius: 16.0,
            padding: EdgeInsets.zero,
            onPressed: () {
              if (currentPageIndex == 0) {
                return;
              }
              onUpdateCurrentPageIndex(currentPageIndex - 1);
            },
            icon: const Icon(
              Icons.arrow_left_rounded,
              size: 32.0,
              color: filledAccentButtonColor,
            ),
          ),
          TabPageSelector(
            controller: tabController,
            color: colorScheme.surface,
            indicatorSize: 12,
            selectedColor: filledAccentButtonColor, //colorScheme.primary,
          ),
          IconButton(
            splashRadius: 16.0,
            padding: EdgeInsets.zero,
            onPressed: () {
              if (currentPageIndex == 1) {
                return;
              }
              onUpdateCurrentPageIndex(currentPageIndex + 1);
            },
            icon: const Icon(
              Icons.arrow_right_rounded,
              size: 32.0,
              color: filledAccentButtonColor,
            ),
          ),
        ],
      ),
    );
  }
}

extension ExtendedIterable<E> on Iterable<E> {
  Iterable<T> mapIndexed<T>(T Function(E e, int i) f) {
    var i = 0;
    return map((e) => f(e, i++));
  }
}
