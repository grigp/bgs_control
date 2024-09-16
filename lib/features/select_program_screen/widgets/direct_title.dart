import 'package:flutter/material.dart';

import '../../../assets/colors/colors.dart';

class DirectTitle extends StatefulWidget{
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
    return Row(
      children: [
        const SizedBox(width: 10),
        GestureDetector(
          onTap: () {
            widget.onTap?.call();
          },
          child: _buildTitle(context, theme),
        ),
      ],
    );
  }

  Widget _buildTitle(BuildContext context, ThemeData theme) {
    return Row(
      children: [
        Container(
          height: 90,
          margin: const EdgeInsets.only(
            left: 0,
            top: 10,
            right: 10,
            bottom: 10,
          ),
          decoration: BoxDecoration(
            color: filledSecondaryItemColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Image.asset('lib/assets/icons/programs/togo.png'),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Прямое управление',
                    style: theme.textTheme.titleMedium,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(
                    width: 300, //double.infinity,
                    height: 50,
                    child: Text(
                      'Прямое управление работой стимулятора в реальном времени',
                      style: theme.textTheme.labelSmall,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 4,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
