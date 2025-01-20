import 'package:bgs_control/features/uikit/texel_button.dart';
import 'package:flutter/material.dart';

import '../../../assets/colors/colors.dart';

class PlayPauseButton extends StatelessWidget {
  const PlayPauseButton({
    super.key,
    required this.type,
    required this.onClick,
  });

  final TypePlayPauseButton type;
  final Function onClick;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: transparentButton,
      width: double.infinity,
      height: 60,
      padding: const EdgeInsets.all(10),
      child: FilledButton(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all<Color>(transparentButton),
        ),
          onPressed: () {
            onClick.call();
          },
          child: Image.asset(
            type == TypePlayPauseButton.play
                ? 'images/play.png'
                : 'images/pause.png',
          ),
      ),
    );
  }

}

enum TypePlayPauseButton { play, pause }
