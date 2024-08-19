import 'package:flutter/material.dart';


IconData getChargeIconByLevel(double val) {
  if (val >= 0 && val < 5) {
    return Icons.battery_0_bar;
  } else if (val >= 5 && val < 20.5) {
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
  if (val < 0x60) {
    return 2.0;
  } else if (val >= 0x60 && val < 0x63) {
    return 5 + (val - 0x60) / 3 * 5;
  } else if (val >= 0x63 && val < 0x66) {
    return 10 + (val - 0x63) / 3 * 5;
  } else if (val >= 0x66 && val < 0x69) {
    return 15 + (val - 0x66) / 3 * 5;
  } else if (val >= 0x69 && val < 0x6D) {
    return 20 + (val - 0x69) / 4 * 10;
  } else if (val >= 0x6D && val < 0x70) {
    return 30 + (val - 0x6D) / 3 * 10;
  } else if (val >= 0x70 && val < 0x73) {
    return 40 + (val - 0x70) / 3 * 10;
  } else if (val >= 0x73 && val < 0x76) {
    return 50 + (val - 0x73) / 3 * 10;
  } else if (val >= 0x76 && val < 0x79) {
    return 60 + (val - 0x76) / 3 * 10;
  } else if (val >= 0x79 && val < 0x7C) {
    return 70 + (val - 0x79) / 3 * 10;
  } else if (val >= 0x7C && val < 0x7F) {
    return 80 + (val - 0x7C) / 3 * 10;
  } else if (val >= 0x7F && val <= 0x81) {
    return 90 + (val - 0x7f) / 3 * 10;
  } else if (val > 0x81) {
    return 100;
  }

  return 0;
}

