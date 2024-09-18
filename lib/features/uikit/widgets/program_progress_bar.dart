import "package:flutter/material.dart";

import "../../../repositories/methodic_programs/model/methodic_program.dart";

/// От левой границы виджета до зоны отрисовки
const double LeftBorder = 5;

/// От зоны отрисовки до правой границы виджета
const double RightBorder = 5;

/// Расстояние между линиями этапов (всего их stagesCount() - 1)
const double Distance = 3;

/// Высота диаграммы в пикселях
const double DiagWidth = 6;

final Paint _paintToDo = Paint()
  ..color = Colors.black12
  ..style = PaintingStyle.fill;

final Paint _paintReady = Paint()
  ..color = Colors.black
  ..style = PaintingStyle.fill;

class ProgramProgressBar extends CustomPainter {
  ProgramProgressBar({required this.program, required this.position});

  final MethodicProgram program;

  /// Текущее значение времени в секундах
  final int position;

  @override
  void paint(Canvas canvas, Size size) {
    /// Сначала - общая длительность программы
    int allD = _programDuration();

    /// Ширина зоны диаграммы
    double widthDiag = size.width -
        LeftBorder -
        RightBorder -
        (program.stagesCount() - 1) * Distance;

    /// По этапам
    double x1 = LeftBorder;
    double y = size.height / 2;
    int dold = 0;
    for (int i = 0; i < program.stagesCount(); ++i) {
      /// Длительност этапа
      int d = program.stage(i).duration;
      /// Ширина диаграммы
      double w = d / allD * widthDiag;
      /// Прямоугольник этапа
      var rect = Rect.fromLTWH(x1, y - DiagWidth / 2, w, DiagWidth);

      /// Прорисовка
      if (position * 1000 > dold + d) {
        /// Уже законченные
        canvas.drawRect(rect, _paintReady);
      } else if (position * 1000 < dold) {
        /// Еще не начатые
        canvas.drawRect(rect, _paintToDo);
      } else {
        /// В процессе
        canvas.drawRect(rect, _paintToDo);
        double w = (position * 1000 - dold) / allD * widthDiag;
        var rectPart = Rect.fromLTWH(x1, y - DiagWidth / 2, w, DiagWidth);
        canvas.drawRect(rectPart, _paintReady);
      }

      x1 = x1 + w + Distance;
      dold += d;
    }
  }

  @override
  bool shouldRepaint(ProgramProgressBar oldDelegate) => false;

  int _programDuration() {
    int retval = 0;
    for (int i = 0; i < program.stagesCount(); ++i) {
      retval += program.stage(i).duration;
    }
    return retval;
  }
}
