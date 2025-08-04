import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';

const int ValueSize = 60;

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
              widget.value.roundToDouble()),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(milliseconds: 50), _onRollingTimer);
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
    widget.value = _startValue - _offset / ValueSize;

    log('***** END: ${details.velocity.pixelsPerSecond.dx}  offset: $_offset  value: ${widget.value}');

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
      log('***** CORRECT speed: ${_speed}  offset: $_offset  value: ${widget.value}');
      _speed /= (1 + 5/_speed.abs());

      if (_speed.abs() <= 50) {
        setState(() {
          widget.value = _startValue - _offset / ValueSize;
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
      }

      log('***** CORRECT speed: ${_speed}  offset: $_offset  value: ${widget.value}');

      if (_speed != 0) {
        setState(() {
          _offset -= (_speed * 0.1);
        });
      }
    }
  }
}

class WheelPainter extends CustomPainter {
  WheelPainter(this.min, this.max, this.value, this.offset, this.speed);

  double min;
  double max;
  double value;
  double offset;
  double speed;

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
//    print('------------ $text : ${textPainter.width}');
    textPainter.paint(canvas, offset);
  }


    @override
  void paint(Canvas canvas, Size size) {
    double midX = size.width / 2 + offset;
    double midY = size.height / 2;

    double n = 0;
    do {
      if (value + n < max) {
        double x = midX + n * ValueSize;
        if (x > 0 && x < size.width) {
          drawText(
            canvas,
            size,
            (value + n).toInt().toString(),
            x - 14,
            midY - 14,
            Colors.black,
            // Color.fromRGBO((50 + n * 10).toInt(), (50 + n * 10).toInt(),
            //     (50 + n * 10).toInt(), 1),
            28,
          );
        }
      }
      if (value - n > min) {
        double x = midX - n * ValueSize;
        if (x > 0 && x < size.width) {
          drawText(
            canvas,
            size,
            (value - n).toInt().toString(),
            x - 14,
            midY - 14,
            Colors.black,
            // Color.fromRGBO((50 + n * 10).toInt(), (50 + n * 10).toInt(),
            //     (50 + n * 10).toInt(), 1),
            28,
          );
        }
      }
      ++n;
    } while (value - n >= min || value + n <= max);


    // drawText(
    //     canvas, size, speed.toInt().toString(), 5, midY - 14, Colors.red, 28);
  }

  @override
  bool shouldRepaint(WheelPainter oldDelegate) => true; //false;
}
