
import 'package:bgs_control/repositories/methodic_programs/model/stage_info.dart';
import 'package:flutter/material.dart';

import '../../../../assets/colors/colors.dart';
import '../../../../repositories/bgs_connect/bgs_connect.dart';
import '../../../../utils/baseutils.dart';

class StageInfoDialog extends StatefulWidget{
  StageInfoDialog({
    super.key,
    required this.stageInfo,
  });

  late StageInfo stageInfo;
  late _StageInfoDialog? _states;

  void updateData(StageInfo stageInfo) {
    this.stageInfo = stageInfo;
    _states?.updateData(stageInfo);
  }

  @override
  State<StageInfoDialog> createState(){
    _states = _StageInfoDialog(stageInfo: stageInfo);
    return _states!;
  }
  //State<StageInfoDialog> createState() => _StageInfoDialog();
}

class _StageInfoDialog extends State<StageInfoDialog> {
  _StageInfoDialog({
    required this.stageInfo,
  });

  late StageInfo stageInfo;

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
                  'Этап ${stageInfo.idxStage + 1} : ${stageInfo.nameStage}',
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
                    if (stageInfo.isFm)
                      Text(
                        'Частотная модуляция',
                        style: theme.textTheme.bodyLarge,
                        textScaler: const TextScaler.linear(1.0),
                      ),
                    if (!stageInfo.isFm)
                      Text(
                        'Частота',
                        style: theme.textTheme.bodyLarge,
                        textScaler: const TextScaler.linear(1.0),
                      ),
                    const Spacer(),
                    if (stageInfo.isFm)
                      Text(
                        'Да',
                        style: theme.textTheme.bodyLarge,
                        textScaler: const TextScaler.linear(1.0),
                      ),
                    if (!stageInfo.isFm)
                      Text(
                        '${stageInfo.frequency.toInt()} Гц',
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
                      '${stageInfo.intensivity.index + 1}',
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
    if (stageInfo.duration > 0) {
      return '${getTimeBySecCount(stageInfo.stageTime)} из ${getTimeBySecCount(
          stageInfo.duration ~/ 1000)}';
    } else {
      return 'Не задано';
    }
  }

  String _amValue() {
    if (stageInfo.isAm) {
      if (stageInfo.amMode == AmMode.am_11) {
        return '1:1';
      } else if (stageInfo.amMode == AmMode.am_31) {
        return '3:1';
      } else if (stageInfo.amMode == AmMode.am_51) {
        return '5:1';
      } else {
        return 'Нет';
      }
    } else {
      return 'Нет';
    }
  }

  void updateData(StageInfo stageInfo) {
    if (mounted) {
      setState(() {
        this.stageInfo = stageInfo;
      });
    }
  }
}
