import 'package:flutter/material.dart';

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
    return GestureDetector(
      onTap: () {
        onClick.call();
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: SizedBox(
          width: 36,
          height: 36,
          child: Image.asset(
            type == TypePlayPauseButton.play
                ? 'images/play.png'
                : 'images/pause.png',
          ),
        ),
      ),
    );
  }
}

enum TypePlayPauseButton { play, pause }
