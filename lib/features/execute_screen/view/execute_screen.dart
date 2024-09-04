import 'dart:async';

import 'package:bgs_control/features/uikit/widgets/back_screen_button.dart';
import 'package:bgs_control/utils/baseutils.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../../../assets/colors/colors.dart';
import '../../../repositories/bgs_connect/bgs_connect.dart';
import '../../../repositories/methodic_programs/model/methodic_program.dart';
import '../../../repositories/running_manager/device_program_executor.dart';
import '../../../utils/base_defines.dart';
import '../../../utils/charge_values.dart';
import '../../direct_control_screen/widgets/power_widget.dart';
import '../../uikit/widgets/charge_message_widget.dart';

class ExecuteScreen extends StatefulWidget {
  ExecuteScreen({
    super.key,
    required this.title,
    required this.driver,
    required MethodicProgram program,
  }) {
    driver.setProgram(program);
  }

  final String title;
  final DeviceProgramExecutor driver;

  @override
  State<ExecuteScreen> createState() => _ExecuteScreenState();
}

class _ExecuteScreenState extends State<ExecuteScreen> {
  double _chargeLevel = 100;
  double _powerSet = 0;
  double _powerReal = 0;
  int _dataCount = 0;
  String _uuidGetData = '';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 60),
          SizedBox(
            width: double.infinity,
            height: 60,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const BackScreenButton(),
                Image.asset(
                    'lib/assets/icons/programs/${widget.driver.program.image}'),
                const SizedBox(width: 20),
                Expanded(
                  child: Text(
                    widget.driver.program.title,
                    style: theme.textTheme.titleLarge,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: 400,
            height: 40,
            child: Text(
              widget.driver.program.description,
              style: theme.textTheme.labelMedium,
            ),
          ),
          SizedBox(
            width: double.infinity,
            height: 40,
            child: Row(
              children: [
                const SizedBox(width: 50),
                Text(
                  widget.driver.device.advName,
                  style: theme.textTheme.titleLarge,
                ),
                const Spacer(),
                Icon(getChargeIconByLevel(_chargeLevel), size: 20),
                Text(
                  '${_chargeLevel.toInt()}%',
                  style: theme.textTheme.titleLarge,
                ),
                const SizedBox(width: 50),
              ],
            ),
          ),
          if (_chargeLevel <= chargeAlarmBoundLevel)
            const ChargeMessageWidget(),
          const SizedBox(height: 30),
          Row(
            /// Кнопка play / pause
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _getPlayPauseButton(widget.driver.isPlaying()
                  ? TypePlayPauseButton.pause
                  : TypePlayPauseButton.play),
            ],
          ),
          Row(
            /// Время воздействия
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                getTimeBySecCount(widget.driver.playingTime()),
                style: theme.textTheme.headlineLarge,
              ),
            ],
          ),
          Row(
            /// Нвзвание этапа
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Этап ${widget.driver.idxStage() + 1} : "${widget.driver.stage().comment}"',
                style: theme.textTheme.titleMedium,
              ),
            ],
          ),
          Row(
            /// Параметры воздействия
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _stimulationParamsToString(),
                style: theme.textTheme.titleSmall,
              ),
            ],
          ),
          Row(
            /// Время воздействия
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                getTimeBySecCount(widget.driver.stageTime()),
                style: theme.textTheme.headlineSmall,
              ),
            ],
          ),
          const Spacer(),
          if (widget.driver.isPlaying())
            Row(
              children: [
                const SizedBox(width: 5),
                SizedBox(
                  width: 50,
                  height: 50,
                  child: Image.asset('images/attention.png'),
                ),
                const SizedBox(width: 5),
                Expanded(
                  child: Text(
                    'Увеличивайте мощность воздействия, не допуская появления болевых ощущений',
                    style: theme.textTheme.bodyLarge,
                  ),
                ),
              ],
            ),
          if (widget.driver.isPlaying())
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.inversePrimary,
                borderRadius: BorderRadius.circular(10),
              ),
              child: PowerWidget(
                powerSet: _powerSet,
                powerReal: _powerReal,
                onPowerSet: onPowerSet,
                onPowerReset: onPowerReset,
              ),
            ),
        ],
      ),
    );
  }

  void onPowerSet(double power) {
    widget.driver.setPower(power);
    _powerSet = power;
  }

  void onPowerReset() {
    widget.driver.reset();
    _powerSet = 0;
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
    widget.driver.setPower(0);
    widget.driver.removeHandler(_uuidGetData);
    widget.driver.stop();

    super.dispose();
  }

  void onGetData(BlockData data) {
    setState(() {
      _powerReal = data.power;
      if (_dataCount == 1) {
        _powerSet = _powerReal;
      }

      if (data.isPowerReset) {
        _powerSet = 0;
      }

      _chargeLevel = data.chargeLevel;

      ++_dataCount;
    });

    /// Посылаем команду работать даже при прерывании связи
    if (_dataCount == 1) {
      widget.driver.setConnectionFailureMode(ConnectionFailureMode.cfmWorking);
    }

    if (widget.driver.isOver()){
      /// Программа завершена - выходим
      Navigator.of(context).popUntil(ModalRoute.withName('/select_method'));
    }
  }

  Widget _getPlayPauseButton(TypePlayPauseButton icon) {
    return GestureDetector(
      onTap: () {
        setState(() {
          widget.driver.pause();
          if (!widget.driver.isPlaying()) {
            _powerSet = 0;
          }
        });
      },
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: white,
        ),
        child: Center(
          child: Image.asset(
            icon == TypePlayPauseButton.play
                ? 'images/play.png'
                : 'images/pause.png',
          ),
        ),
      ),
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

    if (widget.driver.stage().duration >= 0) {
      retval =
          '$retval   Время : ${getTimeBySecCount(widget.driver.stage().duration ~/ 1000)}';
    } else {
      retval = '$retval   Время не задано';
    }

    return retval;
  }
}

enum TypePlayPauseButton { play, pause }
