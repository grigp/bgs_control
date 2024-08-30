import 'package:flutter/material.dart';

import '../../../assets/colors/colors.dart';

class TogoTitle extends StatefulWidget{
  const TogoTitle({
    super.key,
    required this.onTap,
  });

  final VoidCallback? onTap;

  @override
  State<TogoTitle> createState() => _TogoTitleState();
}

class _TogoTitleState extends State<TogoTitle> {
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
          height: 80,
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
              Image.asset('images/togo.png'),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Свободный режим',
                    style: theme.textTheme.titleMedium,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(
                    width: 300, //double.infinity,
                    height: 50,
                    child: Text(
                      'Автономный режим работы стимулятора',
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
