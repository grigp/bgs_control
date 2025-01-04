import 'package:flutter/material.dart';

import '../../../../assets/colors/colors.dart';

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
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _getChangePowerButton(TypeChangePowerButton.plus),
          const SizedBox(height: 8),
          // Text(
          //   widget.powerReal.round().toString(),
          //   style: theme.textTheme.displaySmall,
          //   textScaler: const TextScaler.linear(1.0),
          // ),
          const SizedBox(height: 8),
          _getChangePowerButton(TypeChangePowerButton.minus),
        ],
      ),
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
        width: 130,
        height: 130, //double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(300),
          color: white,
        ),
        child: Center(
          child: Icon(
            size: 40,
            icon == TypeChangePowerButton.plus ? Icons.add : Icons.remove,
            color: black,
          ),
        ),
      ),
    );
  }
}

enum TypeChangePowerButton { plus, minus }
