import 'package:flutter/material.dart';

import '../../../assets/colors/colors.dart';

class ChargeMessageWidget extends StatefulWidget {
  const ChargeMessageWidget({super.key});

  @override
  State<ChargeMessageWidget> createState() => _ChargeMessageWidgetState();
}

class _ChargeMessageWidgetState extends State<ChargeMessageWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.error,
        borderRadius: BorderRadius.circular(5),
      ),
      child: const Center(
        child: Text(
          'Необходимо зарядить стимулятор',
          style: TextStyle(
            color: backgroundCarpetButtonTestColor,
            fontSize: 16,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
    );
  }

}
