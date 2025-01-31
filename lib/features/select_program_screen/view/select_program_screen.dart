import 'dart:async';

import 'package:bgs_control/features/program_params_screen/view/program_params_screen.dart';
import 'package:bgs_control/features/select_program_screen/widgets/direct_title.dart';
import 'package:bgs_control/features/select_program_screen/widgets/program_title.dart';
import 'package:bgs_control/features/select_program_screen/widgets/togo_title.dart';
import 'package:bgs_control/features/togo_params_screen/view/togo_params_screen.dart';
import 'package:bgs_control/repositories/methodic_programs/model/methodic_program.dart';
import 'package:bgs_control/repositories/methodic_programs/storage/program_storage.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:uuid/uuid.dart';

import '../../../assets/colors/colors.dart';
import '../../../repositories/bgs_connect/bgs_connect.dart';
import '../../../repositories/logger/communication_logger.dart';
import '../../../repositories/running_manager/device_program_executor.dart';
import '../../../utils/base_defines.dart';
import '../../../utils/baseutils.dart';
import '../../../utils/charge_values.dart';
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

class _SelectProgramScreenState extends State<SelectProgramScreen> {
  List<MethodicProgram> _programs = [];

  bool _isConnected = false;
  String _uuidGetData = '';
  double _chargeLevel = 100;
  double _chargeValue = 0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            Container(
              color: backgroundTestColor,
              child: Image.asset('images/background_woman.png'),
            ),
            Positioned(
              top: 20,
              left: 20,
              child: BackScreenButton(
                onBack: () {
                  Navigator.pop(context);
                },
                hasBackground: true,
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start, //.center,
              children: <Widget>[
                const Spacer(),
                if (_chargeLevel <= chargeAlarmBoundLevel)
                  const ChargeMessageWidget(),
                Container(
                  width: double.infinity,
                  height: 500,
                  decoration: BoxDecoration(
                    color: backgroundColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
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
                            Icon(getChargeIconByLevel(_chargeLevel), size: 16),
                            Text(
                              '${_chargeLevel.toInt()}%',
                              style: theme.textTheme.titleSmall,
                              textScaler: const TextScaler.linear(1.0),
                            ),
                          ],
                        ),
                      ),
                      const Divider(
                        height: 0,
                        indent: 0,
                        thickness: 1,
                      ),
                      Expanded(
                        child: ListView(
                          padding: const EdgeInsets.only(bottom: 20),
                          shrinkWrap: true,
                          children: <Widget>[
                            ..._buildProgramTiles(context),
                            ..._buildHandleProgram(context),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void alertLowEnergy() {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Предупреждение'),
        content: const Text('Низкий заряд аккумулятора'),
        actions: <Widget>[
          TexelButton.accent(
            onPressed: () => Navigator.pop(context, 'Cancel'),
            text: 'Закрыть',
            width: 120,
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    readPrograms();
    _initConnect();
  }

  @override
  void dispose() {
    _isConnected = false;
    // TODO как-то по другому надо получать данные о зарядке
    widget.driver.removeHandler(_uuidGetData);
    widget.driver.disconnect(!widget.driver.isWorkAuto());

    super.dispose();
  }

  void readPrograms() async {
    _programs = GetIt.I<ProgramStorage>().getPrograms();
    // print('--------------- select program screen ---- ${_programs.length}');
    // for (int i = 0; i < _programs.length; ++i){
    //   print('--------- $i: ${_programs[i].title}');
    // }
  }

  void _initConnect() async {
    if (await widget.driver.connect()) {
      // TODO как-то по другому надо получать данные о зарядке
      _uuidGetData = const Uuid().v1();
      widget.driver.addHandler(_uuidGetData, onGetData);
      _isConnected = true;

      /// Запуск программы автоматически, если указан ее uid
      if (widget.uidProgram != "") {
        for (int i = 0; i < _programs.length; ++i) {
          if (widget.uidProgram == _programs[i].uid) {
            Timer(const Duration(milliseconds: 100), () {
              if (_chargeLevel > chargeBreakBoundLevel) {
                _runProgram(_programs[i]);
              } else {
                alertLowEnergy();
              }
            });
          }
        }
      }
    }
  }

  void _showLostConnectError() {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text(
          'Не удалось подключиться к стимулятору',
          textScaler: TextScaler.linear(1.0),
        ),
        content: const Text(
          'Попробуйте повторить попытку',
          textScaler: TextScaler.linear(1.0),
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
      setState(() {
        _chargeLevel = data.chargeLevel;
        _chargeValue = data.chargeValue;
      });
    } else {
      GetIt.I<CommunicationLogger>()
          .log('SelectProgramScreen.onGetData - set state after dispose');
    }
  }

  List<Widget> _buildProgramTiles(BuildContext context) {
    return _programs
        .mapIndexed(
          (program, index) => ProgramTitle(
            program: program,
            isLast: index == _programs.length - 1,
            onTap: () async {
              if (_chargeLevel > chargeBreakBoundLevel) {
                /// Если запустили повторно незавершенную программу
                if (program.uid == widget.driver.program.uid &&
                    !widget.driver.isOver()) {
                  /// Спросим, надо ли ее продолжить
                  final bool? isCont = await _showContinueProgramDialog();

                  /// И, если не надо
                  if (!isCont!) {
                    /// Сбросить программу
                    widget.driver.resetProgram();
                  }
                }

                /// Ну и запустить экран выполнения
                _runProgram(program);
              } else {
                alertLowEnergy();
              }
            },
          ),
        )
        .toList();
  }

  List<Widget> _buildHandleProgram(BuildContext context) {
    List<Widget> list = [];
    list.add(TogoTitle(onTap: _runToGoMode));
    list.add(DirectTitle(onTap: _runDirectControl));
    return list;
  }

  void _runToGoMode() {
    if (_chargeLevel > chargeBreakBoundLevel) {
      pushScreen(
        context,
        (context, animation, secondaryAnimation) => TogoParamsScreen(
          title: 'Индивидуальный режим',
          driver: widget.driver,
        ),
        '/togo_control',
        ShiftDirection.rightToLeft,
      );
    } else {
      alertLowEnergy();
    }
  }

  void _runDirectControl() {
    if (_chargeLevel > chargeBreakBoundLevel) {
      pushScreen(
        context,
        (context, animation, secondaryAnimation) => DirectControlScreen(
          title: 'Direct',
          driver: widget.driver,
        ),
        '/direct_control',
        ShiftDirection.rightToLeft,
      );
    } else {
      alertLowEnergy();
    }
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

  void _runProgram(MethodicProgram program) {
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
}

extension ExtendedIterable<E> on Iterable<E> {
  Iterable<T> mapIndexed<T>(T Function(E e, int i) f) {
    var i = 0;
    return map((e) => f(e, i++));
  }
}
