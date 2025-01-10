
import 'package:flutter/material.dart';

import '../../../../assets/colors/colors.dart';
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
    return SizedBox(
      height: 300,
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
            child: Row(
              children: [
                Text(
                  'Этап ${widget.idxStage + 1} : ${widget.nameStage}',
                  style: theme.textTheme.titleMedium,
                  textScaler: const TextScaler.linear(1.0),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: filledSecondaryItemColor,
                      borderRadius: BorderRadius.circular(300),
                    ),
                    child: const Icon(
                      Icons.close,
                      size: 20,
                      color: black,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(
            height: 0,
            indent: 0,
            thickness: 1,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                /// Время этапа
                Row(
                  children: [
                    Text(
                      'Время',
                      style: theme.textTheme.bodyLarge,
                      textScaler: const TextScaler.linear(1.0),
                    ),
                    const Spacer(),
                    Text(
                      _stageTime(),
                      style: theme.textTheme.bodyLarge,
                      textScaler: const TextScaler.linear(1.0),
                    ),

                  ],
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
        ],
      ),
    );
  }

  String _stageTime() {
    if (widget.duration > 0) {
      return '${getTimeBySecCount(widget.stageTime)} из ${getTimeBySecCount(
          widget.duration ~/ 1000)}';
    } else {
      return 'Не задано';
    }
  }

  String _amValue() {
    if (widget.isAm) {
      if (widget.amMode == AmMode.am_11) {
        return '1:1';
      } else if (widget.amMode == AmMode.am_31) {
        return '3:1';
      } else if (widget.amMode == AmMode.am_51) {
        return '5:1';
      } else {
        return 'Нет';
      }
    } else {
      return 'Нет';
    }
  }

}
