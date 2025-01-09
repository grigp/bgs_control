import 'package:flutter/material.dart';

import '../../../../repositories/bgs_connect/bgs_connect.dart';
import '../../../../utils/baseutils.dart';

class StageInfoDialog extends StatefulWidget{
  const StageInfoDialog({
    super.key,
    required this.idxStage,
    required this.nameStage,
    required this.duration,
    required this.stageTime,
    required this.isAm,
    required this.amMode,
    required this.isFm,
    required this.frequency,
    required this.intensivity,
  });

  final int idxStage;
  final String nameStage;
  final int duration;
  final int stageTime;
  final bool isAm;
  final AmMode amMode;
  final bool isFm;
  final double frequency;
  final Intensivity intensivity;

  @override
  State<StageInfoDialog> createState() => _StageInfoDialog();
}

class _StageInfoDialog extends State<StageInfoDialog> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(20),
      child: SizedBox(
        height: 300,
        width: double.infinity,
        child: Column(
          children: [
            /// Этап
            Text(
              'Этап ${widget.idxStage + 1}',
              style: theme.textTheme.titleLarge,
              textScaler: const TextScaler.linear(1.0),
            ),
            /// Название этапа
            Text(
              widget.nameStage,
              style: theme.textTheme.titleLarge,
              textScaler: const TextScaler.linear(1.0),
            ),
            const Divider(),
            /// Время этапа
            Text(
              'Время ${getTimeBySecCount(
                  widget.stageTime)} из ${getTimeBySecCount(
                  widget.duration ~/ 1000)}',
              style: theme.textTheme.titleLarge,
              textScaler: const TextScaler.linear(1.0),
            ),
            const Divider(),
            /// Амплитудная модуляция
            Row(
              children: [
                Text(
                  'Амплитудная модуляция',
                  style: theme.textTheme.bodyLarge,
                  textScaler: const TextScaler.linear(1.0),
                ),
                const Spacer(),
                Text(
                  _amValue(),
                  style: theme.textTheme.bodyLarge,
                  textScaler: const TextScaler.linear(1.0),
                ),
              ],
            ),
            const Divider(),
            /// Частотная модуляция
            Row(
              children: [
                if (widget.isFm)
                Text(
                  'Частотная модуляция',
                  style: theme.textTheme.bodyLarge,
                  textScaler: const TextScaler.linear(1.0),
                ),
                if (!widget.isFm)
                  Text(
                    'Частота',
                    style: theme.textTheme.bodyLarge,
                    textScaler: const TextScaler.linear(1.0),
                  ),
                const Spacer(),
                if (widget.isFm)
                Text(
                  'Да',
                  style: theme.textTheme.bodyLarge,
                  textScaler: const TextScaler.linear(1.0),
                ),
                if (!widget.isFm)
                  Text(
                    '${widget.frequency.toInt()} Гц',
                    style: theme.textTheme.bodyLarge,
                    textScaler: const TextScaler.linear(1.0),
                  ),
              ],
            ),
            const Divider(),
            /// Интенсивность
            Row(
              children: [
                Text(
                  'Интенсивность',
                  style: theme.textTheme.bodyLarge,
                  textScaler: const TextScaler.linear(1.0),
                ),
                const Spacer(),
                Text(
                  '${widget.intensivity.index + 1}',
                  style: theme.textTheme.bodyLarge,
                  textScaler: const TextScaler.linear(1.0),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }


  String _amValue() {
    if (widget.amMode == AmMode.am_11) {
      return '1:1';
    } else if (widget.amMode == AmMode.am_31) {
      return '3:1';
    } else if (widget.amMode == AmMode.am_51) {
      return '5:1';
    } else {
      return 'Нет';
    }
  }

}
