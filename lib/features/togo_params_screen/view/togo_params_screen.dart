import 'package:bgs_control/features/execute_screen/view/execute_screen.dart';
import 'package:bgs_control/repositories/methodic_programs/model/methodic_program.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../../../assets/colors/colors.dart';
import '../../../repositories/bgs_connect/bgs_connect.dart';
import '../../../repositories/bgs_connect/bgs_defines.dart';
import '../../../repositories/running_manager/device_program_executor.dart';
import '../../../utils/baseutils.dart';
import '../../direct_control_screen/widgets/params_widget.dart';
import '../../uikit/texel_button.dart';
import '../../uikit/widgets/back_screen_button.dart';

class TogoParamsScreen extends StatefulWidget {
  const TogoParamsScreen({
    super.key,
    required this.title,
    required this.driver,
  });

  final String title;
  final DeviceProgramExecutor driver;

  @override
  State<TogoParamsScreen> createState() => _TogoParamsScreenState();
}

class _TogoParamsScreenState extends State<TogoParamsScreen> {
  bool _isAM = false;
  bool _isFM = false;
  AmMode _amMode = AmMode.am_11;
  Intensivity _intensity = Intensivity.one;
  double _duration = 30;
  double _freq = 1;
  String _uuidGetData = '';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              width: double.infinity,
              color: backgroundTestColor,
              child: Image.asset(
                'images/background_hand.png',
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
              top: 20,
              left: 20,
              child: BackScreenButton(
                onBack: () {
                  Navigator.pop(context);
                },
                hasBackground: true,
              ),
            ),
            Column(
              children: [
                const Spacer(),
                Container(
                  width: double.infinity,
                  height: 580,
                  decoration: BoxDecoration(
                    color: backgroundColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 8,
                        ),
                        child: Row(
                          children: [
                            Text(
                              'Индивидуальный режим',
                              style: theme.textTheme.titleMedium,
                              textScaler: const TextScaler.linear(1.0),
                            ),
                          ],
                        ),
                      ),
                      const Divider(
                        height: 0,
                        indent: 0,
                        thickness: 1,
                      ),
                      Expanded(
                        child: ListView(
                          padding: const EdgeInsets.symmetric(horizontal: 14),
                          shrinkWrap: true,
                          children: [
                            SizedBox(
                              width: double.infinity,
                              child: ParamsWidget(
                                isAm: _isAM,
                                onAmChanged: onAmChanged,
                                amMode: _amMode,
                                onAmModeChanged: onAmModeChanged,
                                isFm: _isFM,
                                onFmChanged: onFmChanged,
                                freq: _freq,
                                onFreqChanged: onFreqChanged,
                                intensity: _intensity,
                                onIntensityChanged: onIntensityChanged,
                                colorsStyle: ParamsColorsStyle.pcsOrdinal,
                              ),
                            ),
                            const Divider(),
                            Text(
                              'Длительность: ${_duration.round()} мин',
                              style: theme.textTheme.labelMedium,
                              textScaler: const TextScaler.linear(1.0),
                            ),
                            Slider.adaptive(
                              value: _duration,
                              label: _duration.round().toString(),
                              min: 1,
                              max: 40,
                              divisions: 40,
                              activeColor: filledAccentButtonColor,
                              thumbColor: filledAccentButtonColor,
                              inactiveColor: filledSecondaryButtonColor,
                              onChanged: (double value) {
                                setState(() {
                                  _duration = value;
                                });
                              },
                              onChangeEnd: (double value) {
                                /// В этот момент мы будем устанавливать частоту
//                                widget.onFreqChanged(widget.idxFreq);
                              },
                            ),
                            const SizedBox(height: 60),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Positioned(
              bottom: 0,
              right: 0,
              left: 0,
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(color: white),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                child: TexelButton.accent(
                  text: 'Запустить',
                  onPressed: () {
                    var program = MethodicProgram.togo(
                        _isAM,
                        _isFM,
                        _amMode,
                        _intensity,
                        _freq,
                        _duration.round() * 60 * 1000);

                    pushScreen(
                      context,
                      (context, animation, secondaryAnimation) => ExecuteScreen(
                        title: 'Execution',
                        driver: widget.driver,
                        program: program,
                        isNewProgram: true,
                      ),
                      '/execute',
                      ShiftDirection.rightToLeft,
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    _uuidGetData = const Uuid().v1();
    widget.driver.addHandler(_uuidGetData, onGetData);
  }

  void onGetData(BlockData data) {
    setState(() {
      _isAM = data.isAM;
      _amMode = data.amMode;
      _isFM = data.isFM;
      _freq = data.freq;
      _intensity = data.intensity;
    });

    widget.driver.removeHandler(_uuidGetData);
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

  void onFreqChanged(double freq) {
    setState(() {
      _freq = freq;
    });
  }

  void onIntensityChanged(Intensivity intensity) {
    setState(() {
      _intensity = intensity;
    });
  }
}
