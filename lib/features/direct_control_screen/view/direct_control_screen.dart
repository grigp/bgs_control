import 'dart:async';

import 'package:bgs_control/features/direct_control_screen/widgets/params_widget.dart';
import 'package:bgs_control/features/direct_control_screen/widgets/power_horizontal_widget.dart';
import 'package:bgs_control/features/uikit/widgets/back_screen_button.dart';
import 'package:bgs_control/features/uikit/widgets/charge_message_widget.dart';
import 'package:bgs_control/repositories/bgs_connect/bgs_connect.dart';
import 'package:bgs_control/repositories/methodic_programs/model/methodic_program.dart';
import 'package:bgs_control/utils/charge_values.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:uuid/uuid.dart';

import '../../../assets/colors/colors.dart';
import '../../../repositories/bgs_connect/bgs_defines.dart';
import '../../../repositories/logger/communication_logger.dart';
import '../../../repositories/running_manager/device_program_executor.dart';
import '../../../utils/base_defines.dart';
import '../../../utils/baseutils.dart';
import '../../uikit/widgets/play_pause_button.dart';
import '../../uikit/widgets/program_progress_bar.dart';

class DirectControlScreen extends StatefulWidget {
  DirectControlScreen({
    super.key,
    required this.title,
    required this.driver,
  }) {
    driver.setIsWorkAuto(false);
  }

  final String title;
  final DeviceProgramExecutor driver;

  @override
  State<DirectControlScreen> createState() => _DirectControlScreenState();
}

class _DirectControlScreenState extends State<DirectControlScreen> {
  List<int> _value = [];
  int _dataCount = 0;

  /// Счетчик пакетов стимуляции, один раз в секунду. Время стимуляции

  bool _isAm = false;
  bool _isAmChange = true;
  bool _isFm = false;
  bool _isFmChange = true;
  AmMode _amMode = AmMode.am_11;
  bool _isAmModeChange = true;
  Intensivity _intensivity = Intensivity.one;
  bool _intensivityChange = true;
  double _powerSet = 0;
  double _powerReal = 0;
  double _idxFreq = 0;
  bool _idxFreqChange = true;
  double _chargeLevel = 100;
  double _chargeValue = 0;
  double _chargeValueExt = 0;
  String _uuidSendData = '';

  late Timer _timer;
  int _secCounter = 0;

  @override
  void initState() {
    super.initState();
    widget.driver.setWorkManagerTask(3600000 - 2000);

    widget.driver.setProgram(
        MethodicProgram.one(false, false, AmMode.am_11, Intensivity.one, 60,
            maxDirectModeDuration.toInt() * 60 * 1000),
        true);
    widget.driver.resetProgram();
    widget.driver.run(true);  //TODO: Надо в зависимости от режима в приборе

    _uuidSendData = const Uuid().v1();
    widget.driver.initSettings();
    widget.driver.addHandler(_uuidSendData, onGetData);

    widget.driver.reset();
    _timer = Timer.periodic(const Duration(seconds: 1), onTimer);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        leading: BackScreenButton(
          onBack: () {
            Navigator.pop(context);
          },
          hasBackground: false,
        ),
        title: Text(
          'Прямое управление',
//          '${widget.title}: ${widget.driver.device.advName}',
          style: theme.textTheme.titleMedium,
          textScaler: const TextScaler.linear(1.0),
        ),
        actions: [
          if (_chargeValue > 0)
            Icon(getChargeIconByLevel(_chargeLevel), size: 20),
          if (_chargeValue > 0)
            Text(
              '${_chargeLevel.toInt()}%',
              style: theme.textTheme.titleMedium,
              textScaler: const TextScaler.linear(1.0),
            ),
          const SizedBox(width: 10),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            if (_chargeLevel <= chargeAlarmBoundLevel)
              const ChargeMessageWidget(),
            if (kDebugMode)
              Text(
                '($_dataCount)  ${_valueToString()}',
                style: theme.textTheme.bodySmall,
                textScaler: const TextScaler.linear(1.0),
              ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: ParamsWidget(
                isAm: _isAm,
                onAmChanged: onAmChanged,
                amMode: _amMode,
                onAmModeChanged: onAmModeChanged,
                isFm: _isFm,
                onFmChanged: onFmChanged,
                idxFreq: _idxFreq,
                onFreqChanged: onFreqChanged,
                intensity: _intensivity,
                onIntensityChanged: onIntensityChanged,
                colorsStyle: ParamsColorsStyle.pcsYellow,
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: backgroundTestColor,
        height: 330,
        child: Column(
          children: [
            /// Регулятор мощности
            PowerHorizontalWidget(
              powerSet: _powerSet,
              powerReal: _powerReal,
              onPowerSet: onPowerSet,
              onPowerReset: onPowerReset,
            ),
            const SizedBox(height: 10),

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
            const SizedBox(height: 10),

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
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _stopStimulation();
    super.dispose();
  }

  void onAmChanged(bool isAm) {
    _secCounter = 0;
    widget.driver.setWorkManagerTask(3600000 - 2000);

    Timer(const Duration(seconds: 2), () {
      _isAmChange = true;
    });
    _isAmChange = false;
    _setDeviceMode(isAm, _isFm, _amMode, _idxFreq, _intensivity);

    setState(() {
      _isAm = isAm;
    });
  }

  void onAmModeChanged(AmMode amMode) {
    _secCounter = 0;
    widget.driver.setWorkManagerTask(3600000 - 2000);

    Timer(const Duration(seconds: 2), () {
      _isAmModeChange = true;
    });
    _isAmModeChange = false;
    _setDeviceMode(_isAm, _isFm, amMode, _idxFreq, _intensivity);

    setState(() {
      _amMode = amMode;
    });
  }

  void onFmChanged(bool isFm) {
    _secCounter = 0;
    widget.driver.setWorkManagerTask(3600000 - 2000);

    Timer(const Duration(seconds: 2), () {
      _isFmChange = true;
    });
    _isFmChange = false;
    _setDeviceMode(_isAm, isFm, _amMode, _idxFreq, _intensivity);

    setState(() {
      _isFm = isFm;
    });
  }

  void onFreqChanged(double idxFreq) {
    _secCounter = 0;
    widget.driver.setWorkManagerTask(3600000 - 2000);

    Timer(const Duration(seconds: 2), () {
      _idxFreqChange = true;
    });
    _idxFreqChange = false;
    _setDeviceMode(_isAm, _isFm, _amMode, idxFreq, _intensivity);

    setState(() {
      _idxFreq = idxFreq;
    });
  }

  void onIntensityChanged(Intensivity intensivity) {
    _secCounter = 0;
    widget.driver.setWorkManagerTask(3600000 - 2000);

    Timer(const Duration(seconds: 2), () {
      _intensivityChange = true;
    });
    _intensivityChange = false;
    _setDeviceMode(_isAm, _isFm, _amMode, _idxFreq, intensivity);

    setState(() {
      _intensivity = intensivity;
    });
  }

  void onPowerSet(double power) {
    _secCounter = 0;
    widget.driver.setWorkManagerTask(3600000 - 2000);

    if (widget.driver.isPlaying()) {
      widget.driver.setPower(power);
    }
    _powerSet = power;
  }

  void onPowerReset() {
    _secCounter = 0;
    widget.driver.setWorkManagerTask(3600000 - 2000);

    widget.driver.reset();
    _powerSet = 0;
  }

  void onGetData(BlockData data) {
    setState(() {
      _value = data.source;
      _powerReal = data.power;

      if (_isAmChange) {
        _isAm = data.isAM;
      }
      if (_isAmModeChange) {
        _amMode = data.amMode;
      }

      if (_isFmChange) {
        _isFm = data.isFM;
      }
      if (_idxFreqChange) {
        _idxFreq = data.idxFreq;
      }

      if (data.isPowerReset) {
        _onPlayPauseButton();
      }

      if (_intensivityChange) {
        _intensivity = data.intensity;
      }
      _chargeLevel = data.chargeLevel;
      _chargeValue = data.chargeValue;
      _chargeValueExt = data.chargeValueExt;

      /// Логирование уровня заряда батареи
      if (logSubject == LogSubject.lsCharge || logSubject == LogSubject.lsAll) {
        if (_dataCount % 60 == 0) {
          GetIt.I<CommunicationLogger>().log(
              '${getTimeBySecCount(_dataCount ~/ 60)}  : ${_chargeValue.toInt()}  ${_chargeLevel.toInt()}%');
        }
      }

      ++_dataCount;

      /// Если программа закончилась (время вышло), то сбросить мощность и дать возможность запустить ее снова
      if (widget.driver.isOver()) {
        widget.driver.resetProgram();
      }
    });
  }

  void onTimer(Timer timer) async {
    ++_secCounter;
    if (_secCounter >= maxTimeDirectControlMode) {
      _stopStimulation();
      Navigator.pop(context);
    }
  }

  void _setDeviceMode(bool isAM, bool isFM, AmMode amMode, double idxFreq,
      Intensivity intensity) async {
    var program = MethodicProgram.togo(
        isAM,
        isFM,
        amMode,
        intensity,
        freqValue[_idxFreq]!,
        (widget.driver.programDuration() - widget.driver.playingTime()) * 1000);
    widget.driver.setProgram(program, true);
  }

  String _valueToString() {
    String retval = '';
    for (int i = 0; i < _value.length; ++i) {
      retval = '$retval${_value[i]} ';
    }
    return retval;
  }

  void _onPlayPauseButton() {
    widget.driver.pause();
    if (!widget.driver.isPlaying()) {
      _powerSet = 0;
    } else {
      widget.driver.setPower(_powerSet);
    }
  }

  void _stopStimulation() {
    widget.driver.resetWorkManagerTask();
    _timer.cancel();
    widget.driver.reset();
    widget.driver.saveSettings();
    widget.driver.removeHandler(_uuidSendData);
    widget.driver.stop();
  }
}
