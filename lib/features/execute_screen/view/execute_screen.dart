import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:get_it/get_it.dart';

import '../../../repositories/bgs_connect/bgs_connect.dart';
import '../../../repositories/methodic_programs/model/methodic_program.dart';
import '../../../utils/charge_values.dart';
import '../../direct_control_screen/widgets/power_widget.dart';

class ExecuteScreen extends StatefulWidget {
  const ExecuteScreen({
    super.key,
    required this.title,
    required this.device,
    required this.program,
  });

  final String title;
  final BluetoothDevice device;
  final MethodicProgram program;

  @override
  State<ExecuteScreen> createState() => _ExecuteScreenState();
}

class _ExecuteScreenState extends State<ExecuteScreen> {
  double _chargeLevel = 0;
  double _powerSet = 0;
  double _powerReal = 0;


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${widget.title}: ${widget.device.advName}',
          style: theme.textTheme.titleMedium,
        ),
        actions: [
          Icon(getChargeIconByLevel(_chargeLevel), size: 20),
          Text(
            '${_chargeLevel.toInt()}%',
            style: theme.textTheme.titleMedium,
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: PowerWidget(
        powerSet: _powerSet,
        powerReal: _powerReal,
        onPowerSet: onPowerSet,
        onPowerReset: onPowerReset,
      ),
    );
  }

  void onPowerSet(double power) {
    GetIt.I<BgsConnect>().setPower(power);
    _powerSet = power;
  }

  void onPowerReset() {
    GetIt.I<BgsConnect>().reset();
    _powerSet = 0;
  }

}
