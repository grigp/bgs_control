import 'package:bgs_control/features/execute_screen/view/widgets/animated_round_button.dart';
import 'package:flutter/material.dart';

import '../../../../assets/colors/colors.dart';
import '../../../direct_control_screen/widgets/power_horizontal_widget.dart';

class PowerVerticalWidget extends StatefulWidget {
  PowerVerticalWidget({
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
  State<PowerVerticalWidget> createState() => _PowerVerticalWidgetState();
}

class _PowerVerticalWidgetState extends State<PowerVerticalWidget> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: backgroundCarpetButtonTestColor,
        borderRadius: BorderRadius.circular(300),
      ),
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints){
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedRoundButton(
                  constraints: constraints,
                  icon: TypeChangePowerButton.plus,
                  onPressed: _onPowerSet,
              ),
              const SizedBox(height: 16),
              AnimatedRoundButton(
                constraints: constraints,
                icon: TypeChangePowerButton.minus,
                onPressed: _onPowerSet,
              ),
            ],
          );
        }
      ),
    );
  }

  void _onPowerSet(TypeChangePowerButton icon) {
    setState(() {
      if (icon == TypeChangePowerButton.plus) {
        if (widget.powerSet < 125){
          ++widget.powerSet;
        }
      } else {
        if (widget.powerSet > 0){
          --widget.powerSet;
        }
      }
      widget.onPowerSet(widget.powerSet);
    });
  }
}

