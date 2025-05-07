import 'package:bgs_control/features/direct_control_screen/widgets/standard_frequency_dialog.dart';
import 'package:bgs_control/repositories/bgs_connect/bgs_connect.dart';
import 'package:flutter/material.dart';

import '../../../assets/colors/colors.dart';
import '../../../repositories/bgs_connect/bgs_defines.dart';

//ignore: must_be_immutable
class ParamsWidget extends StatefulWidget {
  ParamsWidget({
    super.key,
    required this.isAm,
    required this.onAmChanged,
    required this.amMode,
    required this.onAmModeChanged,
    required this.isFm,
    required this.onFmChanged,
    required this.freq,
    required this.onFreqChanged,
    required this.intensity,
    required this.onIntensityChanged,
    required this.colorsStyle,
  });

  bool isAm;
  final Function onAmChanged;
  AmMode amMode;
  final Function onAmModeChanged;
  bool isFm;
  final Function onFmChanged;
  double freq;
  final Function onFreqChanged;
  Intensivity intensity;
  final Function onIntensityChanged;

  final ParamsColorsStyle colorsStyle;

  @override
  State<ParamsWidget> createState() => _ParamsWidgetState();
}

class _ParamsWidgetState extends State<ParamsWidget> {
  bool _isFmExpanded = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        children: [
          Row(
            /// Флажок "AM"
            children: [
              Text(
                'Ампл. модуляция (AM)',
                style: theme.textTheme.labelMedium,
                textScaler: const TextScaler.linear(1.0),
              ),
              const Spacer(),
              Switch(
                value: widget.isAm,
                activeColor: white,
                activeTrackColor:
                    widget.colorsStyle == ParamsColorsStyle.pcsYellow
                        ? backgroundDarkTestColor
                        : accentColor,
                inactiveTrackColor: Colors.white54,
                onChanged: (bool? value) {
                  setState(() {
                    widget.isAm = value!;
                  });
                  widget.onAmChanged(widget.isAm);
                },
              ),
            ],
          ),

          /// Переключатель амплитудной модуляции
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeIn,
            height: widget.isAm ? 50 : 0,
            width: double.infinity,
            child: widget.isAm
                ? SegmentedButton<AmMode>(
                    segments: <ButtonSegment<AmMode>>[
                      ButtonSegment<AmMode>(
                        value: AmMode.am_11,
                        label: Text(
                          amModeNames[AmMode.am_11]!,
                          textScaler: const TextScaler.linear(1.0),
                        ),
                      ),
                      ButtonSegment<AmMode>(
                        value: AmMode.am_31,
                        label: Text(
                          amModeNames[AmMode.am_31]!,
                          textScaler: const TextScaler.linear(1.0),
                        ),
                      ),
                      ButtonSegment<AmMode>(
                        value: AmMode.am_51,
                        label: Text(
                          amModeNames[AmMode.am_51]!,
                          textScaler: const TextScaler.linear(1.0),
                        ),
                      ),
                    ],
                    selected: <AmMode>{widget.amMode},
                    onSelectionChanged: (Set<AmMode> newSelection) {
                      setState(() {
                        widget.amMode = newSelection.first;
                        widget.onAmModeChanged(widget.amMode);
                      });
                    },
                  )
                : const Text(''),
          ),
          const Divider(),
          Row(
            /// Флажок "FM"
            children: [
              Text(
                'Част. модуляция (FM)',
                style: theme.textTheme.labelMedium,
                textScaler: const TextScaler.linear(1.0),
              ),
              const Spacer(),
              Switch(
                value: widget.isFm,
                activeColor: white,
                activeTrackColor:
                    widget.colorsStyle == ParamsColorsStyle.pcsYellow
                        ? backgroundDarkTestColor
                        : accentColor,
                inactiveTrackColor: Colors.white54,
                onChanged: (bool? value) {
                  setState(() {
                    widget.isFm = value!;
                    _isFmExpanded = false;
                  });
                  widget.onFmChanged(widget.isFm);
                },
              ),
            ],
          ),
          const Divider(),
          const SizedBox(height: 10),

          /// Регулятор частоты
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeIn,
            onEnd: () {
              setState(() {
                _isFmExpanded = true;
              });
            },
            height: !widget.isFm ? 90 : 0,
            child: !widget.isFm && _isFmExpanded
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Частота: ${widget.freq.toInt()} Гц',
                              style: theme.textTheme.labelMedium,
                              textScaler: const TextScaler.linear(1.0),
                            ),
                            const SizedBox(width: 20),
                            const Icon(
                              Icons.open_in_browser,
                              size: 25,
                            ),
                          ],
                        ),
                        onTap: () {
                          var freq = _getStandardFrequency(context);
                          // setState(() {
                          //   widget.freq = freq;
                          // });
                        },
                      ),
                      Slider.adaptive(
                        value: widget.freq,
                        label: widget.freq.round().toString(),
                        min: 1,
                        max: 350,
                        //divisions: 6,
                        activeColor:
                            widget.colorsStyle == ParamsColorsStyle.pcsYellow
                                ? backgroundDarknessTestColor
                                : filledAccentButtonColor,
                        thumbColor:
                            widget.colorsStyle == ParamsColorsStyle.pcsYellow
                                ? backgroundDarknessTestColor
                                : filledAccentButtonColor,
                        inactiveColor:
                            widget.colorsStyle == ParamsColorsStyle.pcsYellow
                                ? backgroundCarpetButtonTestColor
                                : filledSecondaryButtonColor,
                        onChanged: (double value) {
                          setState(() {
                            widget.freq = value;
                          });
                        },
                        onChangeEnd: (double value) {
                          /// В этот момент мы будем устанавливать частоту
                          widget.onFreqChanged(widget.freq);
                        },
                      ),
                      const Divider(),
                    ],
                  )
                : const Text(''),
          ),
          const SizedBox(height: 10),
          Column(
            /// Переключатель интенсивности
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Интенсивность',
                style: theme.textTheme.labelMedium,
                textScaler: const TextScaler.linear(1.0),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: SegmentedButton<Intensivity>(
                  segments: const <ButtonSegment<Intensivity>>[
                    ButtonSegment<Intensivity>(
                      value: Intensivity.one,
                      label: Text(
                        '1',
                        textScaler: const TextScaler.linear(1.0),
                      ),
                    ),
                    ButtonSegment<Intensivity>(
                      value: Intensivity.two,
                      label: Text(
                        '2',
                        textScaler: const TextScaler.linear(1.0),
                      ),
                    ),
                    ButtonSegment<Intensivity>(
                      value: Intensivity.three,
                      label: Text(
                        '3',
                        textScaler: const TextScaler.linear(1.0),
                      ),
                    ),
                    ButtonSegment<Intensivity>(
                      value: Intensivity.four,
                      label: Text(
                        '4',
                        textScaler: const TextScaler.linear(1.0),
                      ),
                    ),
                  ],
                  selected: <Intensivity>{widget.intensity},
                  onSelectionChanged: (Set<Intensivity> newSelection) {
                    setState(() {
                      widget.intensity = newSelection.first;
                    });
                    widget.onIntensityChanged(widget.intensity);
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _isFmExpanded = !widget.isFm;
  }

  void _getStandardFrequency(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return StandardFrequencyDialog(
          freqency: 15,
          onChanged: _onSetStdFrequency,
        );
      },
    );
  }

  void _onSetStdFrequency(int frequency) {
    setState(() {
      widget.freq = frequency.toDouble();
    });
  }
}

enum ParamsColorsStyle { pcsYellow, pcsOrdinal }
