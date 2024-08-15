import 'package:flutter/material.dart';

/// Кнопка переключения экранов методик и устройств.
class MenuIconButton extends StatelessWidget {
  const MenuIconButton({
    super.key,
    required this.type,
  });

  /// Тип кнопки.
  final MenuIconType type;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(50),
      child: Image.asset(
        type == MenuIconType.device ?
        'lib/assets/icons/device_menu.png' : 'lib/assets/icons/methods_menu.png',
        width: 50,
        height: 50,
      ),
    );
  }
}

enum MenuIconType { device, methods }
