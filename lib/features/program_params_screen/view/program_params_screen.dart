import 'package:bgs_control/features/program_params_screen/widgets/stage_title.dart';
import 'package:bgs_control/features/program_params_screen/widgets/time_total_title.dart';
import 'package:flutter/material.dart';

import '../../../assets/colors/colors.dart';
import '../../../repositories/methodic_programs/model/methodic_program.dart';
import '../../../repositories/running_manager/device_program_executor.dart';
import '../../../utils/baseutils.dart';
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
      backgroundColor: backgroundTestColor,
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            Container(
              width: double.infinity,
              color: backgroundTestColor,
              child: Image.asset(
                'images/program_params.png',
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
              top: 10,
              left: 10,
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
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 8,
                        ),
                        child: Column(children: [
                          Row(
                            children: [
                              Expanded(
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  child: Text(
                                    widget.program.title,
                                    overflow: TextOverflow.fade, //ellipsis,
                                    style: theme.textTheme.titleMedium,
                                    textScaler: const TextScaler.linear(1.0),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                getTimeBySecCount(_programDuration() ~/ 1000),
                                style: theme.textTheme.titleMedium,
                                textScaler: const TextScaler.linear(1.0),
                              ),
                            ],
                          ),
                          const Divider(
                            height: 0,
                            indent: 0,
                            thickness: 1,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Text(
                              widget.program.description,
                              style: theme.textTheme.titleSmall,
                              textScaler: const TextScaler.linear(1.0),
                            ),
                          ),
                        ]),
                      ),
                      const Divider(
                        height: 0,
                        indent: 0,
                        thickness: 1,
                      ),
                      Expanded(
                        child: ListView(
                          padding: const EdgeInsets.only(),
                          shrinkWrap: true,
                          children: <Widget>[
                            ..._buildStageTiles(context),
//                            ..._buildTotalTimeTitle(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: SafeArea(
                      child: TexelButton.accent(
                        onPressed: () {
                          pushScreen(
                            context,
                            (context, animation, secondaryAnimation) =>
                                ExecuteScreen(
                              title: 'Execution',
                              driver: widget.driver,
                              program: widget.program,
                              isNewProgram: true,
                            ),
                            '/execute',
                            ShiftDirection.rightToLeft,
                          );
                        },
                        text: 'Начать',
                      ),
                    ),
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
      if (widget.driver.program.uid == widget.program.uid &&
          widget.driver.playingTime() > 0) {
        if (i < widget.driver.idxStage()) {
          /// Пройденные этапы
          color = filledSecondaryButtonColor;
        } else if (i == widget.driver.idxStage()) {
          /// Текущий этап
          color = greenColor;
        }
      }
      var stage = widget.program.stage(i);
      retval.add(
        StageTitle(
          num: i + 1,
          stage: stage,
          duration: stage.duration,
          textColor: color,
        ),
      );
    }
    return retval;
  }

  int _programDuration() {
    int d = 0;
    for (int i = 0; i < widget.program.stagesCount(); ++i) {
      d += widget.program.stage(i).duration;
    }
    return d;
  }

  List<Widget> _buildTotalTimeTitle() {
    List<Widget> retval = [];
    int d = _programDuration();
    retval.add(TimeTotalTitle(duration: d));
    return retval;
  }
}
