import 'dart:async';

import 'package:bgs_control/features/program_params_screen/view/program_params_screen.dart';
import 'package:bgs_control/features/select_program_screen/widgets/direct_title.dart';
import 'package:bgs_control/features/select_program_screen/widgets/program_title.dart';
import 'package:bgs_control/features/select_program_screen/widgets/togo_title.dart';
import 'package:bgs_control/features/togo_params_screen/view/togo_params_screen.dart';
import 'package:bgs_control/repositories/methodic_programs/model/methodic_program.dart';
import 'package:bgs_control/repositories/methodic_programs/storage/program_storage.dart';
import 'package:bgs_control/utils/extra.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:get_it/get_it.dart';
import 'package:uuid/uuid.dart';

import '../../../assets/colors/colors.dart';
import '../../../repositories/bgs_connect/bgs_connect.dart';
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

//  bool _isConnected = false;
  String _uuidGetData = '';
  double _chargeLevel = 100;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Stack(
          children: [
            Column(
              children: [
                const SizedBox(height: 30),
                Container(
                  color: backgroundTestColor,
                  child: Image.asset('images/background_woman.png'),
                ),
              ],
            ),
            Positioned(
              top: 40,
              left: 20,
              child: BackScreenButton(onBack: () {
                Navigator.pop(context);
              }),
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
                  padding: const EdgeInsets.all(0),
                  decoration: BoxDecoration(
                    color: backgroundColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      // Text(
                      //   'Доступные программы',
                      //   style: theme.textTheme.titleLarge,
                      // ),
                      Row(
                        children: [
                          Text(
                            'Доступные программы',
                            style: theme.textTheme.titleLarge,
                          ),
                          const Spacer(),
                          Icon(getChargeIconByLevel(_chargeLevel), size: 20),
                          Text(
                            '${_chargeLevel.toInt()}%',
                            style: theme.textTheme.titleMedium,
                          ),
                        ],
                      ),
                      Expanded(
                        child: ListView(
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

    widget.driver.connect();
    // TODO как-то по другому надо получать данные о зарядке
    _uuidGetData = const Uuid().v1();
    widget.driver.addHandler(_uuidGetData, onGetData);

    /// Запуск программы автоматически, если указан ее uid
    if (widget.uidProgram != ""){
      for (int i = 0; i < _programs.length; ++ i){
        if (widget.uidProgram == _programs[i].uid){
          Timer(const Duration(milliseconds: 100), (){
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

  @override
  void dispose() {
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

  void onGetData(BlockData data) {
    setState(() {
      _chargeLevel = data.chargeLevel;
    });
  }

  List<Widget> _buildProgramTiles(BuildContext context) {
    return _programs
        .map(
          (program) => ProgramTitle(
            program: program,
            onTap: () async {
              if (_chargeLevel > chargeBreakBoundLevel) {
                /// Если запустили повторно незавершенную программу
                if (program.uid == widget.driver.program.uid && !widget.driver.isOver()){
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
      MaterialPageRoute route = MaterialPageRoute(
        builder: (context) => TogoParamsScreen(
          title: 'Индивидуальный режим',
          driver: widget.driver,
        ),
        settings: const RouteSettings(name: '/togo_control'),
      );
      Navigator.of(context).push(route);
    } else {
      alertLowEnergy();
    }
  }

  void _runDirectControl() {
    if (_chargeLevel > chargeBreakBoundLevel) {
      MaterialPageRoute route = MaterialPageRoute(
        builder: (context) => DirectControlScreen(
          title: 'Direct',
          driver: widget.driver,
        ),
        settings: const RouteSettings(name: '/direct_control'),
      );
      Navigator.of(context).push(route);
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
          TexelButton.accent(
            onPressed: () => Navigator.pop(context, true),
            text: 'Да',
            width: 120,
          ),
        ],
      ),
    );
  }

  void _runProgram(MethodicProgram program){
    MaterialPageRoute route = MaterialPageRoute(
      builder: (context) => ProgramParamsScreen(
        title: 'Программа ${program.title}',
        driver: widget.driver,
        program: program,
      ),
      settings: const RouteSettings(name: '/program_control'),
    );
    Navigator.of(context).push(route);
  }

}
