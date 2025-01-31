import 'package:flutter/material.dart';

String intToSrt(int v) {
  String s = v.toString();
  if (s.length < 2) {
    s = '0$s';
  }
  return s;
}

String getTimeBySecCount(int secCnt) {
  int min = secCnt ~/ 60;
  int sec = secCnt % 60;
  int hour = min ~/ 60;

  String sm = intToSrt(min);
  String ss = intToSrt(sec);

  if (hour > 0) {
    min = min % 60;

    String sh = intToSrt(hour);
    sm = intToSrt(min);

    return '$sh:$sm:$ss';
  }

  return '$sm:$ss';
}

int getStimulatorNumber(String deviceName) {
  var list = deviceName.split('_');
  if (list.length == 2) {
    int num = int.parse(list[1]);
    return num;
  } else {
    return 0;
  }
}

String getShortDeviceName(String deviceName) {
  return 'texel №${getStimulatorNumber(deviceName)}';
}

String getFullDeviceName(String deviceName) {
  return 'Электростимулятор texel №${getStimulatorNumber(deviceName)}';
}

void pushScreen(BuildContext context, RoutePageBuilder pageBuilder, String name,
    ShiftDirection sd) {
  /// Откуда будет появляться экран
  double dx = 0.0;
  double dy = 0.0;
  if (sd == ShiftDirection.rightToLeft) {
    dx = 1.0;
    dy = 0.0;
  } else if (sd == ShiftDirection.bottomToUp) {
    dx = 0.0;
    dy = 1.0;
  } else if (sd == ShiftDirection.upToBottom) {
    dx = 0.0;
    dy = -1.0;
  } else if (sd == ShiftDirection.leftToRight) {
    dx = -1.0;
    dy = 0.0;
  }

  /// Собственно, открыть анимируя
  Navigator.push(
    context,
    PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: pageBuilder,
      settings: RouteSettings(
        name: name,
      ),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = Offset(dx, dy);
        var end = Offset.zero;
        var curve = Curves.easeInOut;
        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);

        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
    ),
  );
}

enum ShiftDirection { leftToRight, rightToLeft, bottomToUp, upToBottom }
