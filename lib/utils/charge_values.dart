import 'package:flutter/material.dart';

IconData getChargeIconByLevel(double val) {
  // FIXME: yasliks -> grig: LOOK THIS
  // List<RangeValues> list = [const RangeValues(0, 1), RangeValues(0, 1)];

  if (val >= 0 && val < 5) {
    return Icons.battery_0_bar;
  } else if (val >= 5 && val < 20.5) {// FIXME: yasliks -> grig: мне кажется, это все числа нужно вынести в константы
    return Icons.battery_1_bar;
  } else if (val >= 20.5 && val < 36) {
    return Icons.battery_2_bar;
  } else if (val >= 36 && val < 51.5) {
    return Icons.battery_3_bar;
  } else if (val >= 51.5 && val < 67) {
    return Icons.battery_4_bar;
  } else if (val >= 67 && val < 82.5) {
    return Icons.battery_5_bar;
  } else if (val >= 82.5 && val < 98) {
    return Icons.battery_6_bar;
  } else if (val >= 98 && val <= 100) {
    return Icons.battery_full;
  }

  return Icons.battery_full;
}

double getChargeLevelByADC(int val) {
//  double v = (val - 0x72) / (0x82 - 0x72) * 100; /// 0x82 = 130, 0x72 = 114
  double v = (val - 0x37) / (0x74 - 0x37) * 100; /// 0x74 = 116, 0x37 = 55
  if (v > 100) {
    v = 100;
  }
  if (v < 1) {
    v = 1;
  }
  return v;
}

double getChargeLevelByADCExt(int val) {
  double v = (val - 456) / (521 - 456) * 100;
  if (v > 100) {
    v = 100;
  }
  if (v < 1) {
    v = 1;
  }
  return v;
}