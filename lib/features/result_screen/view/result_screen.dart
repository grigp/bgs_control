import 'package:bgs_control/features/uikit/texel_button.dart';
import 'package:bgs_control/features/uikit/widgets/circular_value_diag.dart';
import 'package:bgs_control/repositories/database/db_defines.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:uuid/uuid.dart';

import '../../../generated/l10n.dart';
import '../../../repositories/database/db_provider.dart';
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
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 2,
            ),
            child: Column(
              children: [
                const SizedBox(height: 60),
                Text(
                  S.of(context).sessionCompleted,
                  style: theme.textTheme.titleLarge,
                ),
                const SizedBox(height: 10),
                Text(
                  widget.driver.program.title,
                  style: theme.textTheme.titleMedium,
                  textAlign: TextAlign.center,
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
                              S.of(context).mm_ss,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 150,
                          child: Text(
                            S.of(context).durationMmSs,
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
                            S.of(context).maximumStimulationPower,
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
                            S.of(context).averageStimulationPower,
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
                  child: Column(
                    children: [
                      TexelButton.secondary(
                        onPressed: _askToSaveResults,
                        text: S.of(context).save,
                      ),
                      const SizedBox(height: 20),
                      TexelButton.accent(
                        onPressed: () {
                          Navigator.of(context).popUntil(
                            ModalRoute.withName('/select_method'),
                          );
                        },
                        text: S.of(context).exit,
                      ),
                    ],
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
      ),
    );
  }

  Future _askToSaveResults() async {
    var cnt = await GetIt.I<DbProvider>().seancesCount();

    await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => AlertDialog(
        title: Text(S.of(context).askToSaveResults(cnt!)),
        actions: <Widget>[
          TexelButton.accent(
            onPressed: () {
              _saveResults();
              Navigator.pop(context, false);
            },
            text: S.of(context).yes,
            width: 120,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22),
            child: TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(
                S.of(context).no,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _saveResults() async {
    await GetIt.I<DbProvider>().addSeance(
      RecordSeance(
        uid: const Uuid().v1(),
        dt: DateTime.now(),
        duration: widget.driver.programTime(),
        max: widget.driver.maxPower().toInt(),
        average: widget.driver.averagePower().toInt(),
        comment: '',
      ),
    );
  }
}
