import 'package:flutter/material.dart';

import '../../repositories/bgs_connect/bgs_connect.dart';

class ParamsWidget extends StatefulWidget {
  ParamsWidget({
    super.key,
    required this.isAm,
    required this.onAmChanged,
    required this.amMode,
    required this.onAmModeChanged,
    required this.isFm,
    required this.onFmChanged,
    required this.idxFreq,
    required this.onFreqChanged,
    required this.intensity,
    required this.onIntensityChanged,
  });

  bool isAm;
  final Function onAmChanged;
  AmMode amMode;
  final Function onAmModeChanged;
  bool isFm;
  final Function onFmChanged;
  double idxFreq;
  final Function onFreqChanged;
  Intensity intensity;
  final Function onIntensityChanged;


  @override
  State<ParamsWidget> createState() => _ParamsWidgetState();
}

class _ParamsWidgetState extends State<ParamsWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Row(
            /// Флажок "AM"
            children: [
              Text(
                'Ампл. модуляция (AM)',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const Spacer(),
              Switch(
                value: widget.isAm,
                activeColor: Colors.teal.shade900,
                onChanged: (bool? value) {
                  setState(() {
                    widget.isAm = value!;
                  });
                  widget.onAmChanged(widget.isAm);
                },
              ),
            ],
          ),
          if (widget.isAm)

          /// Переключатель амплитудной модуляции
            SizedBox(
              width: double.infinity,
              child: SegmentedButton<AmMode>(
                segments: <ButtonSegment<AmMode>>[
                  ButtonSegment<AmMode>(
                    value: AmMode.am_11,
                    label: Text(amModeNames[AmMode.am_11]!),
                  ),
                  ButtonSegment<AmMode>(
                    value: AmMode.am_31,
                    label: Text(amModeNames[AmMode.am_31]!),
                  ),
                  ButtonSegment<AmMode>(
                    value: AmMode.am_51,
                    label: Text(amModeNames[AmMode.am_51]!),
                  ),
                ],
                selected: <AmMode>{widget.amMode},
                onSelectionChanged: (Set<AmMode> newSelection) {
                  setState(() {
                    widget.amMode = newSelection.first;
                    widget.onAmModeChanged(widget.amMode);
                  });
                },
              ),
            ),
          Row(
            /// Флажок "FM"
            children: [
              Text(
                'Част. модуляция (FM)',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const Spacer(),
              Switch(
                value: widget.isFm,
                activeColor: Colors.teal.shade900,
                onChanged: (bool? value) {
                  setState(() {
                    widget.isFm = value!;
                  });
                  widget.onFmChanged(widget.isFm);
                },
              ),
            ],
          ),
          const SizedBox(height: 10),
          if (!widget.isFm)
          /// Регулятор частоты
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Частота: ${freqValue[widget.idxFreq]!.toInt()}',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                Slider.adaptive(
                  value: widget.idxFreq,
                  label: freqValue[widget.idxFreq]!.round().toString(),
                  min: 0,
                  max: 6,
                  divisions: 6,
                  activeColor: Colors.teal.shade900,
                  onChanged: (double value) {
                    setState(() {
                      widget.idxFreq = value;
                    });
                  },
                  onChangeEnd: (double value) {
                    /// В этот момент мы будем устанавливать частоту
                    widget.onFreqChanged(widget.idxFreq);
                  },
                ),
              ],
            ),
          const SizedBox(height: 10),
          Column(
            /// Переключатель интенсивности
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Интенсивность',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: SegmentedButton<Intensity>(
                  segments: const <ButtonSegment<Intensity>>[
                    ButtonSegment<Intensity>(
                      value: Intensity.one,
                      label: Text('1'),
                    ),
                    ButtonSegment<Intensity>(
                      value: Intensity.two,
                      label: Text('2'),
                    ),
                    ButtonSegment<Intensity>(
                      value: Intensity.free,
                      label: Text('3'),
                    ),
                    ButtonSegment<Intensity>(
                      value: Intensity.four,
                      label: Text('4'),
                    ),
                  ],
                  selected: <Intensity>{widget.intensity},
                  onSelectionChanged: (Set<Intensity> newSelection) {
                    setState(() {
                      widget.intensity = newSelection.first;
                    });
                    widget.onIntensityChanged(widget.intensity);
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

}
