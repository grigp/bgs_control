import 'package:flutter/material.dart';

import '../../../assets/colors/colors.dart';

class DirectTitle extends StatefulWidget {
  const DirectTitle({
    super.key,
    required this.onTap,
  });

  final VoidCallback? onTap;

  @override
  State<DirectTitle> createState() => _DirectTitleState();
}

class _DirectTitleState extends State<DirectTitle> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: () {
        widget.onTap?.call();
      },
      child: _buildTitle(context, theme),
    );
  }

  Widget _buildTitle(BuildContext context, ThemeData theme) {
    return Container(
      height: 90,
      decoration: BoxDecoration(
        color: filledSecondaryItemColor,
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.only(
        left: 10,
        top: 10,
        right: 10,
        bottom: 10,
      ),
      child: Row(
        children: [
          Image.asset('lib/assets/icons/programs/togo.png'),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Прямое управление',
                  style: theme.textTheme.titleMedium,
                  overflow: TextOverflow.ellipsis,
                  textScaler: const TextScaler.linear(1.0),
                ),
                Text(
                  'Прямое управление работой стимулятора в реальном времени',
                  style: theme.textTheme.labelSmall,
                  overflow: TextOverflow.ellipsis,
                  textScaler: const TextScaler.linear(1.0),
                  maxLines: 4,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
