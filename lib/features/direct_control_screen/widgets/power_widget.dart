import 'package:bgs_control/assets/colors/colors.dart';
import 'package:bgs_control/features/uikit/texel_button.dart';
import 'package:flutter/material.dart';

//ignore: must_be_immutable
class PowerWidget extends StatefulWidget {
  PowerWidget({
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
  State<PowerWidget> createState() => _PowerWidgetState();
}

class _PowerWidgetState extends State<PowerWidget> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Column(
          /// Регулятор мощности
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Мощность ${widget.powerSet.toInt()}',
              style: theme.textTheme.headlineMedium,
            ),
            Slider.adaptive(
              value: widget.powerSet,
              label: widget.powerSet.round().toString(),
              min: 0,
              max: 125,
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
          ],
        ),
        Row(
          children: [
            const Spacer(),
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: backgroundCarpetButtonToGoColor,
                borderRadius: BorderRadius.circular(70),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _getChangePowerButton(TypeChangePowerButton.minus),
                  const SizedBox(width: 15),
                  Text(
                    widget.powerReal.round().toString(),
                    style: theme.textTheme.displayMedium,
                  ),
                  const SizedBox(width: 15),
                  _getChangePowerButton(TypeChangePowerButton.plus),
                ],
              ),
            ),
            const Spacer(),
          ],
        ),
        const SizedBox(height: 10),
        Center(
          child: TexelButton.accent(
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

  Widget _getChangePowerButton(TypeChangePowerButton icon) {
    return GestureDetector(
      onTap: () {
        setState(() {
          icon == TypeChangePowerButton.plus
              ? ++widget.powerSet
              : --widget.powerSet;
          widget.onPowerSet(widget.powerSet);
        });
      },
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: white,
        ),
        child: Center(
          child: Icon(
            icon == TypeChangePowerButton.plus ? Icons.add : Icons.remove,
            color: secondaryTextColor,
          ),
        ),
      ),
    );
  }
}

enum TypeChangePowerButton { plus, minus }
