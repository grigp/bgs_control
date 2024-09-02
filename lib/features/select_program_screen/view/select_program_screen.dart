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
import '../../../utils/base_defines.dart';
import '../../../utils/charge_values.dart';
import '../../direct_control_screen/view/direct_control_screen.dart';
import '../../uikit/texel_button.dart';
import '../../uikit/widgets/back_screen_button.dart';
import '../../uikit/widgets/charge_message_widget.dart';

class SelectProgramScreen extends StatefulWidget {
  const SelectProgramScreen({
    super.key,
    required this.title,
    required this.device,
  });

  final String title;
  final BluetoothDevice device;

  @override
  State<SelectProgramScreen> createState() => _SelectProgramScreenState();
}

class _SelectProgramScreenState extends State<SelectProgramScreen> {
  List<MethodicProgram> _programs = [];
  bool _isConnected = false;
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
                if (_chargeLevel <= chargeAlarmBoundLevel)
                  const ChargeMessageWidget(),
                Image.asset('images/background_woman.png'),
              ],
            ),
            const Positioned(
              top: 40,
              left: 20,
              child: BackScreenButton(),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start, //.center,
              children: <Widget>[
                const Spacer(),
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
                      Text(
                        'Доступные программы',
                        style: theme.textTheme.titleLarge,
                      ),
                      Row(
                        children: [
                          Text(
                            widget.device.advName,
                            style: theme.textTheme.titleMedium,
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

    GetIt.I<BgsConnect>().init(widget.device);
    widget.device.connectionState.listen((event) {
      _isConnected = event == BluetoothConnectionState.connected;
    });

    _uuidGetData = const Uuid().v1();
    GetIt.I<BgsConnect>().addHandler(_uuidGetData, onGetData);
  }

  @override
  void dispose() {
    GetIt.I<BgsConnect>().removeHandler(_uuidGetData);

    if (_isConnected) {
      GetIt.I<BgsConnect>().reset();
      GetIt.I<BgsConnect>().stop();

      widget.device.disconnectAndUpdateStream().catchError((e) {});
    }

    super.dispose();
  }

  void readPrograms() async {
    _programs =  GetIt.I<ProgramStorage>().getPrograms();
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
            onTap: () {
              if (_chargeLevel > chargeBreakBoundLevel) {
                MaterialPageRoute route = MaterialPageRoute(
                  builder: (context) => ProgramParamsScreen(
                    title: 'Программа ${program.title}',
                    device: widget.device,
                    program: program,
                  ),
                  settings:
                  const RouteSettings(name: '/program_control'),
                );
                Navigator.of(context).push(route);
              } else {
                alertLowEnergy();
              }
            },
          ),
        )
        .toList();
  }

  List<Widget> _buildHandleProgram(BuildContext context){
    List<Widget> list = [];
    list.add(TogoTitle(onTap: _runToGoMode));
    list.add(DirectTitle(onTap: _runDirectControl));
    return list;
  }

  void _runToGoMode(){
    if (_chargeLevel > chargeBreakBoundLevel) {
      MaterialPageRoute route = MaterialPageRoute(
        builder: (context) => TogoParamsScreen(
          title: 'Свободный режим',
          device: widget.device,
        ),
        settings:
        const RouteSettings(name: '/togo_control'),
      );
      Navigator.of(context).push(route);
    } else {
      alertLowEnergy();
    }
  }

  void _runDirectControl(){
    if (_chargeLevel > chargeBreakBoundLevel) {
      MaterialPageRoute route = MaterialPageRoute(
        builder: (context) => DirectControlScreen(
          title: 'Direct',
          device: widget.device,
        ),
        settings:
        const RouteSettings(name: '/direct_control'),
      );
      Navigator.of(context).push(route);
    } else {
      alertLowEnergy();
    }
  }
}
