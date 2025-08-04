import 'dart:async';
import 'dart:developer';

import 'package:bgs_control/features/direct_control_screen/widgets/horizontal_wheel_picker.dart';
import 'package:bgs_control/features/direct_control_screen/widgets/standard_frequency_dialog.dart';
import 'package:bgs_control/repositories/bgs_connect/bgs_connect.dart';
import 'package:flutter/material.dart';
import 'package:wheel_picker/wheel_picker.dart';

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
    required this.intensivity,
    required this.onIntensivityChanged,
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
  Intensivity intensivity;
  final Function onIntensivityChanged;

  final ParamsColorsStyle colorsStyle;

  @override
  State<ParamsWidget> createState() => _ParamsWidgetState();
}

class _ParamsWidgetState extends State<ParamsWidget> {
  bool _isFmExpanded = false;
  final _frequencyWheel = WheelPickerController(itemCount: 400); //350);
  final TextStyle _freqWheelTextStyle =
      const TextStyle(fontSize: 24.0, height: 1.5);

  /// Переменные для управления сменой частоты
  bool _isFreqChanged = false;

  /// Пикер крутим
  int _freqChangeTimer = 0;

  /// Время от установки последнего значения
  int _lastFreqSet = 15;
  int _lastFreqSetH = 1;

  /// Последнее установленное значение частоты
  late Timer _timer;

  @override
  Widget build(BuildContext context) {
    if (!_isFreqChanged) {
      _frequencyWheel.shiftTo(widget.freq.toInt() - 1);
    }

    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
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
          const Divider(height: 2),
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
          const Divider(height: 2),
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
            height: !widget.isFm ? 50 : 0,
            child: !widget.isFm && _isFmExpanded
                ? Row(
                    children: [
                      Text(
                        'Частота, Гц',
                        style: theme.textTheme.labelMedium,
                        textScaler: const TextScaler.linear(1.0),
                      ),
                      const SizedBox(width: 20),
                      SizedBox(
                        width: 180,
                        child: HorizontalWheelPicker(
                          min: 1,
                          max: 400,
                          value: _lastFreqSetH.toDouble(),
                          onChange: (double value) {
                            _lastFreqSetH = value.round();
                            print('');
                            print('*************************************************************');
                            print('  FREQUENCY = $_lastFreqSetH Гц');
                            print('*************************************************************');
                            print('');
                          },
                        ),
                      ),
                      const Spacer(),
                      ElevatedButton(
                        onPressed: () {
                          _getStandardFrequency(context);
                        },
                        style: const ButtonStyle(
                          backgroundColor: WidgetStatePropertyAll<Color>(
                            Color(0xffeaeaea),
                          ),
                        ),
                        child: const Icon(
                          Icons.open_in_browser,
                          color: black,
                          size: 20,
                        ),
                      )
                    ],
                  )
                : const Text(''),
          ),

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
                ? Row(
                    children: [
                      Text(
                        'Частота, Гц',
                        style: theme.textTheme.labelMedium,
                        textScaler: const TextScaler.linear(1.0),
                      ),
                      const SizedBox(width: 20),
                      SizedBox(
                        width: 100,
                        child: Container(
                          padding: const EdgeInsets.all(3.0),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: const Color(0xffcacaca),
                            ),
                            gradient: const LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: <Color>[
                                Color(0xffefefef),
                                Color(0xffffffff),
                                Color(0xffefefef),
                              ],
                            ),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(2)),
                          ),
                          child: WheelPicker(
                            builder: (BuildContext context, int index) =>
                                SizedBox(
                              width: 70,
                              child: Text(
                                "${index + 1}",
                                style: _freqWheelTextStyle,
                              ),
                            ),
                            controller: _frequencyWheel,
                            //                     scrollDirection: Axis.horizontal,
                            looping: false,
                            onIndexChanged: (int index,
                                WheelPickerInteractionType interactionType) {
                              _isFreqChanged = true;
                              _freqChangeTimer = 0;
                              _lastFreqSet = index + 1;
                            },

                            style: const WheelPickerStyle(
                              itemExtent: 50,
                              squeeze: 1.25,
                              diameterRatio: 100.8,
                              surroundingOpacity: 0.25,
                              magnification: 1.2,
                            ),
                          ),
                        ),
                      ),
                      const Spacer(),
                      ElevatedButton(
                        onPressed: () {
                          _getStandardFrequency(context);
                        },
                        style: const ButtonStyle(
                          backgroundColor: WidgetStatePropertyAll<Color>(
                            Color(0xffeaeaea),
                          ),
                        ),
                        child: const Icon(
                          Icons.open_in_browser,
                          color: black,
                          size: 20,
                        ),
                      )
                    ],
                  )
                : const Text(''),

            // TODO: Старый вариант управления частотой с помощью слайдера. Когда утрясется, решить с закомментированным
            // child: !widget.isFm && _isFmExpanded
            //     ? Column(
            //         crossAxisAlignment: CrossAxisAlignment.start,
            //         children: [
            //           GestureDetector(
            //             child: Row(
            //               mainAxisSize: MainAxisSize.min,
            //               mainAxisAlignment: MainAxisAlignment.center,
            //               children: [
            //                 Text(
            //                   'Частота: ${widget.freq.toInt()} Гц',
            //                   style: theme.textTheme.labelMedium,
            //                   textScaler: const TextScaler.linear(1.0),
            //                 ),
            //                 const SizedBox(width: 20),
            //                 const Icon(
            //                   Icons.open_in_browser,
            //                   size: 25,
            //                 ),
            //               ],
            //             ),
            //             onTap: () {
            //               _getStandardFrequency(context);
            //             },
            //           ),
            //           Slider.adaptive(
            //             value: widget.freq,
            //             label: widget.freq.round().toString(),
            //             min: 1,
            //             max: 350,
            //             //divisions: 6,
            //             activeColor:
            //                 widget.colorsStyle == ParamsColorsStyle.pcsYellow
            //                     ? backgroundDarknessTestColor
            //                     : filledAccentButtonColor,
            //             thumbColor:
            //                 widget.colorsStyle == ParamsColorsStyle.pcsYellow
            //                     ? backgroundDarknessTestColor
            //                     : filledAccentButtonColor,
            //             inactiveColor:
            //                 widget.colorsStyle == ParamsColorsStyle.pcsYellow
            //                     ? backgroundCarpetButtonTestColor
            //                     : filledSecondaryButtonColor,
            //             onChanged: (double value) {
            //               setState(() {
            //                 widget.freq = value;
            //               });
            //             },
            //             onChangeEnd: (double value) {
            //               /// В этот момент мы будем устанавливать частоту
            //               widget.onFreqChanged(widget.freq);
            //             },
            //           ),
            //           const Divider(),
            //         ],
            //       )
            //     : const Text(''),
          ),
          const SizedBox(height: 10),
          const Divider(height: 2),
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
                        textScaler: TextScaler.linear(1.0),
                      ),
                    ),
                    ButtonSegment<Intensivity>(
                      value: Intensivity.two,
                      label: Text(
                        '2',
                        textScaler: TextScaler.linear(1.0),
                      ),
                    ),
                    ButtonSegment<Intensivity>(
                      value: Intensivity.three,
                      label: Text(
                        '3',
                        textScaler: TextScaler.linear(1.0),
                      ),
                    ),
                    ButtonSegment<Intensivity>(
                      value: Intensivity.four,
                      label: Text(
                        '4',
                        textScaler: TextScaler.linear(1.0),
                      ),
                    ),
                  ],
                  selected: <Intensivity>{widget.intensivity},
                  onSelectionChanged: (Set<Intensivity> newSelection) {
                    setState(() {
                      widget.intensivity = newSelection.first;
                    });
                    widget.onIntensivityChanged(widget.intensivity);

                    /// Коррекция частоты в зависимости от интенсивности
                    if (widget.intensivity == Intensivity.three &&
                        widget.freq > 330) {
                      setState(() {
                        widget.freq = 330;
                      });
                      widget.onFreqChanged(widget.freq);
                    }
                    if (widget.intensivity == Intensivity.four &&
                        widget.freq > 250) {
                      setState(() {
                        widget.freq = 250;
                      });
                      widget.onFreqChanged(widget.freq);
                    }
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

    _timer = Timer.periodic(const Duration(seconds: 1), _onTimer);
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  /// Обработчик таймера, служащего для изменения частоты
  void _onTimer(Timer timer) async {
    if (_isFreqChanged) {
      ++_freqChangeTimer;
      if (_freqChangeTimer >= 2) {
        _isFreqChanged = false;
        _freqChangeTimer = 0;
        widget.freq = _lastFreqSet.toDouble();
        widget.onFreqChanged(widget.freq);

        /// Коррекция интенсивности в зависимости от частоты
        if (widget.intensivity == Intensivity.four && widget.freq > 250) {
          setState(() {
            widget.intensivity = Intensivity.three;
          });
          widget.onIntensivityChanged(widget.intensivity);
        }
        if (widget.intensivity == Intensivity.three && widget.freq > 330) {
          setState(() {
            widget.intensivity = Intensivity.two;
          });
          widget.onIntensivityChanged(widget.intensivity);
        }
      }
    }
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
      widget.onFreqChanged(widget.freq);
      _frequencyWheel.shiftTo(frequency - 1);
    });
  }
}

enum ParamsColorsStyle { pcsYellow, pcsOrdinal }
