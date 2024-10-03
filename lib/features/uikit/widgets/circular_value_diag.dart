import "dart:math";
import "dart:ui";

import "package:flutter/material.dart";

final Paint _paintNoValue = Paint()
  ..color = Colors.black12
  ..style = PaintingStyle.fill;

final Paint _paintValue = Paint()
  ..color = Colors.green
  ..style = PaintingStyle.fill;

final Paint _paintB = Paint()
  ..color = Colors.white
  ..style = PaintingStyle.fill;

final Paint _paintT = Paint()
  ..color = Colors.black
  ..style = PaintingStyle.fill;

enum CircularValueDiagMode { cvdmValue, cvdmText }

class CircularValueDiag extends CustomPainter {
  CircularValueDiag({
    required this.value,
    required this.min,
    required this.max,
  });

  /// Конструктор в режиме togo
  factory CircularValueDiag.text(String textMain, String textAdv) {
    return CircularValueDiag(
      value: 0,
      min: 0,
      max: 100,
    )
      .._textMain = textMain
      .._textAdv = textAdv
      .._mode = CircularValueDiagMode.cvdmText;
  }

  final int value;
  final int min;
  final int max;
  String _textMain = '';
  String _textAdv = '';
  CircularValueDiagMode _mode = CircularValueDiagMode.cvdmValue;

  @override
  void paint(Canvas canvas, Size size) {
    double r = size.width / 2;
    if (size.height < size.width) {
      r = size.height;
    }

    double av = (value - min) / (max - min) * (6 * pi / 4);

    Color color = Colors.green;
    if ((value - min) < (max - min) / 2) {
      double r = ((value - min) / ((max - min) / 2)) * 255;
      color = Color.fromARGB(255, r.toInt(), 255, 0);
    } else {
      double r = ((value - ((max - min) / 2)) / ((max - min) / 2)) * 255;
      color = Color.fromARGB(255, 255, 255 - r.toInt(), 0);
    }

    final Paint paintV = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    if (_mode == CircularValueDiagMode.cvdmValue){
      canvas.drawCircle(
          Offset(size.width / 2, size.height / 2), r, _paintNoValue);
      canvas.drawArc(Rect.fromLTWH(0, 0, size.width, size.height), 3 * pi / 4, av,
          true, paintV);
      canvas.drawCircle(
          Offset(size.width / 2, size.height / 2), r * 0.85, _paintB);
      canvas.drawArc(Rect.fromLTWH(0, 0, size.width, size.height), pi / 4, pi / 2,
          true, _paintB);

      const textStyle = TextStyle(
        color: Colors.black,
        fontSize: 40,
      );
      var textSpan = TextSpan(
        text: '$value',
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
      final xCenter = (size.width - textPainter.width) / 2;
      final yCenter = (size.height - textPainter.height) / 2;
      final offset = Offset(xCenter, yCenter);
      textPainter.paint(canvas, offset);
    } else {
      final Paint paintV = Paint()
        ..color = Colors.green
        ..style = PaintingStyle.fill;

      canvas.drawCircle(
          Offset(size.width / 2, size.height / 2), r, paintV);
      canvas.drawCircle(
          Offset(size.width / 2, size.height / 2), r * 0.85, _paintB);

      const textStyle = TextStyle(
        color: Colors.black,
        fontSize: 28,
      );
      var textSpan = TextSpan(
        text: _textMain,
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
      final xCenter = (size.width - textPainter.width) / 2;
      final yCenter = (size.height - textPainter.height) / 2;
      final offset = Offset(xCenter, yCenter);
      textPainter.paint(canvas, offset);
    }
  }

  @override
  bool shouldRepaint(CircularValueDiag oldDelegate) => false;

  Paragraph createText(String text) {
    final builder = ParagraphBuilder(ParagraphStyle(fontSize: 20));
    builder.addText(text);
    return builder.build();
  }
}
