import 'package:bgs_control/features/select_device_screen/view/select_device_screen.dart';
import 'package:bgs_control/utils/styles.dart';
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
                  const Text(
                    'Для перехода к выбору устройства и подключению к нему включите питание на устройстве и нажмите кнопку "Выбрать" ниже',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        MaterialPageRoute route = MaterialPageRoute(
                          builder: (context) => const SelectDeviceScreen(
                            title: 'Выбор устройства',
                          ),
                          settings: const RouteSettings(name: '/select'),
                        );
                        Navigator.of(context).push(route);
                      },
                      style: controlButtonStylePrimary,
                      child: const Text(
                        'Выбрать',
                        style: TextStyle(fontSize: 18),
                      ),
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
