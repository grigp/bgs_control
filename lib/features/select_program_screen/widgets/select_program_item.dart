import 'package:bgs_control/repositories/methodic_programs/model/methodic_program.dart';
import 'package:flutter/material.dart';

class SelectProgramItem extends StatefulWidget {
  const SelectProgramItem({
    super.key,
    required this.program,
    required this.isLast,
    required this.onTap,
  });

  final MethodicProgram program;
  final bool isLast;
  final VoidCallback? onTap;

  @override
  State<SelectProgramItem> createState() => _SelectProgramItemState();
}

class _SelectProgramItemState extends State<SelectProgramItem> {
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
      color: Colors.transparent,
      padding: const EdgeInsets.only(
        left: 6,
        right: 6,
        top: 12,
      ),
      child: Column(
        children: [
          Row(
            children: [
              Image.asset(
                'lib/assets/icons/programs/${widget.program.image}',
                width: 36,
                height: 36,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.program.title,
                      style: theme.textTheme.bodyLarge,
                      overflow: TextOverflow.fade, //ellipsis,
                      textScaler: const TextScaler.linear(1.0),
                    ),
                    // Показывает описание методики. Закрыто потому, что так решили все, но я не согласен
                    // Text(
                    //   widget.program.description,
                    //   style: theme.textTheme.labelSmall,
                    //   overflow: TextOverflow.fade, //.ellipsis,
                    //   textScaler: const TextScaler.linear(1.0),
                    //   maxLines: 4,
                    // ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (!widget.isLast)
            const Padding(
              padding: EdgeInsets.only(left: 58),
              child: Divider(
                height: 0,
                indent: 0,
                thickness: 1,
              ),
            ),
        ],
      ),
    );
  }
}
