import 'package:bgs_control/repositories/bgs_connect/bgs_connect.dart';
import 'package:bgs_control/repositories/bgs_connect/ble_service.dart';
import 'package:bgs_control/repositories/bgs_list/bgs_list.dart';
import 'package:bgs_control/repositories/methodic_programs/storage/program_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';

import 'bgs_app.dart';

void main() {
  GetIt.I.registerLazySingleton<BleService>(() => BleService());
  GetIt.I.registerLazySingleton<BgsConnect>(() => BgsConnect());
  GetIt.I.registerLazySingleton<BgsList>(() => BgsList());
  GetIt.I.registerLazySingleton<ProgramStorage>(() => ProgramStorage());

  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown],
  ).then((_) {
    runApp(const BgsApp());
  });

//  runApp(const BgsApp());
}
