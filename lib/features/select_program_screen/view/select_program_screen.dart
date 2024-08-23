import 'package:bgs_control/features/togo_params_screen/view/togo_params_screen.dart';
import 'package:bgs_control/utils/extra.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:get_it/get_it.dart';

import '../../../repositories/bgs_connect/bgs_connect.dart';
import '../../direct_control_screen/view/direct_control_screen.dart';
import '../../uikit/texel_button.dart';


class SelectProgramScreen extends StatefulWidget {
  const SelectProgramScreen({
    super.key,
    required this.title,
    required this.device,
  });

  final String title;
  final BluetoothDevice device;

  @override
  State<SelectProgramScreen> createState() => _SelectProgramScreenState();
}

class _SelectProgramScreenState extends State<SelectProgramScreen> {
  List<String> _methodics = [];
  bool _isConnected = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Stack(
            children: [
              Column(
                children: [
                  const SizedBox(height: 30),
                  Image.asset('images/background_woman.png'),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start, //.center,
                children: <Widget>[
                  const Spacer(),
                  SizedBox(
                    width: double.infinity,
                    height: 500,
                    child: ListView(
                      shrinkWrap: true,

                    ),
                  ),
                  const SizedBox(height: 10),
                  Center(
                    child:
                    TexelButton.accent(
                      onPressed: () {
                        MaterialPageRoute route = MaterialPageRoute(
                          builder: (context) => TogoParamsScreen(
                            title: 'Свободный режим',
                            device: widget.device,
                          ),
                          settings: const RouteSettings(name: '/togo_control'),
                        );
                        Navigator.of(context).push(route);
                      },
                      text: 'Свободный режим',
                    ),
                  ),
                  const SizedBox(height: 10),
                  Center(
                    child:
                    TexelButton.accent(
                      onPressed: () {
                        MaterialPageRoute route = MaterialPageRoute(
                          builder: (context) => DirectControlScreen(
                            title: 'Direct',
                            device: widget.device,
                          ),
                          settings: const RouteSettings(name: '/direct_control'),
                        );
                        Navigator.of(context).push(route);
                      },
                      text: 'Прямое управление',
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      // bottomNavigationBar: BottomAppBar(
      //   height: 500,
      //   child: Center(
      //   ),
      // ),
    );
  }

  @override
  void initState() {
    super.initState();

    GetIt.I<BgsConnect>().init(widget.device);
    widget.device.connectionState.listen((event) {
      _isConnected = event == BluetoothConnectionState.connected;
    });

  }

  @override
  void dispose() {
    if (_isConnected) {
      GetIt.I<BgsConnect>().reset();
      GetIt.I<BgsConnect>().stop();

      widget.device.disconnectAndUpdateStream().catchError((e) {});
    }

    super.dispose();
  }

  // void onSendData(BlockData data) {
  // }

  List<Widget> _buildMethodicTiles(BuildContext context) {
    return _methodics
        .map(
          (deviceName) => const Text(''),
    )
        .toList();
  }
}

