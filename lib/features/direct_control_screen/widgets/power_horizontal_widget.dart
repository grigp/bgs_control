import 'package:bgs_control/assets/colors/colors.dart';
import 'package:flutter/material.dart';

import '../../execute_screen/view/widgets/animated_round_button.dart';
import '../../uikit/texel_button.dart';

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
                      activeColor: black,
                      thumbColor: black,
                      inactiveColor: backgroundCarpetButtonTestColor,
                      divisions: 125,
                      onChanged: (double value) {
                        setState(() {
                          widget.powerSet = value;
                        });
                      },
                      onChangeEnd: (double value) {
                        /// В этот момент мы будем устанавливать мощность
                        widget.onPowerSet(widget.powerSet);
                      },
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
              padding: const EdgeInsets.all(15),
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
                    Text(
                      widget.powerReal.round().toString(),
                      style: theme.textTheme.displayMedium,
                      textScaler: const TextScaler.linear(1.0),
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
        const SizedBox(height: 20),
        Center(
          child: TexelButton.black(
            text: 'Сброс',
            onPressed: () {
              widget.powerSet = 0;
              widget.onPowerReset();
            },
          ),
        ),
      ],
    );
  }

  void _onPowerSet(TypeChangePowerButton icon) {
    setState(() {
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
    });
  }
}

enum TypeChangePowerButton { plus, minus }
