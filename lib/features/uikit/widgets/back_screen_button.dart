import 'package:flutter/material.dart';

import '../../../assets/colors/colors.dart';

class BackScreenButton extends StatelessWidget {
  const BackScreenButton({
    super.key,
    required this.onBack,
    required this.hasBackground,
    this.isClose = false,
  });

  final Function onBack;
  final bool hasBackground;
  final bool? isClose;

  @override
  Widget build(BuildContext context) {
    var closeMode = false;
    if (isClose == null || isClose!) {
      closeMode = true;
    } else {
      closeMode = false;
    }

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
        child: Center(
          child: Icon(
            closeMode ? Icons.close : Icons.arrow_back,
            color: secondaryTextColor,
          ),
        ),
      ),
    );
  }
}
