import 'package:bgs_control/assets/colors/colors.dart';
import 'package:flutter/material.dart';

/// Универсальная кнопка для Texel App
class TexelButton extends StatelessWidget {
  /// Конструктор accentColor.
  const TexelButton.transparent({
    super.key,
    required this.onPressed,
    required this.text,
    this.width,
    this.height,
    this.icon,
  })  : _colorBackground = transparentButton,
        _colorText = filledAccentButtonColor;

  /// Конструктор black.
  const TexelButton.black({
    super.key,
    required this.onPressed,
    required this.text,
    this.width,
    this.height,
    this.icon,
  })  : _colorBackground = filledBlackButtonColor,
        _colorText = white;

  /// Конструктор accentColor.
  const TexelButton.secondary({
    super.key,
    required this.onPressed,
    required this.text,
    this.width,
    this.height,
    this.icon,
  })  : _colorBackground = filledSecondaryButtonColor,
        _colorText = filledAccentButtonColor;

  /// Конструктор accent.
  const TexelButton.accent({
    super.key,
    required this.onPressed,
    required this.text,
    this.width,
    this.height,
    this.icon,
  })  : _colorBackground = filledAccentButtonColor,
        _colorText = white;

  /// Конструктор по умолчанию
  const TexelButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.width,
    this.height,
    this.icon,
  })  : _colorBackground = filledAccentButtonColor,
        _colorText = white;

  /// Калбек по нажатию
  final VoidCallback? onPressed;

  /// Текст кнопки
  final String text;

  /// Цвет кнопки
  final Color _colorBackground;

  /// Цвет текста
  final Color _colorText;

  /// Ширина
  final double? width;

  /// Высота
  final double? height;

  /// Иконка слева
  final Icon? icon;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      height: height ?? 50,
      child: FilledButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: _colorBackground,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) icon!,
            Text(
              text,
              style: TextStyle(color: _colorText, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
