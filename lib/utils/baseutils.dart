String intToSrt(int v) {
  String s = v.toString();
  if (s.length < 2) {
    s = '0$s';
  }
  return s;
}

String getTimeBySecCount(int secCnt){
  int min = secCnt ~/ 60;
  int sec = secCnt % 60;
  int hour = min ~/ 60;

  String sm = intToSrt(min);
  String ss = intToSrt(sec);

  if (hour > 0)
  {
    min = min % 60;

    String sh = intToSrt(hour);
    sm = intToSrt(min);

    return '$sh:$sm:$ss';
  }

  return '$sm:$ss';
}