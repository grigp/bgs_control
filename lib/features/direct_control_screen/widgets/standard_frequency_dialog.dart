import 'package:flutter/material.dart';

import '../../../assets/colors/colors.dart';

class StandardFrequencyDialog extends StatefulWidget{
  const StandardFrequencyDialog({
    super.key,
    required this.freqency,
    required this.onChanged,
  });

  final int freqency;
  final Function onChanged;

  @override
  State<StandardFrequencyDialog> createState() => _StandardFrequencyDialog();
}

class _StandardFrequencyDialog extends State<StandardFrequencyDialog> {
  @override
  void initState() {
    super.initState();
    //_freqency = widget.freqency;
  }

  int _freqency = 0;

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
                    'Стандартная частота',
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
                SegmentedButton<int>(
                  style: SegmentedButton.styleFrom(
                    selectedBackgroundColor: backgroundMiddleTestColor,
                  ),
                  showSelectedIcon: false,
                  segments: const <ButtonSegment<int>>[
                    ButtonSegment<int>(
                      value: 15,
                      label: Text(
                        '15',
                        textScaler: const TextScaler.linear(1.0),
                      ),
                    ),
                    ButtonSegment<int>(
                      value: 30,
                      label: Text(
                        '30',
                        textScaler: const TextScaler.linear(1.0),
                      ),
                    ),
                    ButtonSegment<int>(
                      value: 60,
                      label: Text(
                        '60',
                        textScaler: const TextScaler.linear(1.0),
                      ),
                    ),
                    ButtonSegment<int>(
                      value: 90,
                      label: Text(
                        '90',
                        textScaler: const TextScaler.linear(1.0),
                      ),
                    ),
                    ButtonSegment<int>(
                      value: 120,
                      label: Text(
                        '120',
                        textScaler: const TextScaler.linear(1.0),
                      ),
                    ),
                    ButtonSegment<int>(
                      value: 180,
                      label: Text(
                        '180',
                        textScaler: const TextScaler.linear(1.0),
                      ),
                    ),
                    ButtonSegment<int>(
                      value: 350,
                      label: Text(
                        '350',
                        textScaler: const TextScaler.linear(1.0),
                      ),
                    ),
                  ],
                  selected: <int>{_freqency},
                  onSelectionChanged: (Set<int> newSelection) {
                    setState(() {
                      _freqency = newSelection.first;
                    });
                    widget.onChanged(_freqency);
                    Navigator.pop(context);
//                    widget.onIntensityChanged(widget.intensity);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

}
