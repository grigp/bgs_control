import 'package:flutter/material.dart';

import '../../../repositories/methodic_programs/model/methodic_program.dart';
import '../../../utils/baseutils.dart';

class StageTitle extends StatefulWidget {
  const StageTitle({
    super.key,
    required this.num,
    required this.stage,
    required this.duration,
    required this.textColor,
  });

  final int num;
  final ProgramStage stage;
  final int duration;
  final Color textColor;

  @override
  State<StageTitle> createState() => _StageTitleState();
}

class _StageTitleState extends State<StageTitle> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        const SizedBox(width: 10),
        _buildTitle(context, theme),
      ],
    );
  }

  Widget _buildTitle(BuildContext context, ThemeData theme) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.only(
          left: 6,
          right: 6,
          top: 12,
        ),
        child: Column(
          children: [
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Стадия ${widget.num}',
                      style: TextStyle(color: widget.textColor, fontSize: 16),
                      //theme.textTheme.titleMedium,
                      overflow: TextOverflow.ellipsis,
                      textScaler: const TextScaler.linear(1.0),
                    ),
                    Text(
                      widget.stage.comment,
                      style: TextStyle(color: widget.textColor, fontSize: 16),
                      //theme.textTheme.titleMedium,
                      overflow: TextOverflow.ellipsis,
                      textScaler: const TextScaler.linear(1.0),
                    ),
                  ],
                ),
                const Spacer(),
                Text(
                  getTimeBySecCount(widget.duration ~/ 1000),
                  style: TextStyle(color: widget.textColor, fontSize: 16),
                  //theme.textTheme.titleMedium,
                  overflow: TextOverflow.ellipsis,
                  textScaler: const TextScaler.linear(1.0),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Divider(
              height: 0,
              indent: 0,
              thickness: 1,
            ),
          ],
        ),
      ),
    );
  }
}
