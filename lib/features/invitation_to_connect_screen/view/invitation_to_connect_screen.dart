import 'package:bgs_control/features/attention_screen/view/attention_screen.dart';
import 'package:bgs_control/features/select_device_screen/view/select_device_screen.dart';
import 'package:bgs_control/features/uikit/styles.dart';
import 'package:bgs_control/features/uikit/texel_button.dart';
import 'package:flutter/material.dart';

class InvitationToConnectScreen extends StatefulWidget {
  const InvitationToConnectScreen({
    super.key,
    required this.title,
  });

  final String title;

  @override
  State<InvitationToConnectScreen> createState() =>
      _InvitationToConnectScreenState();
}

class _InvitationToConnectScreenState extends State<InvitationToConnectScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      //   title: Text(widget.title),
      // ),
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
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text(''),
                  const Spacer(),
                  Text(
                    'Подключите стимулятор к электроду и включите на нем питание, после чего нажмите кнопку "Подключить" ниже',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodySmall,
                  ),
                  const SizedBox(height: 10),
                  Center(
                    child:
                    TexelButton.accent(
                      onPressed: () {
                        MaterialPageRoute route = MaterialPageRoute(
                          builder: (context) => const SelectDeviceScreen(
                            title: 'Мои стимуляторы',
                          ),
                          settings: const RouteSettings(name: '/select'),
                        );
                        Navigator.of(context).push(route);
                      },
                      text: 'Подключить',
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
