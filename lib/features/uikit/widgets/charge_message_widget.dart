import 'package:flutter/material.dart';

import '../../../assets/colors/colors.dart';
import '../../../generated/l10n.dart';

class ChargeMessageWidget extends StatefulWidget {
  const ChargeMessageWidget({super.key});

  @override
  State<ChargeMessageWidget> createState() => _ChargeMessageWidgetState();
}

class _ChargeMessageWidgetState extends State<ChargeMessageWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.error,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Center(
        child: Text(
          S.of(context).TheStimulatorNeedsToBeCharged,
          style: const TextStyle(
            color: backgroundCarpetButtonTestColor,
            fontSize: 16,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
    );
  }
}
