import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:get_it/get_it.dart';
import 'package:uuid/uuid.dart';

import '../../../assets/colors/colors.dart';
import '../../../repositories/bgs_connect/bgs_connect.dart';
import '../../../repositories/methodic_programs/model/methodic_program.dart';
import '../../../utils/charge_values.dart';
import '../../direct_control_screen/widgets/power_widget.dart';

class ExecuteScreen extends StatefulWidget {
  const ExecuteScreen({
    super.key,
    required this.title,
    required this.device,
    required this.program,
  });

  final String title;
  final BluetoothDevice device;
  final MethodicProgram program;

  @override
  State<ExecuteScreen> createState() => _ExecuteScreenState();
}

class _ExecuteScreenState extends State<ExecuteScreen> {
  double _chargeLevel = 0;
  double _powerSet = 0;
  double _powerReal = 0;
  int _dataCount = 0;
  String _uuidGetData = '';
  int _stage = -1;

  /// Этап воздействия

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 60),
          SizedBox(
            width: double.infinity,
            height: 40,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(widget.program.image),
                const SizedBox(width: 50),
                Text(
                  widget.program.title,
                  style: theme.textTheme.titleLarge,
                ),
              ],
            ),
          ),
          SizedBox(
            width: double.infinity,
            height: 40,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  widget.program.description,
                  style: theme.textTheme.labelMedium,
                ),
              ],
            ),
          ),
          SizedBox(
            width: double.infinity,
            height: 40,
            child: Row(
              children: [
                const SizedBox(width: 50),
                Text(
                  '${widget.device.advName}',
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
          const Spacer(),
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
    GetIt.I<BgsConnect>().setPower(power);
    _powerSet = power;
  }

  void onPowerReset() {
    GetIt.I<BgsConnect>().reset();
    _powerSet = 0;
  }

  @override
  void initState() {
    super.initState();

    _uuidGetData = const Uuid().v1();
    GetIt.I<BgsConnect>().addHandler(_uuidGetData, onGetData);
  }

  @override
  void dispose() {
    GetIt.I<BgsConnect>().removeHandler(_uuidGetData);
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
      GetIt.I<BgsConnect>()
          .setConnectionFailureMode(ConnectionFailureMode.cfmWorking);

      /// Запускаем первый этап
      if (_stage == -1) {
        newStage();
      }
    }
  }

  void newStage() {
    ++_stage;
    if (_stage < widget.program.stagesCount()) {
      /// Если это не последний этап
      var stage = widget.program.stage(_stage);
      double idxFreq = 7;
      for (final element in freqValue.entries) {
        if (element.value == stage.frequency) {
          idxFreq = element.key;
        }
      }
      GetIt.I<BgsConnect>().setMode(
          stage.isAm, stage.isFm, stage.amMode, idxFreq, stage.intensity);

      if (stage.duration >= 0) {
        Timer(Duration(milliseconds: stage.duration), newStage);
      }
    } else {
      /// Все этапы прошли - выходим
      //TODO: написать выход
    }
  }
}
