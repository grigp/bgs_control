import 'package:flutter/material.dart';

import '../../../assets/colors/colors.dart';

class BackScreenButton extends StatelessWidget{
  const BackScreenButton({
    super.key,
    required this.onBack,
    required this.hasBackground,
  });

  final Function onBack;
  final bool hasBackground;

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
          color: hasBackground ? white : null,
        ),
        child: const Center(
          child: Icon(
            Icons.arrow_back,
            color: secondaryTextColor,
          ),
        ),
      ),
    );
  }

}