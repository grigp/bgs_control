import 'package:flutter/material.dart';

import '../../../assets/colors/colors.dart';
import '../../../repositories/methodic_programs/model/methodic_program.dart';

class EditStageTitle extends StatefulWidget {
  const EditStageTitle({
    super.key,
    required this.stage,
    required this.onTap,
    required this.onDelete,
    required this.isSelected,
  });

  final ProgramStage stage;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  final bool isSelected;

  @override
  State<EditStageTitle> createState() => _EditStageTitleState();
}

class _EditStageTitleState extends State<EditStageTitle> {

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
      padding: const EdgeInsets.only(
        left: 6,
        right: 6,
        top: 6,
        bottom: 6,
      ),
      decoration: BoxDecoration(
        color: (widget.isSelected)
            ? backgroundDarkTestColor
            : filledSecondaryButtonColor,
        borderRadius: BorderRadius.circular(20), // Радиус скругления
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              widget.stage.comment,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 20,
              ),
              overflow: TextOverflow.fade,
              textScaler: const TextScaler.linear(1.0),
            ),
          ),
          GestureDetector(
              onTap: () {
                widget.onDelete?.call();
              },
              child: const SizedBox(
                width: 20,
                child: Icon(Icons.close),
              )
          ),
          const SizedBox(width: 10),
        ],
      ),
    );
  }
}
