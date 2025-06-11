import 'dart:async';

import 'package:bgs_control/features/execute_screen/features/stage_info_dialog/stage_info_dialog.dart';
import 'package:bgs_control/features/result_screen/view/result_screen.dart';
import 'package:bgs_control/features/uikit/widgets/back_screen_button.dart';
import 'package:bgs_control/features/uikit/widgets/play_pause_button.dart';
import 'package:bgs_control/features/uikit/widgets/program_progress_bar.dart';
import 'package:bgs_control/repositories/methodic_programs/model/stage_info.dart';
import 'package:bgs_control/utils/baseutils.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../../../assets/colors/colors.dart';
import '../../../repositories/bgs_connect/bgs_connect.dart';
import '../../../repositories/bgs_connect/bgs_defines.dart';
import '../../../repositories/methodic_programs/model/methodic_program.dart';
import '../../../repositories/running_manager/device_program_executor.dart';
import '../../../utils/base_defines.dart';
import '../../../utils/charge_values.dart';
import '../../../utils/screen_utils.dart';
import '../../uikit/texel_button.dart';
import '../../uikit/widgets/charge_message_widget.dart';
import '../../uikit/widgets/safe_level_dialog.dart';
import 'widgets/power_vertical_widget.dart';

class ExecuteScreen extends StatefulWidget {
  ExecuteScreen({
    super.key,
    required this.title,
    required this.driver,
    this.program,
    required this.isNewProgram,
  }) {
    if (program != null) {
      driver.setProgram(program!, false);
    }
  }

  final String title;
  final DeviceProgramExecutor driver;
  final MethodicProgram? program;
  final bool isNewProgram;

  @override
  State<ExecuteScreen> createState() => _ExecuteScreenState();
}

class _ExecuteScreenState extends State<ExecuteScreen> {
  double _chargeLevel = 100;
  double _chargeValue = 0;
  bool _isVisibleChargeMessageWidget = false;
  double _powerSet = 0;
  double _powerReal = 0;

//  int _dataCount = 0;
  String _uuidGetData = '';
  bool _isOver = false;
  double _sliderValueStart = 0;
  bool _isGetPowerSetFromDevice = false;
  bool _isToGoMode = false;

  /// Устанавливается в true припереходе в автономный режим

  /// Устанавливается, когда надо прочитать значение установленной мощности из устройства
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
      onPopInvokedWithResult: (bool didPop, Object? result) async {
        if (didPop) {
          return;
        }
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
                    if (_chargeValue > 0)
                      GestureDetector(
                        child: Row(
                          children: [
                            if (_chargeLevel <= chargeAlarmBoundLevel)
                              Icon(
                                Icons.warning,
                                color: Colors.red.shade800,
                              ),
                            Icon(
                              getChargeIconByLevel(_chargeLevel),
                              size: 20,
                              color: _chargeLevel > chargeAlarmBoundLevel
                                  ? Colors.black
                                  : Colors.red.shade800,
                            ),
                            Text(
                              '${_chargeLevel.toInt()}%',
                              style: TextStyle(
                                fontSize: 14,
                                color: _chargeLevel > chargeAlarmBoundLevel
                                    ? Colors.black
                                    : Colors.red.shade800,
                              ),
                              textScaler: const TextScaler.linear(1.0),
                            ),
                          ],
                        ),
                        onTap: () {
                          _isVisibleChargeMessageWidget =
                              !_isVisibleChargeMessageWidget;
                        },
                      ),
                    const SizedBox(width: 10),
                  ],
                ),
              ),

              /// Предупреждение о низком заряде аккумулятора
              if (_chargeLevel <= chargeAlarmBoundLevel &&
                  _isVisibleChargeMessageWidget)
                const ChargeMessageWidget(),

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
                '${_powerSet.round()}',
                style: theme.textTheme.headlineLarge,
                textScaler: const TextScaler.linear(1.0),
              ),

              /// Установленная мощность
              Row(
                children: [
                  const SizedBox(width: 16),
                  Text(
                    '${_powerReal.round()}',
                    style: theme.textTheme.bodyLarge,
                    textScaler: const TextScaler.linear(1.0),
                  ),

                  /// Регулятор мощности - два слайдера
                  Expanded(
                    child: SizedBox(
                      width: double.infinity,
                      child: Stack(
                        children: [
                          /// Нижний показывает установленный целевой уровень
                          /// Показывает бегунок и серый уровень
                          SliderTheme(
                            data: const SliderThemeData(
                              showValueIndicator: ShowValueIndicator.always,
                            ),
                            child: Slider(
                              value: _powerSet,
                              label: _powerSet.round().toString(),
                              min: 0,
                              max: 125,
                              activeColor: backgroundMiddleTestColor,
                              thumbColor: black,
                              inactiveColor: backgroundCarpetButtonTestColor,
                              divisions: 125,
                              onChanged: (double value) {},
                            ),
                          ),

                          /// Верхний показывает установленный уровень на приборе
                          /// Показывает черный уровень
                          SliderTheme(
                            data: SliderThemeData(
                              showValueIndicator: ShowValueIndicator.always,
                              thumbShape: SliderComponentShape.noThumb,
                            ),
                            child: Slider(
                              value: _powerReal,
                              min: 0,
                              max: 125,
                              activeColor: black,
                              thumbColor: black,
                              inactiveColor: const Color(0x00000000),
                              overlayColor: WidgetStateProperty<
                                  Color>.fromMap(<WidgetStatesConstraint, Color>{
                                WidgetState.focused: const Color(0x00000000),
                                WidgetState.pressed | WidgetState.hovered:
                                    const Color(0x00000000),
                                WidgetState.any: const Color(0x00000000),
                              }),
                              divisions: 125,
                              onChanged: _onSliderValueChanged,
                              onChangeStart: _onSliderValueChangeStart,

                              /// В этот момент мы будем устанавливать мощность
                              onChangeEnd: _onSliderValueChangeEnd,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                ],
              ),

              const SizedBox(height: 10),
              Expanded(
                child: PowerVerticalWidget(
                  powerSet: _powerSet,
                  powerReal: _powerReal,
                  onPowerSet: onPowerSet,
                  onPowerReset: onPowerReset,
                ),
              ),
              const SizedBox(height: 10),

              /// Прогресс бар для программы
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    if (widget.driver.stage().duration > 0)
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
                    if (widget.driver.stage().duration > 0)
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
                        widget.driver.stage().duration > 0
                            ? Text(
                                getTimeBySecCount(widget.driver.playingTime()),
                                style: theme.textTheme.titleSmall,
                                textScaler: const TextScaler.linear(1.0),
                              )
                            : Text(
                                'Прошло времени - ${getTimeBySecCount(widget.driver.playingTime())}',
                                style: theme.textTheme.titleSmall,
                                textScaler: const TextScaler.linear(1.0),
                              ),
                        const Spacer(),
                        if (widget.driver.stage().duration > 0)
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

              /// Кнопка play / pause
              PlayPauseButton(
                type: widget.driver.isPlaying()
                    ? TypePlayPauseButton.pause
                    : TypePlayPauseButton.play,
                onClick: () {
                  setState(() {
                    _onPlayPauseButton();
                  });
                },
              ),

              /// Кнопка [Работать автономно]
              Container(
                padding: const EdgeInsets.only(
                  left: 16,
                  right: 16,
                  top: 8,
                  bottom: 8,
                ),
                child: TexelButton.yellowDark(
                  text: 'Работать автономно',
                  onPressed: () async {
                    bool? isGo = await isWorkToGo(context);
                    if (isGo!) {
                      _isToGoMode = true;
                      Navigator.of(context).popUntil(
                        ModalRoute.withName('/select'),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool?> showCancelDialog() async {
    return await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => AlertDialog(
        title: (widget.driver.stage().duration > 0)
            ? const Text(
                'Отменить выполнение программы?',
              )
            : const Text(
                'Прервать воздействие?',
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
              child: const Text(
                'Да',
              ),
              // width: 120,
            ),
          ),
        ],
      ),
    );
  }

  void onPowerSet(double power) {
    if (widget.driver.isPlaying()) {
      widget.driver.setPower(power);
    }
    setState(() {
      _powerSet = power;
      _sliderValueStart = power;
    });
  }

  void onPowerReset() {
    widget.driver.reset();
    setState(() {
      _powerSet = 0;
    });
  }

  void _onSliderValueChangeStart(double value) {}

  void _onSliderValueChanged(double value) {
    setState(() {
      _powerSet = value;
    });
  }

  void _onSliderValueChangeEnd(double value) async {
    bool? isEnable = true;

    /// Если мощность в процессе изменения значения слайдера превысила powerSafeLevel,
    /// то выдаем запрос на подтверждение увеличения мощности
    if (_powerSet > powerSafeLevel && _sliderValueStart <= powerSafeLevel) {
      isEnable = await safeLevelDialog(context);
    }

    /// Если разрешили, то увеличиваем мощность
    if (isEnable!) {
      onPowerSet(_powerSet);
      _sliderValueStart = value;
    } else {
      /// А, если не разрешили, то оставляем, как было
      setState(() {
        _powerSet = _sliderValueStart;
      });
    }
  }

  @override
  void initState() {
    super.initState();

    if (widget.isNewProgram) {
      widget.driver.setProgram(widget.driver.program, true);
    } else {
      _isGetPowerSetFromDevice = true;
      widget.driver.getProgramParams();
    }
    widget.driver.run(widget.isNewProgram);

    _uuidGetData = const Uuid().v1();
    widget.driver.addHandler(_uuidGetData, onGetData);
    widget.driver
        .initSettings(); //TODO: В какой-то момент отказался очень большой файл. Понаблюдать, найти причину, исключить
  }

  @override
  void dispose() {
    super.dispose();
    _doDispose();
  }

  Future _doDispose() async {
    await widget.driver.saveSettings();
    await widget.driver.removeHandler(_uuidGetData);
    if (!_isToGoMode) {
      await widget.driver.stop(false);
    }
  }

  void onGetData(BlockData data) {
    /// Читаем значение установленной мощности из устройства, если подключаемся к
    /// устройству, на котором работает программа
    if (_isGetPowerSetFromDevice && widget.driver.targetPower() > 0) {
      _powerSet = widget.driver.targetPower().toDouble();
      _sliderValueStart = _powerSet;
      _isGetPowerSetFromDevice = false;
    }

    setState(() {
      _powerReal = data.power;

      // GetIt.I<CommunicationLogger>().log(
      //     '$_dataCount  Power: ${_chargeValue.toInt()}  ${_chargeLevel.toInt()}%');
      _chargeLevel = data.chargeLevel;
      _chargeValue = data.chargeValue;

//      ++_dataCount;
    });

    stageInfo.value = StageInfo(
      idxStage: widget.driver.idxStage(),
      nameStage: widget.driver.stage().comment,
      duration: widget.driver.stage().duration,
      stageTime: widget.driver.stageTime(),
      isAm: widget.driver.stage().isAm,
      isFm: widget.driver.stage().isFm,
      amMode: widget.driver.stage().amMode,
      intensivity: widget.driver.stage().intensivity,
      frequency: widget.driver.stage().frequency,
    );

    if (widget.driver.isOver() && !_isOver) {
      _isOver = true;

      /// Программа завершена - к окну результатов
      widget.driver.saveSettings();
      widget.driver.removeHandler(_uuidGetData);

      pushScreen(
        context,
        (context, animation, secondaryAnimation) => ResultScreen(
          title: 'Result',
          driver: widget.driver,
        ),
        '/result',
        ShiftDirection.rightToLeft,
      );
    }
  }

  void _onPlayPauseButton() async {
    await widget.driver.pause();
    if (!widget.driver.isPlaying()) {
      //_powerSet = 0;
    } else {
      await widget.driver.setPower(_powerSet);
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
    // TODO (yasliks): не используемый метод
    String retval = '';

    if (widget.driver.stage().isAm) {
      retval = '${retval}Am (${amModeNames[widget.driver.stage().amMode]})';
    }
    if (widget.driver.stage().isFm) {
      retval = '$retval   Fm';
    } else {
      retval = '$retval   F = ${widget.driver.stage().frequency.toInt()}';
    }
    retval = '$retval   Int = ${widget.driver.stage().intensivity.index + 1}';

    return retval;
  }
}
