import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Stack(
            children: [
              Column(
                children: [
                  const SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    height: 370,
                    child: Image.asset('images/background_woman.png'),
                  ),

                ],
              ),
              Column(
                children: [
                  const SizedBox(
                    width: double.infinity,
                    height: 330,
                  ),
                  Text(
                    'Режим ToGo',
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
              Positioned(
                bottom: 20,
                right: 20,
                left: 20,
                child: TexelButton.accent(
                  text: 'Запустить',
                  onPressed: () {
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
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
