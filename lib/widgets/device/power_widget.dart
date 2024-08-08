import 'package:flutter/material.dart';

final ButtonStyle _resetButtonStyle = ElevatedButton.styleFrom(
  foregroundColor: Colors.white,
  backgroundColor: Colors.teal.shade900,
  minimumSize: const Size(350, 45),
  shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.all(
      Radius.circular(25),
    ),
  ),
);

class PowerWidget extends StatefulWidget {
  PowerWidget({
    super.key,
    required this.powerSet,
    required this.powerReal,
    required this.onPowerSet,
    required this.onPowerReset,
  });

  double powerSet;
  double powerReal;
  final Function onPowerSet;
  final Function onPowerReset;

  @override
  State<PowerWidget> createState() => _PowerWidgetState();
}

class _PowerWidgetState extends State<PowerWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Column(
          /// Регулятор мощности
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Мощность ${widget.powerSet.toInt()}',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            Slider.adaptive(
              value: widget.powerSet,
              label: widget.powerSet.round().toString(),
              min: 0,
              max: 125,
              divisions: 125,
              activeColor: Colors.teal.shade900,
              onChanged: (double value) {
                setState(() {
                  widget.powerSet = value;
                });
              },
              onChangeEnd: (double value) {
                /// В этот момент мы будем устанавливать мощность
                widget.onPowerSet(widget.powerSet);
              },
            ),
          ],
        ),
        Row(
          children: [
            const Spacer(flex: 2),
            GestureDetector(
              onTap: () {
                setState(() {
                  --widget.powerSet;
                  widget.onPowerSet(widget.powerSet);
                });
              },
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: Colors.teal.shade900,
                ),
                child: const Center(
                  child: Icon(
                    Icons.remove,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const Spacer(),
            Text(
              widget.powerReal.round().toString(),
              style: TextStyle(
                fontSize: 60,
                color: Colors.teal.shade900,
              ),
            ),
            const Spacer(),
            GestureDetector(
              onTap: () {
                setState(() {
                  ++widget.powerSet;
                  widget.onPowerSet(widget.powerSet);
                });
              },
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: Colors.teal.shade900,
                ),
                child: const Center(
                  child: Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const Spacer(flex: 2),
          ],
        ),
        const SizedBox(height: 10),
        Center(
          child: ElevatedButton(
            onPressed: () {
              widget.powerSet = 0;
              widget.onPowerReset();
            },
            style: _resetButtonStyle,
            child: const Text(
              'Сброс',
              style: TextStyle(fontSize: 22),
            ),
          ),
        ),
      ],
    );
  }
}
