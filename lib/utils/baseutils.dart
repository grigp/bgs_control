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

int getStimulatorNumber(String deviceName) {
  var list = deviceName.split('_');
  if (list.length == 2){
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
