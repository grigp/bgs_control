import 'package:bgs_control/repositories/bgs_connect/bgs_connect.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:get_it/get_it.dart';

import '../../../utils/charge_values.dart';

class DeviceControlScreen extends StatefulWidget {
  const DeviceControlScreen({
    super.key,
    required this.title,
    required this.device,
  });

  final String title;
  final BluetoothDevice device;

  @override
  State<DeviceControlScreen> createState() => _DeviceControlScreenState();
}

class _DeviceControlScreenState extends State<DeviceControlScreen> {
  List<int> _value = [];
  int _dataCount = 0;

  bool _isAM = false;
  bool _isFM = false;
  AmMode _amMode = AmMode.am_11;
  Intensity _intensity = Intensity.one;
  double _powerSet = 0;
  double _powerReal = 0;
  double _idxFreq = 0;
  double _chargeLevel = 0;

  Map<AmMode, String> amModeNames = <AmMode, String>{
    AmMode.am_11: '1:1',
    AmMode.am_31: '3:1',
    AmMode.am_51: '5:1',
  };

  Map<double, double> freqValue = <double, double>{
    0: 15,
    1: 30,
    2: 60,
    3: 90,
    4: 120,
    5: 180,
    6: 350
  };

  final ButtonStyle _resetButtonStyle = ElevatedButton.styleFrom(
    foregroundColor: Colors.white,
    backgroundColor: Colors.teal.shade900,
    minimumSize: const Size(350, 45),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(25),
      ),
    ),
  );

  @override
  void initState() {
    super.initState();
    GetIt.I<BgsConnect>().init(widget.device, onSendData);
  }

  @override
  void dispose() {
    GetIt.I<BgsConnect>().reset();
    GetIt.I<BgsConnect>().stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('${widget.title}: ${widget.device.advName}'),
        actions: [
          Icon(getChargeIconByLevel(_chargeLevel)),
          Text(
            '${_chargeLevel.toInt()}%',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Text(
                _valueToString(),
                style: Theme.of(context).textTheme.labelLarge,
              ),
              Text(
                'Принято пакетов : $_dataCount',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 30),
              Row(
                /// Флажок "AM"
                children: [
                  Text(
                    'Ампл. модуляция (AM)',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const Spacer(),
                  Switch(
                    value: _isAM,
                    activeColor: Colors.teal.shade900,
                    onChanged: (bool? value) {
                      setState(() {
                        _isAM = value!;
                      });
                      _setDeviceMode();
                    },
                  ),
                ],
              ),
              if (_isAM)

                /// Переключатель амплитудной модуляции
                SizedBox(
                  width: double.infinity,
                  child: SegmentedButton<AmMode>(
                    segments: <ButtonSegment<AmMode>>[
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
                    onSelectionChanged: (Set<AmMode> newSelection) {
                      setState(() {
                        _amMode = newSelection.first;
                        _setDeviceMode();
                      });
                    },
                  ),
                ),
              Row(
                /// Флажок "FM"
                children: [
                  Text(
                    'Част. модуляция (FM)',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const Spacer(),
                  Switch(
                    value: _isFM,
                    activeColor: Colors.teal.shade900,
                    onChanged: (bool? value) {
                      setState(() {
                        _isFM = value!;
                      });
                      _setDeviceMode();
                    },
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Column(
                /// Регулятор мощности
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Мощность ${_powerSet.toInt()}',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  Slider.adaptive(
                    value: _powerSet,
                    label: _powerSet.round().toString(),
                    min: 0,
                    max: 125,
                    divisions: 125,
                    activeColor: Colors.teal.shade900,
                    onChanged: (double value) {
                      setState(() {
                        _powerSet = value;
                      });
                    },
                    onChangeEnd: (double value) {
                      /// В этот момент мы будем устанавливать мощность
                      GetIt.I<BgsConnect>().setPower(_powerSet);
                    },
                  ),
                ],
              ),
              const SizedBox(height: 10),
              if (!_isFM)

                /// Регулятор частоты
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Частота: ${freqValue[_idxFreq]!.toInt()}',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    Slider.adaptive(
                      value: _idxFreq,
                      label: freqValue[_idxFreq]!.round().toString(),
                      min: 0,
                      max: 6,
                      divisions: 6,
                      activeColor: Colors.teal.shade900,
                      onChanged: (double value) {
                        setState(() {
                          _idxFreq = value;
                        });
                      },
                      onChangeEnd: (double value) {
                        /// В этот момент мы будем устанавливать частоту
                        _setDeviceMode();
                        print('----------- frequency = $_idxFreq');
                      },
                    ),
                  ],
                ),
              const SizedBox(height: 10),
              Column(
                /// Переключатель интенсивности
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Интенсивность',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: SegmentedButton<Intensity>(
                      segments: const <ButtonSegment<Intensity>>[
                        ButtonSegment<Intensity>(
                          value: Intensity.one,
                          label: Text('1'),
                        ),
                        ButtonSegment<Intensity>(
                          value: Intensity.two,
                          label: Text('2'),
                        ),
                        ButtonSegment<Intensity>(
                          value: Intensity.free,
                          label: Text('3'),
                        ),
                        ButtonSegment<Intensity>(
                          value: Intensity.four,
                          label: Text('4'),
                        ),
                      ],
                      selected: <Intensity>{_intensity},
                      onSelectionChanged: (Set<Intensity> newSelection) {
                        setState(() {
                          _intensity = newSelection.first;
                          _setDeviceMode();
                        });
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Theme.of(context).colorScheme.inversePrimary,
        height: 175,
        child: IconTheme(
          data: IconThemeData(color: Theme.of(context).colorScheme.onPrimary),
          child: Column(
            children: [
              Row(
                children: [
                  const Spacer(flex: 2),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        --_powerSet;
                        GetIt.I<BgsConnect>().setPower(_powerSet);
                      });
                    },
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: Colors.teal.shade900,
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.remove,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    _powerReal.round().toString(),
                    style: TextStyle(
                      fontSize: 60,
                      color: Colors.teal.shade900,
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        ++_powerSet;
                        GetIt.I<BgsConnect>().setPower(_powerSet);
                      });
                    },
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: Colors.teal.shade900,
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.add,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const Spacer(flex: 2),
                ],
              ),
              const SizedBox(height: 10),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    _powerSet = 0;
                    GetIt.I<BgsConnect>().reset();
                  },
                  style: _resetButtonStyle,
                  child: const Text(
                    'Сброс',
                    style: TextStyle(fontSize: 22),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void onSendData(List<int> value) {
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
      if (!_isFM) {
        _idxFreq = _value[10].toDouble();
      }

      if ((_value[4] & 0x80) != 0) {
        _powerSet = 0;
      }

      _chargeLevel = getChargeLevelByADC(_value[3]);

      ++_dataCount;
    });

    if (_dataCount == 1) {
      GetIt.I<BgsConnect>().setConnectionFailureMode(ConnectionFailureMode.cfmWorking);
    }
  }

  void _setDeviceMode() {
    int idxAM = 0;
    if (_isAM) {
      idxAM = _amMode.index + 1;
    }

    int idxFM = 7;
    if (!_isFM) {
      idxFM = _idxFreq.toInt();
    }

    GetIt.I<BgsConnect>().setMode(idxAM, idxFM, _intensity.index);
  }

  String _valueToString() {
    String retval = '';
    for (int i = 0; i < _value.length; ++i) {
      retval = '$retval${_value[i]} ';
    }
    return retval;
  }
}

enum AmMode { am_11, am_31, am_51 }

enum Intensity { one, two, free, four }
