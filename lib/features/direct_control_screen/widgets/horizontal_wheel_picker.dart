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
          ),
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

  void _onHorizontalDragStart (DragStartDetails details) {
    _startPosition = details.globalPosition.dx;
    _startValue = widget.value;
  }
  void _onHorizontalDragEnd (DragEndDetails details) {
    _startPosition = 0;
    _speed = -details.velocity.pixelsPerSecond.dx;
    log('***** END: ${details.velocity.pixelsPerSecond.dx}   value: ${widget.value}');
  }

  void _onHorizontalDragUpdate(DragUpdateDetails details) {
    setState(() {
      var pos = details.globalPosition.dx - _startPosition;
      widget.value = _startValue - pos / ValueSize;
      widget.onChange(widget.value);
    });
  }

  void _onRollingTimer(Timer timer) {
    if (_speed != 0) {
      if (_speed > 0) {
        _speed -= 40;
        if (_speed < 0) _speed = 0;
      }
      if (_speed < 0) {
        _speed += 40;
        if (_speed > 0) _speed = 0;
      }
      
      widget.value += (_speed * 0.01);
      if (widget.value < widget.min){
        widget.value = widget.min;
      }
      if (widget.value > widget.max){
        widget.value = widget.max;
      }
      
      log('***** SPEED: ${_speed} value: ${widget.value}');
      
      widget.onChange(widget.value);
    }
  }

}

class WheelPainter extends CustomPainter {
  WheelPainter(this.min, this.max, this.value);

  double min;
  double max;
  double value;

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
    double midX = size.width / 2;
    double midY = size.height / 2;

    drawText(canvas, size, value.toInt().toString(), midX - 14, midY - 14,
        Colors.black, 28);

    double n = 0;
    while (true) {
      ++n;
      if (value + n < max) {
        double x = midX + n * ValueSize;
        if (x > size.width) {
          break;
        }
        drawText(
          canvas,
          size,
          (value + n).toInt().toString(),
          x - 14,
          midY - 14,
          Color.fromRGBO((100 + n * 30).toInt(), (100 + n * 30).toInt(),
              (100 + n * 30).toInt(), 1),
          28,
        );
      }
      if (value - n > min) {
        double x = midX - n * ValueSize;
        if (x < 0) {
          break;
        }
        drawText(
          canvas,
          size,
          (value - n).toInt().toString(),
          x - 14,
          midY - 14,
          Color.fromRGBO((100 + n * 30).toInt(), (100 + n * 30).toInt(),
              (100 + n * 30).toInt(), 1),
          28,
        );
      }
    }
  }

  @override
  bool shouldRepaint(WheelPainter oldDelegate) => true; //false;
}
