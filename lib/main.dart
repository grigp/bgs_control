import 'package:bgs_control/repositories/bgs_connect/bgs_connect.dart';
import 'package:bgs_control/repositories/bgs_connect/ble_service.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import 'bgs_app.dart';

void main() {
  GetIt.I.registerLazySingleton<BleService>(() => BleService());
  GetIt.I.registerLazySingleton<BgsConnect>(() => BgsConnect());

  runApp(const BgsApp());
}
