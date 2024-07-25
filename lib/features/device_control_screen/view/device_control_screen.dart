import 'dart:ffi';

import 'package:bgs_control/repositories/bgs_connect/bgs_connect.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

enum AmMode {am_11, am_31, am_51}
Map<AmMode, String> amModeNames = <AmMode, String> {
  AmMode.am_11: '1:1',
  AmMode.am_31: '3:1',
  AmMode.am_51: '5:1',
};

Map <double, double> freqValue = <double, double> {
  0: 15,
  1: 30,
  2: 60,
  3: 90,
  4: 120,
  5: 180,
  6: 350
};

class DeviceControlScreen extends StatefulWidget {
  const DeviceControlScreen(
      {super.key, required this.title, required this.device});

  final String title;
  final BluetoothDevice device;

  @override
  State<DeviceControlScreen> createState() => _DeviceControlScreenState();
}

class _DeviceControlScreenState extends State<DeviceControlScreen> {
  late BgsConnect _connect;
  List<int> _value = [];
  int _dataCount = 0;

  bool _isAM = false;
  bool _isFM = false;
  AmMode _amMode = AmMode.am_11;
  double _powerSet = 0;
  double _powerReal = 0;
  double _idxFreq = 0;
  double _intensity = 0;

  void onSendData(List<int> value){
    setState(() {
      _value = value;
      _powerReal = _value[5].toDouble();

      _isAM = _value[9] > 0;
      if (_isAM) {
        _amMode = AmMode.values[_value[9] - 1];
      } else {
        _amMode = AmMode.am_11;
      }

      _isFM = _value[10] == 7;
      if (!_isFM){
        _idxFreq = _value[10].toDouble();
      }

      _intensity = _value[11].toDouble();

      ++_dataCount;
    });
  }

  void _setDeviceMode(){
    int idxAM = 0;
    if (_isAM) {
      idxAM = _amMode.index + 1;
    }

    int idxFM = 7;
    if (!_isFM) {
      idxFM = _idxFreq.toInt();
    }

    _connect.setMode(idxAM, idxFM, _intensity.toInt());
  }

  String _valueToString() {
    String retval = '';
    for (int i = 0; i < _value.length; ++i) {
      retval = '$retval${_value[i]} ';
    }
    return retval;
  }

  @override
  void initState() {
    super.initState();
    _connect = BgsConnect(device: widget.device, sendData: onSendData);
  }

  @override
  void dispose() {
    _connect.reset();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text('${widget.title}  :  ${widget.device.advName}'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Text(_valueToString(),
                  style: Theme.of(context).textTheme.headlineSmall),
              Text('Принято пакетов : $_dataCount',
                  style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: 40),
              Row(
                children: [
                  const SizedBox(width: 100),
                  Text(_powerReal.round().toString(),
                      style: Theme.of(context).textTheme.displayLarge),
                  const Spacer(),
                  ElevatedButton(
                      onPressed: () {
                        _connect.reset();
                      },
                      child: Text('Сброс',
                          style: Theme.of(context).textTheme.headlineSmall),
                  )
                ],
              ),
              const SizedBox(height: 40),
              Row(  ///< Флажок "AM"
                children: [
                  Text('Ампл. модуляция (AM)',
                      style: Theme.of(context).textTheme.titleLarge),
                  const Spacer(),
                  Switch(
                      value: _isAM,
                      activeColor: Colors.teal.shade900,
                      onChanged: (bool? value) {
                        setState(() {
                          _isAM = value!;
                        });
                        _setDeviceMode();
                      })
                ],
              ),
              const SizedBox(height: 10),
              Row(  ///< Флажок "FM"
                children: [
                  Text('Част. модуляция (FM)',
                      style: Theme.of(context).textTheme.titleLarge),
                  const Spacer(),
                  Switch(
                      value: _isFM,
                      activeColor: Colors.teal.shade900,
                      onChanged: (bool? value) {
                        setState(() {
                          _isFM = value!;
                        });
                        _setDeviceMode();
                      })
                ],
              ),
              const SizedBox(height: 10),
              if (_isAM) SegmentedButton<AmMode>(  ///< Переключатель амплитудной модуляции
                  segments:  <ButtonSegment<AmMode>>[
                    ButtonSegment<AmMode>(
                        value: AmMode.am_11,
                        label: Text(amModeNames[AmMode.am_11]!),
                    ),
                    ButtonSegment<AmMode>(
                      value: AmMode.am_31,
                      label: Text(amModeNames[AmMode.am_31]!),
                    ),
                    ButtonSegment<AmMode>(
                      value: AmMode.am_51,
                      label: Text(amModeNames[AmMode.am_51]!),
                    ),
                  ],
                  selected: <AmMode>{_amMode},
                  onSelectionChanged: (Set<AmMode> newSelection){
                    setState(() {
                      _amMode = newSelection.first;
                      _setDeviceMode();
                    });
                  },
              ),
              const SizedBox(height: 10),
              Column(          ///< Регулятор мощности
                children: [
                  Text('Мощность ${_powerSet.toInt()}',
                      style: Theme.of(context).textTheme.titleLarge),
                  Slider.adaptive(
                      value: _powerSet,
                      label: _powerSet.round().toString(),
                      min: 0,
                      max: 125,
                      divisions: 125,
                      onChanged: (double value){
                        setState(() {
                          _powerSet = value;
                        });
                      },
                      onChangeEnd: (double value){
                        ///< В этот момент мы будем устанавливать мощность
                        _connect.setPower(_powerSet);
                      },
                  ),
                ],
              ),
              const SizedBox(height: 10),
              if (!_isFM) Column(          ///< Регулятор частоты
                children: [
                  Text('Частота ${freqValue[_idxFreq]!.toInt()}',
                      style: Theme.of(context).textTheme.titleLarge),
                  Slider.adaptive(
                    value: _idxFreq,
                    label: freqValue[_idxFreq]!.round().toString(),
                    min: 0,
                    max: 6,
                    divisions: 6,
                    onChanged: (double value){
                      setState(() {
                        _idxFreq = value;
                      });
                    },
                    onChangeEnd: (double value){
                      ///< В этот момент мы будем устанавливать частоту
                      _setDeviceMode();
                      print('----------- frequency = $_idxFreq');
                    },
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Column(          ///< Регулятор интенсивности
                children: [
                  Text('Интенсивность ${(_intensity + 1).toInt()}',
                      style: Theme.of(context).textTheme.titleLarge),
                  Slider.adaptive(
                    value: _intensity,
                    label: (_intensity + 1).round().toString(),
                    min: 0,
                    max: 3,
                    divisions: 3,
                    onChanged: (double value){
                      setState(() {
                        _intensity = value;
                      });
                    },
                    onChangeEnd: (double value){
                      ///< В этот момент мы будем устанавливать интенсивность
                      _setDeviceMode();
                      print('----------- intensity = $_intensity');
                    },
                  ),
                ],
              ),
            ],
          ),
        ));
  }
}
