import "dart:math";
import "dart:ui";

import "package:flutter/material.dart";

final Paint _paintNoValue = Paint()
  ..color = Colors.black12
  ..style = PaintingStyle.fill;

final Paint _paintValue = Paint()
  ..color = Colors.green
  ..style = PaintingStyle.fill;

final Paint _paintV = Paint()
  ..color = Colors.green
  ..style = PaintingStyle.fill;

final Paint _paintB = Paint()
  ..color = Colors.white
  ..style = PaintingStyle.fill;

final Paint _paintT = Paint()
  ..color = Colors.black
  ..style = PaintingStyle.fill;

class CircularValueDiag extends CustomPainter {
  CircularValueDiag(
      {required this.value, required this.min, required this.max});

  final int value;
  final int min;
  final int max;

  @override
  void paint(Canvas canvas, Size size) {
    double r = size.width / 2;
    if (size.height < size.width) {
      r = size.height;
    }

    double av = (value - min) / (max - min) * (6 * pi / 4);

    canvas.drawCircle(
        Offset(size.width / 2, size.height / 2), r, _paintNoValue);
    canvas.drawArc(Rect.fromLTWH(0, 0, size.width, size.height), 3 * pi / 4,
        av, true, _paintV);
    canvas.drawCircle(
        Offset(size.width / 2, size.height / 2), r * 0.85, _paintB);
    canvas.drawArc(Rect.fromLTWH(0, 0, size.width, size.height), pi / 4, pi / 2,
        true, _paintB);

    var par = createText('$value')..layout(const ParagraphConstraints(width: 40));
    canvas.drawParagraph(par, Offset(size.width / 2, size.height / 2));
  }

  @override
  bool shouldRepaint(CircularValueDiag oldDelegate) => false;

  Paragraph createText(String text) {
    final builder = ParagraphBuilder(ParagraphStyle(fontSize: 20));
    builder.addText(text);
    return builder.build();
  }

}

