import 'dart:async';

import 'package:bgs_control/features/direct_control_screen/widgets/params_widget.dart';
import 'package:bgs_control/features/direct_control_screen/widgets/power_widget.dart';
import 'package:bgs_control/features/uikit/widgets/charge_message_widget.dart';
import 'package:bgs_control/repositories/bgs_connect/bgs_connect.dart';
import 'package:bgs_control/utils/charge_values.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../../../repositories/running_manager/device_program_executor.dart';
import '../../../utils/base_defines.dart';

class DirectControlScreen extends StatefulWidget {
  const DirectControlScreen({
    super.key,
    required this.title,
    required this.driver,
  });

  final String title;
  final DeviceProgramExecutor driver;

  @override
  State<DirectControlScreen> createState() => _DirectControlScreenState();
}

class _DirectControlScreenState extends State<DirectControlScreen> {
  List<int> _value = [];
  int _dataCount = 0;

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
  String _uuidSendData = '';

  @override
  void initState() {
    super.initState();

    _uuidSendData = const Uuid().v1();
    widget.driver.addHandler(_uuidSendData, onGetData);
    widget.driver.reset();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Прямое управление',
//          '${widget.title}: ${widget.driver.device.advName}',
          style: theme.textTheme.titleMedium,
        ),
        actions: [
          Icon(getChargeIconByLevel(_chargeLevel), size: 20),
          Text(
            '${_chargeLevel.toInt()}%',
            style: theme.textTheme.titleMedium,
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              if (_chargeLevel <= chargeAlarmBoundLevel)
                const ChargeMessageWidget(),
              // SizedBox(
              //   width: double.infinity,
              //   height: 30,
              //   child:,
              // )
              Text(
                '($_dataCount)  ${_valueToString()}',
                style: theme.textTheme.bodySmall,
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
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Theme.of(context).colorScheme.inversePrimary,
        height: 300,
        child: PowerWidget(
          powerSet: _powerSet,
          powerReal: _powerReal,
          onPowerSet: onPowerSet,
          onPowerReset: onPowerReset,
        ),
      ),
    );
  }

  @override
  void dispose() {
    widget.driver.reset();
    widget.driver.removeHandler(_uuidSendData);
    super.dispose();
  }

  void onAmChanged(bool isAm) {
    Timer(const Duration(seconds: 2), (){
      _isAmChange = true;
    });
    _isAmChange = false;
    _setDeviceMode(isAm, _isFm, _amMode, _idxFreq, _intensivity);
    setState(() {
      _isAm = isAm;
    });
  }

  void onAmModeChanged(AmMode amMode) {
    Timer(const Duration(seconds: 2), (){
      _isAmModeChange = true;
    });
    _isAmModeChange = false;
    _setDeviceMode(_isAm, _isFm, amMode, _idxFreq, _intensivity);
    setState(() {
      _amMode = amMode;
    });
  }

  void onFmChanged(bool isFm) {
    Timer(const Duration(seconds: 2), (){
      _isFmChange = true;
    });
    _isFmChange = false;
    _setDeviceMode(_isAm, isFm, _amMode, _idxFreq, _intensivity);
    setState(() {
      _isFm = isFm;
    });
  }

  void onFreqChanged(double idxFreq) {
    Timer(const Duration(seconds: 2), (){
      _idxFreqChange = true;
    });
    _idxFreqChange = false;
    _setDeviceMode(_isAm, _isFm, _amMode, idxFreq, _intensivity);
    setState(() {
      _idxFreq = idxFreq;
    });
  }

  void onIntensityChanged(Intensivity intensivity) {
    Timer(const Duration(seconds: 2), (){
      _intensivityChange = true;
    });
    _intensivityChange = false;
    _setDeviceMode(_isAm, _isFm, _amMode, _idxFreq, intensivity);
    setState(() {
      _intensivity = intensivity;
    });
  }

  void onPowerSet(double power) {
    widget.driver.setPower(power);
    _powerSet = power;
  }

  void onPowerReset() {
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
        _powerSet = 0;
      }

      if (_intensivityChange) {
        _intensivity = data.intensity;
      }
      _chargeLevel = data.chargeLevel;

      ++_dataCount;
    });

    if (_dataCount == 1) {
      widget.driver.setConnectionFailureMode(ConnectionFailureMode.cfmWorking);
    }
  }

  void _setDeviceMode(bool isAM, bool isFM, AmMode amMode, double idxFreq, Intensivity intensity) {
    widget.driver.setMode(isAM, isFM, amMode, idxFreq, intensity);
  }

  String _valueToString() {
    String retval = '';
    for (int i = 0; i < _value.length; ++i) {
      retval = '$retval${_value[i]} ';
    }
    return retval;
  }
}
