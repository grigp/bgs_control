import 'dart:async';

import 'package:bgs_control/repositories/app_monitor/app_monitor.dart';
import 'package:bgs_control/repositories/bgs_connect/ble_service.dart';
import 'package:bgs_control/repositories/bgs_list/bgs_list.dart';
import 'package:bgs_control/repositories/bgs_property_storage/bgs_property_storage.dart';
import 'package:bgs_control/repositories/logger/communication_logger.dart';
import 'package:bgs_control/repositories/methodic_programs/storage/program_storage.dart';
import 'package:bgs_control/repositories/methodic_programs/storage/select_program_manager.dart';
import 'package:bgs_control/repositories/running_manager/running_manager.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get_it/get_it.dart';
import 'package:workmanager/workmanager.dart';

import 'bgs_app.dart';

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    int length = inputData?["time"];

    if (kDebugMode) {
      print(
        ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>",
      );
      print(
        ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Native called background task: $task - ${length / 1000} sec >>>>>>>>>>>>>>>>>>>>>>>>>>>>",
      );
      print(
        ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>",
      );
    }

    await Future.delayed(Duration(milliseconds: length));

    if (kDebugMode) {
      print("<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<");
      print("<<<<<<<<<<<<<<<<<<<<<<<<    ДОЖДАЛИСЬ    <<<<<<<<<<<<<<<<<<<<<<<");
      print("<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<");
    }

    // int s = -1;
    // int cnt = 0;
    // while (cnt <= length / 1000) {
    //   final now = DateTime.now();
    //   int sn = now.second;
    //   if (sn != s){
    //     print('>>>>>>>>>>>>>> count workmanager : ${cnt++} : ${length / 1000}');
    //     s = sn;
    //   }
    // }
    return Future.value(true);
  });
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Workmanager().initialize(
    callbackDispatcher, // The top level function, aka callbackDispatcher
    isInDebugMode: kDebugMode, // If enabled it will post a notification
    // whenever the task is running. Handy for debugging tasks
  );

  GetIt.I.registerLazySingleton<BleService>(() => BleService());
  GetIt.I.registerLazySingleton<BgsList>(() => BgsList());
  GetIt.I.registerLazySingleton<BgsPropertyStorage>(() => BgsPropertyStorage());
  GetIt.I.registerLazySingleton<ProgramStorage>(() => ProgramStorage());
  GetIt.I.registerLazySingleton<SelectProgramManager>(() => SelectProgramManager());
  GetIt.I.registerLazySingleton<RunningManager>(() => RunningManager());
  GetIt.I.registerLazySingleton<CommunicationLogger>(
    () => CommunicationLogger(),
  );
  GetIt.I.registerLazySingleton<AppMonitor>(() => AppMonitor());

  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
    [
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ],
  ).then((_) {
    // WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
    // FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
    runApp(const BgsApp());
  });
}
