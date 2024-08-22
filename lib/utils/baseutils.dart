String intToSrt(int v) {
  String s = v.toString();
  if (s.length < 2) {
    s = '0$s';
  }
  return s;
}

String getTimeBySecCount(int secCnt, bool isHour){
  int min = secCnt ~/ 60;
  int sec = secCnt % 60;

  String sm = intToSrt(min);
  String ss = intToSrt(sec);

  if (isHour)
  {
    int hour = min ~/ 60;
    min = min % 60;

    String sh = intToSrt(hour);
    sm = intToSrt(min);

    return '$sh:$sm:$ss';
  }
  
  return '$sm:$ss';
}