import 'package:bgs_control/repositories/methodic_programs/model/methodic_program.dart';
import 'package:bgs_control/repositories/methodic_programs/model/select_item_info.dart';
import 'package:flutter/material.dart';

class SelectProgramItem extends StatefulWidget {
  const SelectProgramItem({
    super.key,
    required this.itemInfo,
    required this.isLast,
    required this.onTap,
  });

  final SelectItemInfo itemInfo;
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
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      widget.itemInfo.title,
                      style: widget.itemInfo.nodeType ==
                              SelectItemNodeType.simtTitle
                          ? theme.textTheme.bodyLarge
                          : theme.textTheme.titleLarge,
                      overflow: TextOverflow.fade, //ellipsis,
                      textScaler: const TextScaler.linear(1.0),
                    ),
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
