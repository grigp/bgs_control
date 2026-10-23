import 'package:flutter/material.dart';

import '../../../assets/colors/colors.dart';

class CircularButton extends StatelessWidget {
  const CircularButton({
    super.key,
    required this.onBack,
    required this.hasBackground,
    required this.icon,
    required this.backgroundColor,
  });

  final Function onBack;
  final bool hasBackground;
  final IconData icon;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onBack();
      },
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: hasBackground ? backgroundColor : null,
        ),
        child: Center(
          child: Icon(
            icon,
            color: secondaryTextColor,
          ),
        ),
      ),
    );
  }
}
