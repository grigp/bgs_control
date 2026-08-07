import 'package:bgs_control/repositories/methodic_programs/model/stage_info.dart';
import 'package:flutter/material.dart';

import '../../../../assets/colors/colors.dart';
import '../../../../generated/l10n.dart';
import '../../../../repositories/bgs_connect/bgs_defines.dart';
import '../../../../utils/baseutils.dart';

class StageInfoDialog extends StatefulWidget {
  const StageInfoDialog({
    super.key,
    required this.stageInfo,
  });

  final ValueNotifier<StageInfo> stageInfo;

  @override
  State<StageInfoDialog> createState() => _StageInfoDialog();
}

class _StageInfoDialog extends State<StageInfoDialog> {
  @override
  void initState() {
    super.initState();
    widget.stageInfo.addListener(_update);
  }

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
                Expanded(
                  child: Text(
                    S.of(context).stageIdxNamestage(widget.stageInfo.value.idxStage + 1, widget.stageInfo.value.nameStage),
//                    'Этап ${widget.stageInfo.value.idxStage + 1} : ${widget.stageInfo.value.nameStage}',
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleMedium,
                    textScaler: const TextScaler.linear(1.0),
                  ),
                ),
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
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Row(
                    children: [
                      Text(
                        S.of(context).time,
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
                ),
                const Divider(),

                /// Амплитудная модуляция
                Row(
                  children: [
                    Text(
                      S.of(context).amplitudeModulation,
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
                    if (widget.stageInfo.value.isFm)
                      Text(
                        S.of(context).frequencyModulation,
                        style: theme.textTheme.bodyLarge,
                        textScaler: const TextScaler.linear(1.0),
                      ),
                    if (!widget.stageInfo.value.isFm)
                      Text(
                        S.of(context).frequency,
                        style: theme.textTheme.bodyLarge,
                        textScaler: const TextScaler.linear(1.0),
                      ),
                    const Spacer(),
                    if (widget.stageInfo.value.isFm)
                      Text(
                        S.of(context).yes,
                        style: theme.textTheme.bodyLarge,
                        textScaler: const TextScaler.linear(1.0),
                      ),
                    if (!widget.stageInfo.value.isFm)
                      Text(
                        S.of(context).frequencyValue(widget.stageInfo.value.frequency.toInt()),
//                        '${widget.stageInfo.value.frequency.toInt()} Гц',
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
                      S.of(context).intensity,
                      style: theme.textTheme.bodyLarge,
                      textScaler: const TextScaler.linear(1.0),
                    ),
                    const Spacer(),
                    Text(
                      '${widget.stageInfo.value.intensivity.index + 1}',
                      style: theme.textTheme.bodyLarge,
                      textScaler: const TextScaler.linear(1.0),
                    ),
                  ],
                ),
                const Divider(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    widget.stageInfo.removeListener(_update);
    super.dispose();
  }

  void _update() {
    setState(() {});
  }

  String _stageTime() {
    if (widget.stageInfo.value.duration > 0) {
      return S.of(context).stageTmeDuration(getTimeBySecCount(widget.stageInfo.value.stageTime), getTimeBySecCount(widget.stageInfo.value.duration ~/ 1000));
//      return '${getTimeBySecCount(widget.stageInfo.value.stageTime)} из ${getTimeBySecCount(widget.stageInfo.value.duration ~/ 1000)}';
    } else {
      return S.of(context).notDefined;
    }
  }

  String _amValue() {
    if (widget.stageInfo.value.isAm) {
      if (widget.stageInfo.value.amMode == AmMode.am_11) {
        return '1:1';
      } else if (widget.stageInfo.value.amMode == AmMode.am_31) {
        return '3:1';
      } else if (widget.stageInfo.value.amMode == AmMode.am_51) {
        return '5:1';
      } else {
        return S.of(context).no;
      }
    } else {
      return S.of(context).no;
    }
  }
}
