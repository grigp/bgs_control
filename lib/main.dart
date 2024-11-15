import 'package:bgs_control/repositories/bgs_connect/ble_service.dart';
import 'package:bgs_control/repositories/bgs_list/bgs_list.dart';
import 'package:bgs_control/repositories/logger/communication_logger.dart';
import 'package:bgs_control/repositories/methodic_programs/storage/program_storage.dart';
import 'package:bgs_control/repositories/running_manager/running_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:workmanager/workmanager.dart';

import 'bgs_app.dart';

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) {
    print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
    print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Native called background task: $task >>>>>>>>>>>>>>>>>>>>>>>>>>>>");
    print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
    int cnt = 0;
    int s = -1;
    while (cnt <= 100) {
      final now = DateTime.now();
      int sn = now.second;
      if (sn != s){
        print('>>>>>>>>>>>>>> count workmanager : ${cnt++}');
        s = sn;
      }
    }
    return Future.value(true);
  });
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Workmanager().initialize(
      callbackDispatcher, // The top level function, aka callbackDispatcher
      isInDebugMode: true // If enabled it will post a notification whenever the task is running. Handy for debugging tasks
  );

  GetIt.I.registerLazySingleton<BleService>(() => BleService());
  GetIt.I.registerLazySingleton<BgsList>(() => BgsList());
  GetIt.I.registerLazySingleton<ProgramStorage>(() => ProgramStorage());
  GetIt.I.registerLazySingleton<RunningManager>(() => RunningManager());
  GetIt.I.registerLazySingleton<CommunicationLogger>(() => CommunicationLogger());

  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown],
  ).then((_) {
    runApp(const BgsApp());
  });

//  runApp(const BgsApp());
}
