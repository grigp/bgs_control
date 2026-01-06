import 'package:bgs_control/assets/colors/colors.dart';
import 'package:flutter/material.dart';

import '../../../utils/Constants.dart';
import '../../execute_screen/view/widgets/animated_round_button.dart';
import '../../uikit/texel_button.dart';
import '../../uikit/widgets/safe_level_dialog.dart';

//ignore: must_be_immutable
class PowerHorizontalWidget extends StatefulWidget {
  PowerHorizontalWidget({
    super.key,
    required this.powerSet,
    required this.powerReal,
    required this.onPowerSet,
    required this.onPowerReset,
  });

  double powerSet;
  double powerReal;
  final Function onPowerSet;
  final Function onPowerReset;

  @override
  State<PowerHorizontalWidget> createState() => _PowerHorizontalWidgetState();
}

class _PowerHorizontalWidgetState extends State<PowerHorizontalWidget> {
  double _sliderValueStart = 0;
  double _powerSet = 0;   /// Установленная мощность с учетом процесса регулирования
  /// В процессе сдвига регулятора мощности true, если он не двигается, false
  bool _isChangePowerSet = false;

  @override
  Widget build(BuildContext context) {
    ///Если не в процессе сдвига регулятора мощности, то устанавливаем мощность, переданную из родителя
    if(!_isChangePowerSet){
      _powerSet = widget.powerSet;
    }
    final theme = Theme.of(context);
    return Column(
      children: [
        Row(
          /// Регулятор мощности
          children: [
            Text(
              '${widget.powerReal.toInt()}',
              style: theme.textTheme.bodyLarge,
              textScaler: const TextScaler.linear(1.0),
            ),
            Expanded(
              child: SizedBox(
                width: double.infinity,
                child: Stack(
                  children: [
                    /// Нижний показывает установленный целевой уровень
                    /// Показывает бегунок и серый уровень
                    SliderTheme(
                      data: const SliderThemeData(
                        showValueIndicator: ShowValueIndicator.always,
                      ),
                      child: Slider(
                        value: _powerSet,
                        label: _powerSet.round().toString(),
                        min: 0,
                        max: 125,
                        activeColor: backgroundMiddleTestColor,
                        thumbColor: black,
                        inactiveColor: backgroundCarpetButtonTestColor,
                        divisions: 125,
                        onChanged: (double value) {},
                      ),
                    ),
                    /// Верхний показывает установленный уровень на приборе
                    /// Показывает черный уровень
                    SliderTheme(
                      data: SliderThemeData(
                        showValueIndicator: ShowValueIndicator.always,
                        thumbShape: SliderComponentShape.noThumb,
                      ),
                      child: Slider(
                        value: widget.powerReal,
                        min: 0,
                        max: 125,
                        activeColor: black,
                        thumbColor: black,
                        overlayColor: WidgetStateProperty<Color>.fromMap(<WidgetStatesConstraint, Color>{
                          WidgetState.focused: const Color(0x00000000),
                          WidgetState.pressed | WidgetState.hovered: const Color(0x00000000),
                          WidgetState.any: const Color(0x00000000),
                        }),
                        inactiveColor: const Color(0x00000000),
                        divisions: 125,
                        onChanged: _onSliderValueChanged,
                        onChangeStart: _onSliderValueChangeStart,
                        onChangeEnd: _onSliderValueChangeEnd,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        Row(
          children: [
            const Spacer(),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: backgroundCarpetButtonTestColor,
                borderRadius: BorderRadius.circular(70),
              ),
              child: LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AnimatedRoundButton(
                      icon: TypeChangePowerButton.minus,
                      onPressed: _onPowerSet,
                      size: 80,
                    ),
                    const SizedBox(width: 15),
                    SizedBox(
                      width: 70,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _powerSet.round().toString(),
                            style: theme.textTheme.displaySmall,
                            textScaler: const TextScaler.linear(1.0),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 15),
                    AnimatedRoundButton(
                      icon: TypeChangePowerButton.plus,
                      onPressed: _onPowerSet,
                      size: 80,
                    ),
                  ],
                );
              }),
            ),
            const Spacer(),
          ],
        ),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
  }

  void _onPowerSet(TypeChangePowerButton icon) async {
    bool? isEnable = true;

    /// Если мощность в процессе изменения значения слайдера превысила powerSafeLevel,
    /// то выдаем запрос на подтверждение увеличения мощности
    if (icon == TypeChangePowerButton.plus &&
        _powerSet == Constants.powerSafeLevel) {
      isEnable = await safeLevelDialog(context);
    }

    /// Если разрешили, то увеличиваем мощность
    if (isEnable!) {
      setState(
        () {
          if (icon == TypeChangePowerButton.plus) {
            if (_powerSet < 125) {
              ++_powerSet;
            }
          } else {
            if (_powerSet > 0) {
              --_powerSet;
            }
          }
          widget.onPowerSet(_powerSet);
          _sliderValueStart = _powerSet;
        },
      );
    }
  }

  void _onSliderValueChangeStart(double value) {
    _isChangePowerSet = true;
  }

  void _onSliderValueChanged(double value) {
    setState(() {
      _powerSet = value;
    });
  }

  void _onSliderValueChangeEnd(double value) async {
    bool? isEnable = true;

    /// Если мощность в процессе изменения значения слайдера превысила powerLevel,
    /// то выдаем запрос на подтверждение увеличения мощности
    if (_powerSet > Constants.powerSafeLevel &&
        _sliderValueStart <= Constants.powerSafeLevel) {
      isEnable = await safeLevelDialog(context);
    }

    /// Если разрешили, то увеличиваем мощность
    if (isEnable!) {
      // setState(() {
      //   widget.powerSet = value;
      // });

      /// В этот момент мы будем устанавливать мощность
      widget.onPowerSet(value);
      _sliderValueStart = value;
    } else {
      /// А, если не разрешили, то оставляем, как было
      setState(() {
        widget.powerSet = _sliderValueStart;
      });
    }
    _isChangePowerSet = false;
  }
}

enum TypeChangePowerButton { plus, minus }
