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
      onPopInvokedWithResult: (bool didPop, Object? result) async {
        if (didPop) {
          return;
        }
        Future.delayed(Duration.zero, () {
          if (!context.mounted) return;
          Navigator.of(context).popUntil(
            ModalRoute.withName('/select_method'),
          );
        });
      },
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 60),
              Text(
                'Сеанс завершен',
                style: theme.textTheme.titleLarge,
              ),
              Text(
                widget.driver.program.title,
                style: theme.textTheme.titleMedium,
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
                            getTimeBySecCount(widget.driver.programTime()),
                            'мин:сек',
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
              Padding(
                padding: const EdgeInsets.only(
                  right: 14,
                  left: 14,
                  bottom: 14,
                ),
                child: TexelButton.accent(
                  onPressed: () {
                    Navigator.of(context).popUntil(
                      ModalRoute.withName('/select_method'),
                    );
                  },
                  text: 'Выйти',
                ),
              ),
              // TexelButton.accent(
              //   onPressed: () {
              //     Navigator.of(context)
              //         .popUntil(ModalRoute.withName('/select_method'));
              //   },
              //   text: 'Сохранить и выйти',
              // ),
              // const SizedBox(height: 10),
              // TexelButton.secondary(
              //   onPressed: () {
              //     Navigator.of(context)
              //         .popUntil(ModalRoute.withName('/select_method'));
              //   },
              //   text: 'Выйти без сохранения',
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
