import 'package:flutter/material.dart';

import '../../../assets/colors/colors.dart';
import '../../../generated/l10n.dart';
import '../../../repositories/database/db_defines.dart';
import '../../../utils/baseutils.dart';


class SeanceTitle extends StatefulWidget {
  const SeanceTitle({
    super.key,
    required this.seance,
    required this.isLast,
    required this.onSelect,
    required this.onDelete,
  });

  final RecordSeance seance;
  final bool isLast;
  final Function onSelect;
  final Function onDelete;

  @override
  State<SeanceTitle> createState() => _SeanceTitleState();
}

class _SeanceTitleState extends State<SeanceTitle> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: () {
        widget.onSelect(widget.seance);
      },
      child:_buildTitle(context, theme),
    );
  }

  Widget _buildTitle(BuildContext context, ThemeData theme) {
    var dt = widget.seance.dt;
    return Container(
      decoration: BoxDecoration(
        color: backgroundTestColor,
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.only(
        top: 5,
        bottom: 0,
        left: 10,
        right: 10,
      ),
      margin: const EdgeInsets.all(10),
      child: Column(
        children: [
          Row(
            children: [
              Column(
                children: [
                  Text(
                    '${pdt(dt.day)}.${pdt(dt.month)}.${dt.year}',
                    style: theme.textTheme.titleMedium,
                    overflow: TextOverflow.ellipsis,
                    textScaler: const TextScaler.linear(1.0),
                  ),
                  Text(
                    '${pdt(dt.hour)}:${pdt(dt.minute)}:${pdt(dt.second)}',
                    style: theme.textTheme.titleMedium,
                    overflow: TextOverflow.ellipsis,
                    textScaler: const TextScaler.linear(1.0),
                  ),
                ],
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  children: [
                    Text(
                      S.of(context).histDuration(getTimeBySecCount(widget.seance.duration)),
                      style: theme.textTheme.titleMedium,
                      overflow: TextOverflow.ellipsis,
                      textScaler: const TextScaler.linear(1.0),
                    ),
                    Text(
                      S.of(context).histMax(widget.seance.max),
//                      'Максимум = ${widget.seance.max}',
                      style: theme.textTheme.titleMedium,
                      overflow: TextOverflow.ellipsis,
                      textScaler: const TextScaler.linear(1.0),
                    ),
                    Text(
                      S.of(context).histAverage(widget.seance.average),
//                      'Среднее = ${widget.seance.average}',
                      style: theme.textTheme.titleMedium,
                      overflow: TextOverflow.ellipsis,
                      textScaler: const TextScaler.linear(1.0),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              GestureDetector(
                onTap: () {
                  widget.onDelete(widget.seance);
                },
                child: const Icon(Icons.close),
              )
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

  Widget _buildDivider(BuildContext context, ThemeData theme) {
    var dt = widget.seance.dt;
    return Text('${pdt(dt.day)}.${pdt(dt.month)}.${pdt(dt.year)}');
  }
}
