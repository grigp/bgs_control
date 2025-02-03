import 'package:bgs_control/features/select_device_screen/view/select_device_screen.dart';
import 'package:bgs_control/features/uikit/texel_button.dart';
import 'package:flutter/material.dart';

import '../../../assets/colors/colors.dart';
import '../../../utils/baseutils.dart';

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
      body: SafeArea(
        child: Center(
          child: Stack(
            children: [
              Column(
                children: [
                  Container(
                    color: backgroundTestColor,
                    child: Image.asset('images/background_woman.png'),
                  ),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Spacer(),
                  Container(
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        children: [
                          Text(
                            'Подключите стимулятор к электроду и включите на нем питание, после чего нажмите кнопку "Подключить" ниже',
                            textAlign: TextAlign.center,
                            style: theme.textTheme.bodySmall,
                          ),
                          const SizedBox(height: 10),
                          Center(
                            child: TexelButton.accent(
                              onPressed: () {
                                pushScreen(
                                  context,
                                  (context, animation, secondaryAnimation) =>
                                      const SelectDeviceScreen(
                                    title: 'Мои стимуляторы',
                                  ),
                                  '/select',
                                  ShiftDirection.rightToLeft,
                                );
                              },
                              text: 'Подключить',
                            ),
                          ),
                        ],
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
