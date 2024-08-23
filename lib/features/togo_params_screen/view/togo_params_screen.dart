import 'package:bgs_control/features/execute_screen/view/execute_screen.dart';
import 'package:bgs_control/repositories/methodic_programs/model/methodic_program.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:get_it/get_it.dart';
import 'package:uuid/uuid.dart';

import '../../../assets/colors/colors.dart';
import '../../../repositories/bgs_connect/bgs_connect.dart';
import '../../direct_control_screen/widgets/params_widget.dart';
import '../../uikit/texel_button.dart';

class TogoParamsScreen extends StatefulWidget {
  const TogoParamsScreen({
    super.key,
    required this.title,
    required this.device,
  });

  final String title;
  final BluetoothDevice device;

  @override
  State<TogoParamsScreen> createState() => _TogoParamsScreenState();
}

class _TogoParamsScreenState extends State<TogoParamsScreen> {
  bool _isConnected = false;

  bool _isAM = false;
  bool _isFM = false;
  AmMode _amMode = AmMode.am_11;
  Intensity _intensity = Intensity.one;
  double _idxFreq = 0;
  String _uuidGetData = '';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(5),
          child: Stack(
            children: [
              Column(
                children: [
                  const SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
//                    height: 290,
                    child: Image.asset('images/background_hand.png'),
                  ),
                ],
              ),
              Column(
                children: [
                  const SizedBox(
                    width: double.infinity,
                    height: 330,
                  ),
                  Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: backgroundColor,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Column(
                      children: [
                        Text(
                          'Свободный режим',
                          style: theme.textTheme.headlineSmall,
                        ),
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
                        const SizedBox(height: 110),
                      ],
                    ),
                  ),
                ],
              ),
              Positioned(
                bottom: 20,
                right: 20,
                left: 20,
                child: TexelButton.accent(
                  text: 'Запустить',
                  onPressed: () {
                    var program = MethodicProgram.togo(_isAM, _isFM, _amMode,
                        _intensity, freqValue[_idxFreq]!);
                    MaterialPageRoute route = MaterialPageRoute(
                      builder: (context) => ExecuteScreen(
                        title: 'Execution',
                        device: widget.device,
                        program: program,
                      ),
                      settings: const RouteSettings(name: '/execute'),
                    );
                    Navigator.of(context).push(route);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    _uuidGetData = const Uuid().v1();
    GetIt.I<BgsConnect>().addHandler(_uuidGetData, onGetData);
  }

  void onGetData(BlockData data) {
    setState(() {
      _isAM = data.isAM;
      _amMode = data.amMode;
      _isFM = data.isFM;
      _idxFreq = data.idxFreq;
      _intensity = data.intensity;
    });

    GetIt.I<BgsConnect>().removeHandler(_uuidGetData);
  }

  void onAmChanged(bool isAm) {
    setState(() {
      _isAM = isAm;
    });
  }

  void onAmModeChanged(AmMode amMode) {
    setState(() {
      _amMode = amMode;
    });
  }

  void onFmChanged(bool isFm) {
    setState(() {
      _isFM = isFm;
    });
  }

  void onFreqChanged(double idxFreq) {
    setState(() {
      _idxFreq = idxFreq;
    });
  }

  void onIntensityChanged(Intensity intensity) {
    setState(() {
      _intensity = intensity;
    });
  }
}
