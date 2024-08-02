import 'package:bgs_control/repositories/bgs_connect/bgs_connect.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import 'bgs_app.dart';

void main() {
  GetIt.I.registerLazySingleton<BgsConnect>(() => BgsConnect());

  runApp(const BgsApp());
}
