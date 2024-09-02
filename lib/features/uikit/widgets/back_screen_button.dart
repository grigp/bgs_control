import 'package:flutter/material.dart';

import '../../../assets/colors/colors.dart';

class BackScreenButton extends StatelessWidget{
  const BackScreenButton({super.key});


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
      },
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: white,
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