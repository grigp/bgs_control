import 'package:bgs_control/features/select_device_screen/view/select_device_screen.dart';
import 'package:flutter/material.dart';


class InvitationToConnectScreen extends StatefulWidget {
  const InvitationToConnectScreen({super.key, required this.title});
  final String title;

  @override
  State<InvitationToConnectScreen> createState() => _InvitationToConnectScreenState();
}

class _InvitationToConnectScreenState extends State<InvitationToConnectScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(''),
              const Spacer(),
              const Text(
                'Отсутствует соединение с устройством. Включите писание на устройстве и нажмите кнопку "Подключить" ниже',
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    MaterialPageRoute route = MaterialPageRoute(
                        builder: (context) => const SelectDeviceScreen(title: 'Выбор устройства',),
                        settings: const RouteSettings(name: '/select'));
                    Navigator.of(context).push(route);
//                    Navigator.of(context).pushNamed('/connect');
                  },
                  style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.teal.shade900,
                      // backgroundColor: Colors.blue.shade900,
                      minimumSize: const Size(350, 55),
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5))
                      )
                  ),
                  child: const Text('Подключить',
                    style: TextStyle(fontSize: 18),),
                ),
              ),
            ],
          ),
        ),

      ),
    );
  }
}
