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
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Индивидуальный режим',
                  style: theme.textTheme.titleMedium,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  'Режим работы стимулятора с индивидуальными настройками',
                  style: theme.textTheme.labelSmall,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 4,
                ),
              ],
            ),
          ),
        ],
      ),
    );
      
      
      
      Row(
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
                    'Индивидуальный режим',
                    style: theme.textTheme.titleMedium,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(
                    width: 300, //double.infinity, TODO: Почему не работает ???????????????
                    height: 50,
                    child: Text(
                      'Режим работы стимулятора с индивидуальными настройками',
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
