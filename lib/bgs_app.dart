import 'dart:async';

import 'package:bgs_control/assets/themes/light_theme.dart';
import 'package:bgs_control/features/invitation_to_connect_screen/view/invitation_to_connect_screen.dart';
import 'package:bgs_control/repositories/methodic_programs/storage/program_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:get_it/get_it.dart';

import 'features/bluetooth_off_screen/view/bluetooth_off_screen.dart';

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
        ? const InvitationToConnectScreen(title: 'Электростимуляторы texel')
        : BluetoothOffScreen(adapterState: _adapterState);

    return MaterialApp(
      title: 'bgs',
      theme: lightTheme,
      home: screen,
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
