import 'package:bgs_control/features/program_params_screen/widgets/stage_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

import '../../../assets/colors/colors.dart';
import '../../../repositories/methodic_programs/model/methodic_program.dart';
import '../../../repositories/running_manager/device_program_executor.dart';
import '../../execute_screen/view/execute_screen.dart';
import '../../uikit/texel_button.dart';
import '../../uikit/widgets/back_screen_button.dart';

class ProgramParamsScreen extends StatefulWidget {
  const ProgramParamsScreen({
    super.key,
    required this.title,
    required this.driver,
    required this.program,
  });

  final String title;
  final DeviceProgramExecutor driver;
  final MethodicProgram program;

  @override
  State<ProgramParamsScreen> createState() => _ProgramParamsScreenState();
}

class _ProgramParamsScreenState extends State<ProgramParamsScreen> {
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
                // if (_chargeLevel <= chargeAlarmBoundLevel)
                //   const ChargeMessageWidget(),
                Image.asset('images/background_hand.png'),
              ],
            ),
            Positioned(
              top: 40,
              left: 10,
              child: BackScreenButton(onBack: (){Navigator.pop(context);}),
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
                        widget.program.title,
                        style: theme.textTheme.titleLarge,
                      ),
                      Row(
                        children: [
                          Text(
                            widget.driver.device.advName,
                            style: theme.textTheme.titleMedium,
                          ),
                          const Spacer(),
                          // Icon(getChargeIconByLevel(_chargeLevel), size: 20),
                          // Text(
                          //   '${_chargeLevel.toInt()}%',
                          //   style: theme.textTheme.titleMedium,
                          // ),
                        ],
                      ),
                      Expanded(
                        child: ListView(
                          shrinkWrap: true,
                          children: <Widget>[
                            ..._buildStageTiles(context),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Center(
                  child: TexelButton.accent(
                    onPressed: () {
                      MaterialPageRoute route = MaterialPageRoute(
                        builder: (context) => ExecuteScreen(
                          title: 'Execution',
                          driver: widget.driver,
                          program: widget.program,
                          isSetProgram: true,
                        ),
                        settings: const RouteSettings(name: '/execute'),
                      );
                      Navigator.of(context).push(route);
                    },
                    text: 'Начать',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildStageTiles(BuildContext context) {
    List<Widget> retval = [];

    for (int i = 0; i < widget.program.stagesCount(); ++i) {
      /// Цвет выводимого текста
      Color color = black;
      /// Если программа в драйвере и назначаемая совпадают
      if (widget.driver.program.uid == widget.program.uid && !widget.driver.isOver()) {
        if (i < widget.driver.idxStage()) {  /// Пройденные этапы
          color = filledSecondaryButtonColor;
        } else if (i == widget.driver.idxStage()) {  /// Текущий этап
          color = greenColor;
        }
      }
      var stage = widget.program.stage(i);
      retval.add(
        StageTitle(
          num: i+1,
          stage: stage,
          duration: stage.duration,
          textColor: color,
        ),
      );
    }
    return retval;
  }
}
