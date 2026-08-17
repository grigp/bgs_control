import 'dart:async';

import 'package:bgs_control/assets/themes/light_theme.dart';
import 'package:bgs_control/features/invitation_to_connect_screen/view/invitation_to_connect_screen.dart';
import 'package:bgs_control/repositories/methodic_programs/storage/program_storage.dart';
import 'package:bgs_control/repositories/methodic_programs/storage/select_program_manager.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:get_it/get_it.dart';

import 'features/bluetooth_off_screen/view/bluetooth_off_screen.dart';

import 'package:flutter_localizations/flutter_localizations.dart';
import 'generated/l10n.dart';

class BgsApp extends StatefulWidget {
  const BgsApp({super.key});

  @override
  State<BgsApp> createState() => _BgsAppState();
}

class _BgsAppState extends State<BgsApp> {
  BluetoothAdapterState _adapterState = BluetoothAdapterState.unknown;

  late StreamSubscription<BluetoothAdapterState> _adapterStateStateSubscription;

  @override
  void initState() {
    super.initState();

    /// Инициализируем хранилище программ
    GetIt.I<ProgramStorage>().init();
    GetIt.I<SelectProgramManager>().init();

    _adapterStateStateSubscription = FlutterBluePlus.adapterState.listen((
      state,
    ) {
      _adapterState = state;
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _adapterStateStateSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget screen = _adapterState == BluetoothAdapterState.on
        ? const InvitationToConnectScreen(title: "Electrical stimulators texel")
        : BluetoothOffScreen(adapterState: _adapterState);

    return MaterialApp(
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(context).copyWith(
          boldText: false,
          textScaler: const TextScaler.linear(1.0),
        ),
        child: child!,
      ),
      title: 'bgs',
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      theme: lightTheme,
      home: screen,
      debugShowCheckedModeBanner: kDebugMode ? true : false,
    );
  }

}

// class BgsApp extends StatelessWidget {
//   const BgsApp({super.key});
//
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'BGS control',
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
//         useMaterial3: true,
//       ),
//       routes: routes,
//     );
//   }
// }
