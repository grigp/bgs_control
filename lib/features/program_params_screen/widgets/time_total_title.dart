
import 'package:flutter/material.dart';

import '../../../utils/baseutils.dart';

class TimeTotalTitle extends StatefulWidget{
  const TimeTotalTitle({
    super.key,
    required this.duration,
  });

  final int duration;

  @override
  State<TimeTotalTitle> createState() => _TimeTotalTitle();
}

class _TimeTotalTitle extends State<TimeTotalTitle> {
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
          top: 30, //12,
        ),
        child: Column(
          children: [
            Row(
              children: [
                const Text(
                  'Время выполнения программы',
                  style: TextStyle(color: Colors.black, fontSize: 16),
                  overflow: TextOverflow.ellipsis,
                ),
                const Spacer(),
                Text(
                  getTimeBySecCount(widget.duration ~/ 1000),
                  style: const TextStyle(color: Colors.black, fontSize: 16),
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