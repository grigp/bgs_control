import 'package:bgs_control/features/direct_control_screen/widgets/params_widget.dart';
import 'package:bgs_control/features/direct_control_screen/widgets/power_widget.dart';
import 'package:bgs_control/repositories/bgs_connect/bgs_connect.dart';
import 'package:bgs_control/utils/charge_values.dart';
import 'package:bgs_control/utils/extra.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:get_it/get_it.dart';
import 'package:uuid/uuid.dart';

class DirectControlScreen extends StatefulWidget {
  const DirectControlScreen({
    super.key,
    required this.title,
    required this.device,
  });

  final String title;
  final BluetoothDevice device;

  @override
  State<DirectControlScreen> createState() => _DirectControlScreenState();
}

class _DirectControlScreenState extends State<DirectControlScreen> {
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
  bool _isConnected = false;
  String _uuidSendData = '';


  @override
  void initState() {
    super.initState();
    GetIt.I<BgsConnect>().init(widget.device);
    widget.device.connectionState.listen((event) {
      _isConnected = event == BluetoothConnectionState.connected;
    });
    _uuidSendData = const Uuid().v1();

    GetIt.I<BgsConnect>().addHandler(_uuidSendData, onSendData);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${widget.title}: ${widget.device.advName}',
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
              Text(
                '($_dataCount)  ${_valueToString()}',
                style: theme.textTheme.bodySmall,
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: ParamsWidget(
                  isAm: _isAM,
                  onAmChanged: onAmChanged,
                  amMode: _amMode,
                  onAmModeChanged: onAmModeChanged,
                  isFm: _isFM,
                  onFmChanged: onFmChanged,
                  idxFreq: _idxFreq,
                  onFreqChanged: onFreqChanged,
                  intensity: _intensity,
                  onIntensityChanged: onIntensityChanged,
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Theme.of(context).colorScheme.inversePrimary,
        height: 290,
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
    GetIt.I<BgsConnect>().removeHandler(_uuidSendData);

    if (_isConnected) {
      GetIt.I<BgsConnect>().reset();
      GetIt.I<BgsConnect>().stop();

      widget.device.disconnectAndUpdateStream().catchError((e) {});
    }
    super.dispose();
  }

  void onAmChanged(bool isAm) {
    setState(() {
      _isAM = isAm;
    });
    _setDeviceMode();
  }

  void onAmModeChanged(AmMode amMode) {
    setState(() {
      _amMode = amMode;
    });
    _setDeviceMode();
  }

  void onFmChanged(bool isFm) {
    setState(() {
      _isFM = isFm;
    });
    _setDeviceMode();
  }

  void onFreqChanged(double idxFreq) {
    setState(() {
      _idxFreq = idxFreq;
    });
    _setDeviceMode();
  }

  void onIntensityChanged(Intensity intensity) {
    setState(() {
      _intensity = intensity;
    });
    _setDeviceMode();
  }

  void onPowerSet(double power) {
    GetIt.I<BgsConnect>().setPower(power);
    _powerSet = power;
  }

  void onPowerReset() {
    GetIt.I<BgsConnect>().reset();
    _powerSet = 0;
  }

  void onSendData(BlockData data) {
    setState(() {
      _value = data.source;
      _powerReal = data.power;

      _isAM = data.isAM;
      _amMode = data.amMode;

      _isFM = data.isFM;
      _idxFreq = data.idxFreq;

      if (data.isPowerReset) {
        _powerSet = 0;
      }

      _intensity = data.intensity;
      _chargeLevel = data.chargeLevel;

      ++_dataCount;
    });

    if (_dataCount == 1) {
      GetIt.I<BgsConnect>()
          .setConnectionFailureMode(ConnectionFailureMode.cfmWorking);
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
