import 'package:bgs_control/features/uikit/texel_button.dart';
import 'package:bgs_control/features/uikit/widgets/circular_value_diag.dart';
import 'package:flutter/material.dart';

import '../../../repositories/running_manager/device_program_executor.dart';
import '../../../utils/baseutils.dart';

class ResultScreen extends StatefulWidget {
  const ResultScreen({
    super.key,
    required this.title,
    required this.driver,
  });

  final String title;
  final DeviceProgramExecutor driver;

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        Navigator.of(context).popUntil(ModalRoute.withName('/select_method'));
      },
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const SizedBox(height: 60),
              Text(
                'Сеанс завершен',
                style: theme.textTheme.titleLarge,
              ),
              const SizedBox(height: 60),
              Row(
                children: [
                  const Spacer(),
                  Column(
                    children: [
                      SizedBox(
                        height: 120,
                        width: 120,
                        child: CustomPaint(
                          painter: CircularValueDiag.text(
                            getTimeBySecCount(widget.driver.playingTime()),
                            'мин:сек'
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 150,
                        child: Text(
                          'Продолжительность, мин:сек',
                          style: theme.textTheme.titleSmall,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  const SizedBox(width: 30),
                  Column(
                    children: [
                      SizedBox(
                        height: 120,
                        width: 120,
                        child: CustomPaint(
                          painter: CircularValueDiag(
                            value: widget.driver.maxPower().toInt(),
                            min: 0,
                            max: 125,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 120,
                        child: Text(
                          'Максимальный уровень воздействия',
                          style: theme.textTheme.titleSmall,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Column(
                    children: [
                      SizedBox(
                        height: 120,
                        width: 120,
                        child: CustomPaint(
                          painter: CircularValueDiag(
                            value: widget.driver.averagePower().toInt(),
                            min: 0,
                            max: 125,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 120,
                        child: Text(
                          'Средний уровень воздействия',
                          style: theme.textTheme.titleSmall,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 30),
                ],
              ),
              const Spacer(),
              TexelButton.accent(
                onPressed: () {
                  Navigator.of(context)
                      .popUntil(ModalRoute.withName('/select_method'));
                },
                text: 'Сохранить и выйти',
              ),
              const SizedBox(height: 10),
              TexelButton.secondary(
                  onPressed: () {
                    Navigator.of(context)
                        .popUntil(ModalRoute.withName('/select_method'));
                  },
                  text: 'Выйти без сохранения'),
            ],
          ),
        ),
      ),
    );
  }
}
