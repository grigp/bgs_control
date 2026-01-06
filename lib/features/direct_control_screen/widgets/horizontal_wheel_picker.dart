import 'dart:async';

import 'package:flutter/material.dart';

class HorizontalWheelPicker extends StatefulWidget {
  HorizontalWheelPicker({
    super.key,
    required this.min,
    required this.max,
    required this.value,
    required this.onChange,
  });

  double min;
  double max;
  double value;
  final Function onChange;

  @override
  State<HorizontalWheelPicker> createState() => _HorizontalWheelPickerState();
}

class _HorizontalWheelPickerState extends State<HorizontalWheelPicker> {
  double _speed = 0;
  late Timer _timer;

  final valueSize = 60;

  double _startPosition = 0;
  double _startValue = 0;
  double _offset = 0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      height: 34,
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(
          color: const Color(0xffcacaca),
        ),
        gradient: const LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: <Color>[
            Color(0xffefefef),
            Color(0xffffffff),
            Color(0xffefefef),
          ],
        ),
        borderRadius: const BorderRadius.all(Radius.circular(3)),
      ),
      child: GestureDetector(
        onHorizontalDragStart: _onHorizontalDragStart,
        onHorizontalDragEnd: _onHorizontalDragEnd,
        onHorizontalDragUpdate: _onHorizontalDragUpdate,
        child: CustomPaint(
          painter: WheelPainter(
              widget.min,
              widget.max,
              widget.value.roundToDouble(),
              _offset,
              widget.value.roundToDouble(),
              valueSize,
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
//    _timer = Timer.periodic(const Duration(seconds: 0), _onRollingTimer);
    _timer = Timer.periodic(const Duration(milliseconds: 10), _onRollingTimer);
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _onHorizontalDragStart(DragStartDetails details) {
    _startPosition = details.globalPosition.dx;
    _startValue = widget.value;
  }

  void _onHorizontalDragEnd(DragEndDetails details) {
    widget.value = _startValue - _offset / valueSize;

    if (details.velocity.pixelsPerSecond.dx == 0) {
      widget.onChange(widget.value);
      _startPosition = 0;
      _offset = 0;
    }
    _speed = -details.velocity.pixelsPerSecond.dx / 10;
    if (_speed.abs() > 1000) _speed = 1000 * (_speed.abs() / _speed);
  }

  void _onHorizontalDragUpdate(DragUpdateDetails details) {
    setState(() {
      _offset = details.globalPosition.dx - _startPosition;
    });
  }

  void _onRollingTimer(Timer timer) {
    if (_speed != 0) {
      _speed /= (1 + 5 / _speed.abs());

      if (_speed.abs() <= 50) {
        setState(() {
          widget.value = _startValue - _offset / valueSize;
          if (widget.value <= widget.min) {
            widget.value = widget.min;
            _speed = 0;
            _startPosition = 0;
            _offset = 0;
          }
          if (widget.value >= widget.max) {
            widget.value = widget.max;
            _speed = 0;
            _startPosition = 0;
            _offset = 0;
          }
        });
        widget.onChange(widget.value);
        _startPosition = 0;
        _offset = 0;
        _speed = 0;
      } else {
        setState(() {
          widget.value = _startValue - _offset / valueSize;
        });
      }

      if (_speed != 0) {
        setState(() {
          _offset -= (_speed / _speed.abs() * 40);
        });
      }
    }
  }
}

class WheelPainter extends CustomPainter {
  WheelPainter(
    this.min,
    this.max,
    this.value,
    this.offset,
    this.speed,
    this.valueSize,
  );

  double min;
  double max;
  double value;
  double offset;
  double speed;
  int valueSize;

  /// Выводит текст
  void drawText(Canvas canvas, Size size, String text, double x, double y,
      Color color, double fontSize) {
    var textStyle = TextStyle(
      color: color,
      fontSize: fontSize,
    );
    var textSpan = TextSpan(
      text: text,
      style: textStyle,
    );
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout(
      minWidth: 0,
      maxWidth: size.width,
    );
    final offset = Offset(x, y);
    textPainter.paint(canvas, offset);
  }

  @override
  void paint(Canvas canvas, Size size) {
    double midX = size.width / 2 + offset;
    double midY = size.height / 2;

    double n = 0;

    int xOffs = 10;
    if (value >= 10 && value <= 99) {
      xOffs = 17;
    } else if (value >= 100) {
      xOffs = 24;
    }

    do {
      if (value + n < max) {
        double x = midX + n * valueSize;
        if (x > 0 && x < size.width) {
          drawText(
            canvas,
            size,
            (value + n).toInt().toString(),
            x - xOffs,
            midY - 14,
            n == 0 ? Colors.black : Colors.black38,
            28,
          );
        }
      }
      if (value - n > min) {
        double x = midX - n * valueSize;
        if (x > 0 && x < size.width) {
          drawText(
            canvas,
            size,
            (value - n).toInt().toString(),
            x - xOffs,
            midY - 14,
            n == 0 ? Colors.black : Colors.black38,
            28,
          );
        }
      }
      ++n;
    } while (value - n >= min || value + n <= max);
  }

  @override
  bool shouldRepaint(WheelPainter oldDelegate) => true; //false;
}
