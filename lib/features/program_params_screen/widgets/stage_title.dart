import 'package:flutter/material.dart';

import '../../../assets/colors/colors.dart';
import '../../../repositories/methodic_programs/model/methodic_program.dart';
import '../../../utils/baseutils.dart';

class StageTitle extends StatefulWidget{
  const StageTitle({
    super.key,
    required this.num,
    required this.stage,
    required this.duration,
  });

  final int num;
  final ProgramStage stage;
  final int duration;

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
            color: backgroundColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 300,
                    child: Row(
                      children: [
                        Text(
                          'Стадия ${widget.num}',
                          style: theme.textTheme.titleMedium,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const Spacer(),
                        Text(
                          getTimeBySecCount(widget.duration ~/ 1000),
                          style: theme.textTheme.titleMedium,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  Text(
                    widget.stage.comment,
                    style: theme.textTheme.titleMedium,
                    overflow: TextOverflow.ellipsis,
                  ),
                  // SizedBox(
                  //   width: 300, //double.infinity,
                  //   height: 50,
                  //   child: Text(
                  //     'Прямое управление работой стимулятора в реальном времени',
                  //     style: theme.textTheme.labelSmall,
                  //     overflow: TextOverflow.ellipsis,
                  //     maxLines: 4,
                  //   ),
                  // ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
