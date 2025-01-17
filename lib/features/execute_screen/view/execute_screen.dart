import 'dart:async';

import 'package:bgs_control/features/execute_screen/features/stage_info_dialog/stage_info_dialog.dart';
import 'package:bgs_control/features/result_screen/view/result_screen.dart';
import 'package:bgs_control/features/uikit/widgets/back_screen_button.dart';
import 'package:bgs_control/features/uikit/widgets/play_pause_button.dart';
import 'package:bgs_control/features/uikit/widgets/program_progress_bar.dart';
import 'package:bgs_control/repositories/methodic_programs/model/stage_info.dart';
import 'package:bgs_control/utils/baseutils.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:uuid/uuid.dart';

import '../../../assets/colors/colors.dart';
import '../../../repositories/bgs_connect/bgs_connect.dart';
import '../../../repositories/logger/communication_logger.dart';
import '../../../repositories/methodic_programs/model/methodic_program.dart';
import '../../../repositories/running_manager/device_program_executor.dart';
import '../../../utils/base_defines.dart';
import '../../../utils/charge_values.dart';
import '../../uikit/texel_button.dart';
import '../../uikit/widgets/charge_message_widget.dart';
import 'widgets/power_vertical_widget.dart';

class ExecuteScreen extends StatefulWidget {
  ExecuteScreen({
    super.key,
    required this.title,
    required this.driver,
    this.program,
  }) {
    if (program != null) {
      driver.setProgram(program!);
      driver.setIsWorkAuto(false);
    }
  }

  final String title;
  final DeviceProgramExecutor driver;
  final MethodicProgram? program;

  @override
  State<ExecuteScreen> createState() => _ExecuteScreenState();
}

class _ExecuteScreenState extends State<ExecuteScreen> {
  double _chargeLevel = 100;
  double _chargeValue = 0;
  double _powerSet = 0;
  double _powerReal = 0;
  int _dataCount = 0;
  String _uuidGetData = '';
  bool _isOver = false;
  final stageInfo = ValueNotifier<StageInfo>(StageInfo(
    idxStage: 0,
    isFm: false,
    isAm: false,
    nameStage: '',
    duration: 0,
    stageTime: 0,
    amMode: AmMode.am_11,
    intensivity: Intensivity.one,
    frequency: 0.0,
  ));

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (didPop) return;
        final bool? dr = await showCancelDialog();
        if (dr!) {
          if (!context.mounted) return;
          Navigator.of(context).popUntil(ModalRoute.withName('/select_method'));
        }
      },
      child: Scaffold(
        backgroundColor: backgroundTestColor,
        body: SafeArea(
          child: Column(
            children: [
              SizedBox(
                width: double.infinity,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    BackScreenButton(
                      onBack: () async {
                        final bool? dr = await showCancelDialog();
                        if (dr!) {
                          if (!context.mounted) return;
                          Navigator.of(context).popUntil(
                            ModalRoute.withName('/select_method'),
                          );
                        }
                        // Navigator.pop(context);
                      },
                      hasBackground: false,
                      isClose: true,
                    ),
                    Image.asset(
                      'lib/assets/icons/programs/${widget.driver.program.image}',
                      width: 32,
                      height: 32,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        widget.driver.program.title,
                        style: theme.textTheme.bodyLarge,
                        textScaler: const TextScaler.linear(1.0),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Icon(getChargeIconByLevel(_chargeLevel), size: 20),
                    Text(
                      '${_chargeValue.toInt()}  ${_chargeLevel.toInt()}%',
                      style: theme.textTheme.titleSmall,
                      textScaler: const TextScaler.linear(1.0),
                    ),
                    const SizedBox(width: 10),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 8),
                child: GestureDetector(
                  onTap: () {
                    _stageInfoDialog(context);
                  },
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 4,
                        horizontal: 8,
                      ),
                      decoration: BoxDecoration(
                        color: backgroundCarpetButtonTestColor,
                        borderRadius: BorderRadius.circular(40),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          /// Нвзвание этапа
                          Text(
                            'Этап ${widget.driver.idxStage() + 1} : "${widget.driver.stage().comment}"',
                            style: theme.textTheme.bodyMedium,
                            textScaler: const TextScaler.linear(1.0),
                          ),
                          const SizedBox(width: 4),
                          const Icon(
                            Icons.info_outline,
                            size: 18,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              Text(
                '${_powerReal.round()}',
                style: theme.textTheme.headlineLarge,
                textScaler: const TextScaler.linear(1.0),
              ),

              /// Установленная мощность
              Row(
                children: [
                  const SizedBox(width: 16),
                  Text(
                    '${_powerSet.round()}',
                    style: theme.textTheme.bodyLarge,
                    textScaler: const TextScaler.linear(1.0),
                  ),

                  /// Регулятор мощности
                  Expanded(
                    child: SizedBox(
                      width: double.infinity,
                      child: SliderTheme(
                        data: const SliderThemeData(
                          showValueIndicator: ShowValueIndicator.always,
                        ),
                        child: Slider(
                          value: _powerSet,
                          label: _powerSet.round().toString(),
                          min: 0,
                          max: 125,
                          activeColor: black,
                          thumbColor: black,
                          inactiveColor: backgroundCarpetButtonTestColor,
                          divisions: 125,
                          onChanged: (double value) {
                            setState(() {
                              _powerSet = value;
                            });
                          },
                          onChangeEnd: (double value) {
                            /// В этот момент мы будем устанавливать мощность
                            onPowerSet(_powerSet);
                          },
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                ],
              ),

              // if (widget.driver.stage().duration > 0)
              //
              //   /// Время этапа, если длительность этапа задана
              //   Row(
              //     mainAxisAlignment: MainAxisAlignment.center,
              //     children: [
              //       Text(
              //         '${getTimeBySecCount(widget.driver.stageTime())} / ${getTimeBySecCount(widget.driver.stage().duration ~/ 1000)}',
              //         style: theme.textTheme.headlineSmall,
              //         textScaler: const TextScaler.linear(1.0),
              //       ),
              //     ],
              //   ),
              // Row(
              //   /// Параметры воздействия
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: [
              //     Text(
              //       _stimulationParamsToString(),
              //       style: theme.textTheme.titleSmall,
              //       textScaler: const TextScaler.linear(1.0),
              //     ),
              //   ],
              // ),

              // const Spacer(),
              //
              // PowerVerticalWidget(
              //   powerSet: _powerSet,
              //   powerReal: _powerReal,
              //   onPowerSet: onPowerSet,
              //   onPowerReset: onPowerReset,
              // ),
              //
              // const Spacer(),

              const SizedBox(height: 30),
              Expanded(
                child: PowerVerticalWidget(
                  powerSet: _powerSet,
                  powerReal: _powerReal,
                  onPowerSet: onPowerSet,
                  onPowerReset: onPowerReset,
                ),
              ),
              const SizedBox(height: 30),

              /// Прогресс бар для программы
              if (widget.driver.stage().duration > 0)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      Row(
                        /// Время осталось
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'До завершения осталось ${getTimeBySecCount(widget.driver.programDuration() - widget.driver.playingTime())}',
                            style: theme.textTheme.titleSmall,
                            textScaler: const TextScaler.linear(1.0),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: SizedBox(
                              width: double.infinity,
                              height: 20,
                              child: CustomPaint(
                                painter: ProgramProgressBar(
                                  program: widget.driver.program,
                                  position: widget.driver.playingTime(),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        /// Время воздействия
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            getTimeBySecCount(widget.driver.playingTime()),
                            style: theme.textTheme.titleSmall,
                            textScaler: const TextScaler.linear(1.0),
                          ),
                          const Spacer(),
                          Text(
                            getTimeBySecCount(widget.driver.programDuration()),
                            style: theme.textTheme.titleSmall,
                            textScaler: const TextScaler.linear(1.0),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

              if (_chargeLevel <= chargeAlarmBoundLevel)
                const ChargeMessageWidget(),

              Row(
                /// Кнопка play / pause
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  PlayPauseButton(
                    type: widget.driver.isPlaying()
                        ? TypePlayPauseButton.pause
                        : TypePlayPauseButton.play,
                    onClick: () {
                      setState(() {
                        widget.driver.pause();
                        if (!widget.driver.isPlaying()) {
                          _powerSet = 0;
                        }
                      });
                    },
                  )
                ],
              ),

              /// Кнопка [Работать автономно]  в режиме без длительности
              if (widget.driver.stage().duration < 0)
                Container(
                  padding: const EdgeInsets.only(
                    left: 16,
                    right: 16,
                    top: 16,
                    bottom: 20,
                  ),
                  child: TexelButton.black(
                    text: 'Работать автономно',
                    onPressed: () {
                      widget.driver.setIsWorkAuto(true);
                      Navigator.of(context).popUntil(
                        ModalRoute.withName('/select'),
                      );
                    },
                  ),
                ),

              // if (widget.driver.isPlaying() && _powerReal >= 20)
              //   Row(
              //     children: [
              //       const SizedBox(width: 5),
              //       SizedBox(
              //         width: 50,
              //         height: 50,
              //         child: Image.asset('images/attention.png'),
              //       ),
              //       const SizedBox(width: 5),
              //       Expanded(
              //         child: Text(
              //           'Увеличивайте мощность воздействия, не допуская появления болевых ощущений',
              //           style: theme.textTheme.bodyLarge,
              //           textScaler: const TextScaler.linear(1.0),
              //         ),
              //       ),
              //     ],
              //   ),
              //             if (widget.driver.isPlaying())
              //               Container(
              //                 padding: const EdgeInsets.all(15),
              //                 decoration: BoxDecoration(
              //                   color: Theme.of(context).colorScheme.inversePrimary,
              // //                  borderRadius: BorderRadius.circular(10),
              //                 ),
              //                 child: PowerWidget(
              //                   powerSet: _powerSet,
              //                   powerReal: _powerReal,
              //                   onPowerSet: onPowerSet,
              //                   onPowerReset: onPowerReset,
              //                 ),
              //               ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool?> showCancelDialog() async {
    return await showDialog<bool>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: (widget.driver.stage().duration > 0)
            ? const Text(
                'Отменить выполнение программы?',
                textScaler: const TextScaler.linear(1.0),
              )
            : const Text(
                'Прервать воздействие?',
                textScaler: const TextScaler.linear(1.0),
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
              child: const Text('Да'),
              // width: 120,
            ),
          ),
        ],
      ),
    );
  }

  void onPowerSet(double power) {
    widget.driver.setPower(power);
    setState(() {
      _powerSet = power;
    });
  }

  void onPowerReset() {
    widget.driver.reset();
    setState(() {
      _powerSet = 0;
    });
  }

  @override
  void initState() {
    super.initState();

    widget.driver.setProgram(widget.driver.program);
    widget.driver.run();

    _uuidGetData = const Uuid().v1();
    widget.driver.addHandler(_uuidGetData, onGetData);
  }

  @override
  void dispose() {
    widget.driver.removeHandler(_uuidGetData);
    if (!widget.driver.isWorkAuto()) {
      widget.driver.setPower(0);
    }
    widget.driver.stop();

    super.dispose();
  }

  void onGetData(BlockData data) {
    setState(() {
      _powerReal = data.power;

      if (data.isPowerReset) {
        _powerSet = 0;
      }

      // GetIt.I<CommunicationLogger>()
      //     .log('$_dataCount  Power: ${_chargeValue.toInt()}  ${_chargeLevel.toInt()}%');
      _chargeLevel = data.chargeLevel;
      _chargeValue = data.chargeValue;

      ++_dataCount;
    });

    stageInfo.value = StageInfo(
      idxStage: widget.driver.idxStage(),
      nameStage: widget.driver.stage().comment,
      duration: widget.driver.stage().duration,
      stageTime: widget.driver.stageTime(),
      isAm: widget.driver.stage().isAm,
      isFm: widget.driver.stage().isFm,
      amMode: widget.driver.stage().amMode,
      intensivity: widget.driver.stage().intensity,
      frequency: widget.driver.stage().frequency,
    );

    /// Посылаем команду работать даже при прерывании связи
    if (_dataCount == 1) {
      widget.driver.setConnectionFailureMode(ConnectionFailureMode.cfmWorking);
    }

    if (widget.driver.isOver() && !_isOver) {
      _isOver = true;

      /// Программа завершена - к окну результатов
      widget.driver.removeHandler(_uuidGetData);
      MaterialPageRoute route = MaterialPageRoute(
        builder: (context) => ResultScreen(
          title: 'Result',
          driver: widget.driver,
        ),
        settings: const RouteSettings(name: '/result'),
      );
      Navigator.of(context).push(route);

      /// Программа завершена - выходим
      // Navigator.of(context).popUntil(ModalRoute.withName('/select_method'));
    }
  }

  void _stageInfoDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return StageInfoDialog(stageInfo: stageInfo);
      },
    );
  }

  String _stimulationParamsToString() {
    String retval = '';

    if (widget.driver.stage().isAm) {
      retval = '${retval}Am (${amModeNames[widget.driver.stage().amMode]})';
    }
    if (widget.driver.stage().isFm) {
      retval = '$retval   Fm';
    } else {
      retval = '$retval   F = ${widget.driver.stage().frequency.toInt()}';
    }
    retval = '$retval   Int = ${widget.driver.stage().intensity.index + 1}';

    // if (widget.driver.stage().duration >= 0) {
    //   retval =
    //       '$retval   Время : ${getTimeBySecCount(widget.driver.stage().duration ~/ 1000)}';
    // } else {
    //   retval = '$retval   Время не задано';
    // }

    return retval;
  }
}
