import 'dart:async';

import 'package:bgs_control/features/direct_control_screen/widgets/params_widget.dart';
import 'package:bgs_control/features/direct_control_screen/widgets/power_horizontal_widget.dart';
import 'package:bgs_control/features/uikit/widgets/back_screen_button.dart';
import 'package:bgs_control/features/uikit/widgets/charge_message_widget.dart';
import 'package:bgs_control/repositories/bgs_connect/bgs_connect.dart';
import 'package:bgs_control/repositories/methodic_programs/model/methodic_program.dart';
import 'package:bgs_control/utils/charge_values.dart';
import 'package:bgs_control/utils/screen_utils.dart';
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
import '../../uikit/texel_button.dart';
import '../../uikit/widgets/play_pause_button.dart';
import '../../uikit/widgets/program_progress_bar.dart';
import '../../uikit/widgets/shutdown_low_level_battery_dialog.dart';

class DirectControlScreen extends StatefulWidget {
  const DirectControlScreen({
    super.key,
    required this.title,
    required this.driver,
    required this.isNewProgram,
  });

  final String title;
  final DeviceProgramExecutor driver;
  final bool isNewProgram;

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
  double _freq = 1;
  bool _idxFreqChange = true;
  double _chargeLevel = 100;
  double _chargeValue = 0;
  double _chargeValueExt = 0;
  String _uuidSendData = '';
  bool _isVisibleChargeMessageWidget = false;
  bool _isOffLowLvlBat = false;  // Shutdown by low level battery

  bool _isGetPowerSetFromDevice = false;
  bool _isToGoMode = false;

  late Timer _timer;
  int _secCounter = 0;

  @override
  void initState() {
    super.initState();
    widget.driver.setWorkManagerTask(3600000 - 2000);

    if (widget.isNewProgram) {
      widget.driver.setProgram(
          MethodicProgram.one(false, false, AmMode.am_11, Intensivity.one, 60,
              maxDirectModeDuration.toInt() * 60 * 1000),
          true);
      widget.driver.resetProgram();
      widget.driver.run(true); //TODO: Надо в зависимости от режима в приборе
    } else {
      _isGetPowerSetFromDevice = true;
      widget.driver.getProgramParams();
    }
    _uuidSendData = const Uuid().v1();
    widget.driver.initSettings();
    widget.driver.addHandler(_uuidSendData, onGetData);

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
          GestureDetector(
            child: Row(
              children: [
                if (_chargeValue > 0)
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
                if (_chargeValue > 0)
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
                const SizedBox(width: 10),
              ],
            ),
            onTap: () {
              _isVisibleChargeMessageWidget =
              !_isVisibleChargeMessageWidget;
            },
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            if (_chargeLevel <= chargeAlarmBoundLevel &&
                _isVisibleChargeMessageWidget)
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
                freq: _freq,
                onFreqChanged: onFreqChanged,
                intensivity: _intensivity,
                onIntensivityChanged: onIntensivityChanged,
                colorsStyle: ParamsColorsStyle.pcsYellow,
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: backgroundTestColor,
        height: 360,
        child: Column(
          children: [
            /// Регулятор мощности
            PowerHorizontalWidget(
              powerSet: _powerSet,
              powerReal: _powerReal,
              onPowerSet: onPowerSet,
              onPowerReset: onPowerReset,
            ),

            /// Прогресс бар для программы
            if (_dataCount > 0 && widget.driver.stage().duration > 0)
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
                top: 4,
                bottom: 4,
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
    );
  }

  @override
  void dispose() {
    _stopStimulation();
    super.dispose();
  }

  void onAmChanged(bool isAm) {
    if (widget.driver.isPlaying()) {
      _secCounter = 0;
      widget.driver.setWorkManagerTask(3600000 - 2000);

      Timer(const Duration(seconds: 2), () {
        _isAmChange = true;
      });
      _isAmChange = false;
      _setDeviceMode(isAm, _isFm, _amMode, _freq, _intensivity);
    }

    setState(() {
      _isAm = isAm;
    });
  }

  void onAmModeChanged(AmMode amMode) {
    if (widget.driver.isPlaying()) {
      _secCounter = 0;
      widget.driver.setWorkManagerTask(3600000 - 2000);

      Timer(const Duration(seconds: 2), () {
        _isAmModeChange = true;
      });
      _isAmModeChange = false;
      _setDeviceMode(_isAm, _isFm, amMode, _freq, _intensivity);
    }

    setState(() {
      _amMode = amMode;
    });
  }

  void onFmChanged(bool isFm) {
    if (widget.driver.isPlaying()) {
      _secCounter = 0;
      widget.driver.setWorkManagerTask(3600000 - 2000);

      Timer(const Duration(seconds: 2), () {
        _isFmChange = true;
      });
      _isFmChange = false;
      _setDeviceMode(_isAm, isFm, _amMode, _freq, _intensivity);
    }

    setState(() {
      _isFm = isFm;
    });
  }

  void onFreqChanged(double freq) {
    if (widget.driver.isPlaying() && (freq != _freq)) {
      _secCounter = 0;
      widget.driver.setWorkManagerTask(3600000 - 2000);

      Timer(const Duration(seconds: 2), () {
        _idxFreqChange = true;
      });
      _idxFreqChange = false;
      _setDeviceMode(_isAm, _isFm, _amMode, freq, _intensivity);
    }

    setState(() {
      _freq = freq;
    });
  }

  void onIntensivityChanged(Intensivity intensivity) {
    if (widget.driver.isPlaying()) {
      _secCounter = 0;
      widget.driver.setWorkManagerTask(3600000 - 2000);

      Timer(const Duration(seconds: 2), () {
        _intensivityChange = true;
      });
      _intensivityChange = false;
      _setDeviceMode(_isAm, _isFm, _amMode, _freq, intensivity);
    }

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
    /// Читаем значение установленной мощности из устройства, если подключаемся к
    /// устройству, на котором работает программа
    if (_isGetPowerSetFromDevice && widget.driver.targetPower() > 0) {
      _powerSet = widget.driver.targetPower().toDouble();
      _isGetPowerSetFromDevice = false;
    }

    /// Если прибор вернул отключение по низкому заряду, то обработать это
    if (!_isOffLowLvlBat && data.isOffLowLvlBat) {
      _isOffLowLvlBat = data.isOffLowLvlBat;

      shutdownByLowLevelBatteryDialog(context);
    }

    if (!widget.isNewProgram && _dataCount == 0) {
      widget.driver.setProgram(
          MethodicProgram.one(data.isAM, data.isFM, data.amMode,
              data.intensivity, data.freq, 0),
          false);
      widget.driver.run(false);
    }

    setState(() {
      _value = data.source;
      _powerReal = data.power;

      if (widget.driver.isPlaying()) {
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
          _freq = data.freq;
        }
        if (_intensivityChange) {
          _intensivity = data.intensivity;
        }
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

  Future _setDeviceMode(bool isAM, bool isFM, AmMode amMode, double freq,
      Intensivity intensivity) async {
    int duration =
        (widget.driver.programDuration() - widget.driver.playingTime()) * 1000;
    print(
        '------------ _setDeviceMode ($isAM $isFM $amMode $freq, $intensivity   duration: $duration)');
    widget.driver.stop(true);
    var program =
        MethodicProgram.one(isAM, isFM, amMode, intensivity, freq, duration);
    widget.driver.setProgram(program, true);
//    widget.driver.resetProgram();
    widget.driver.playAfterChangeProgram();
    widget.driver.setPower(_powerSet);
  }

  String _valueToString() {
    String retval = '';
    for (int i = 0; i < _value.length; ++i) {
      retval = '$retval${_value[i]} ';
    }
    return retval;
  }

  void _onPlayPauseButton() async {
    await widget.driver.pause();
    if (!widget.driver.isPlaying()) {
//      _powerSet = 0;
    } else {
      await _setDeviceMode(_isAm, _isFm, _amMode, _freq, _intensivity);
      await widget.driver.setPower(_powerSet);
    }
  }

  void _stopStimulation() {
    widget.driver.resetWorkManagerTask();
    _timer.cancel();
    if (!_isToGoMode) {
      widget.driver.reset();
    }
    widget.driver.saveSettings();
    widget.driver.removeHandler(_uuidSendData);
    if (!_isToGoMode) {
      widget.driver.stop(false);
    }
  }
}
