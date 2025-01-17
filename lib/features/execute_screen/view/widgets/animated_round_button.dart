import 'package:flutter/material.dart';

import '../../../../assets/colors/colors.dart';
import '../../../direct_control_screen/widgets/power_horizontal_widget.dart';

class AnimatedRoundButton extends StatefulWidget{
  const AnimatedRoundButton({
    super.key,
//    required this.constraints,
    required this.icon,
    required this.onPressed,
    required this.size,
  });

//  final BoxConstraints constraints;
  final TypeChangePowerButton icon;
  final Function onPressed;
  final double size;

  @override
  State<AnimatedRoundButton> createState() => _AnimatedRoundButton();
}

class _AnimatedRoundButton extends State<AnimatedRoundButton>
    with SingleTickerProviderStateMixin{
  late final _animationController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 50),
  );

  late final _animationPressSize = CurvedAnimation(
    parent: _animationController,
    curve: Curves.linear,
  );
  final Tween<double> _sizePressTween = Tween(begin: 1, end: 0.9);

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _sizePressTween.animate(_animationPressSize),
      child: GestureDetector(
        onTap: () async {
          await _animationController.forward();
          await _animationController.reverse();
          widget.onPressed(widget.icon);
        },
        child: Container(
          width: widget.size, // widget.constraints.maxHeight / 2 - 10, //130,
          height: widget.size, //widget.constraints.maxHeight / 2 - 10, //130, //double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(300),
            color: white,
          ),
          child: Center(
            child: Icon(
              size: 40,
              widget.icon == TypeChangePowerButton.plus ? Icons.add : Icons.remove,
              color: black,
            ),
          ),
        ),
      ),
    );
   }

  @override
  void initState() {
    super.initState();
    _animationController.stop();
  }
}