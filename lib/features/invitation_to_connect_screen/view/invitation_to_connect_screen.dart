import 'package:bgs_control/features/select_device_screen/view/select_device_screen.dart';
import 'package:bgs_control/features/uikit/texel_button.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../../assets/colors/colors.dart';
import '../../../utils/baseutils.dart';
import '../../../generated/l10n.dart';

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
  PackageInfo _packageInfo = PackageInfo(
    appName: '',
    packageName: '',
    version: '',
    buildNumber: '',
    buildSignature: '',
    installerStore: '',
  );

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: backgroundTestColor,
      body: Padding(
        padding: const EdgeInsets.only(top: 0),
        child: SafeArea(
          bottom: false,
          child: Center(
            child: Stack(
              children: [
                Column(
                  children: [
                    Container(
                      width: double.infinity,
                      color: backgroundTestColor,
                      child: Image.asset(
                        'images/invitation.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Spacer(),
                    Row(
                      children: [
                        const Spacer(),
                        Text(
                            S.of(context).appVersion(_packageInfo.version, _packageInfo.buildNumber)),
                        // Text(
                        //     'Версия ${_packageInfo.version}+${_packageInfo.buildNumber}'),
                        const SizedBox(width: 10),
                      ],
                    ),
                    Container(
                      color: Colors.white,
                      child: SafeArea(
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            children: [
                              const SizedBox(height: 16),
                              Text(
                                S.of(context).beforeConnectDescription,
                                textAlign: TextAlign.center,
                                style: theme.textTheme.bodyMedium,
                              ),
                              const SizedBox(height: 16),
                              Center(
                                child: TexelButton.accent(
                                  onPressed: () {
                                    pushScreen(
                                      context,
                                      (context, animation,
                                              secondaryAnimation) =>
                                          SelectDeviceScreen(
                                        title: S.of(context).myStimulators,
                                      ),
                                      '/select',
                                      ShiftDirection.rightToLeft,
                                    );
                                  },
                                  text: S.of(context).Connect,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _initPackageInfo();
  }

  Future<void> _initPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      _packageInfo = info;
    });
  }
}
