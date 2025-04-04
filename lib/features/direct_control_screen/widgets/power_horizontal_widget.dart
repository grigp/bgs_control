import 'package:bgs_control/assets/colors/colors.dart';
import 'package:flutter/material.dart';

import '../../../utils/base_defines.dart';
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Row(
          /// Регулятор мощности
          children: [
            Text(
              '${widget.powerSet.toInt()}',
              style: theme.textTheme.bodyLarge,
              textScaler: const TextScaler.linear(1.0),
            ),
            Expanded(
              child: SizedBox(
                width: double.infinity,
                child: SliderTheme(
                  data: const SliderThemeData(
                    showValueIndicator: ShowValueIndicator.always,
                  ),
                  child: Slider(
                    value: widget.powerSet,
                    label: widget.powerSet.round().toString(),
                    min: 0,
                    max: 125,
                    activeColor: backgroundDarknessTestColor,
                    thumbColor: backgroundDarknessTestColor,
                    inactiveColor: backgroundCarpetButtonTestColor,
                    divisions: 125,
                    onChangeStart: _onSliderValueChangeStart,
                    onChanged: _onSliderValueChanged,
                    onChangeEnd: _onSliderValueChangeEnd,
                  ),
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
                      width:70,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            widget.powerReal.round().toString(),
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
        widget.powerSet == powerSafeLevel) {
      isEnable = await safeLevelDialog(context);
    }

    /// Если разрешили, то увеличиваем мощность
    if (isEnable!) {
      setState(
        () {
          if (icon == TypeChangePowerButton.plus) {
            if (widget.powerSet < 125) {
              ++widget.powerSet;
            }
          } else {
            if (widget.powerSet > 0) {
              --widget.powerSet;
            }
          }
          widget.onPowerSet(widget.powerSet);
        },
      );
    }
  }

  void _onSliderValueChangeStart(double value) {
    _sliderValueStart = value;
  }

  void _onSliderValueChanged(double value) {
    setState(() {
      widget.powerSet = value;
    });
  }

  void _onSliderValueChangeEnd(double value) async {
    bool? isEnable = true;

    /// Если мощность в процессе изменения значения слайдера превысила powerSafeLevel,
    /// то выдаем запрос на подтверждение увеличения мощности
    if (widget.powerSet > powerSafeLevel && _sliderValueStart <= powerSafeLevel){
      isEnable = await safeLevelDialog(context);
    }

    /// Если разрешили, то увеличиваем мощность
    if (isEnable!) {
      widget.powerSet = value;
      /// В этот момент мы будем устанавливать мощность
      widget.onPowerSet(widget.powerSet);
    } else {
      /// А, если не разрешили, то оставляем, как было
      setState(() {
        widget.powerSet = _sliderValueStart;
      });
    }
  }


}


enum TypeChangePowerButton { plus, minus }
