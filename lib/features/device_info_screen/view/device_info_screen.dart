import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../../assets/colors/colors.dart';
import '../../../generated/l10n.dart';
import '../../../repositories/bgs_property_storage/bgs_property_storage.dart';
import '../../../utils/baseutils.dart';
import '../../uikit/widgets/back_screen_button.dart';

class DeviceInfoScreen extends StatefulWidget{
  const DeviceInfoScreen({
    super.key,
    required this.title,
    required this.dvcName,
  });

  final String title;
  final String dvcName;

  @override
  State<DeviceInfoScreen> createState() => _DeviceInfoScreenState();
}

class _DeviceInfoScreenState extends State<DeviceInfoScreen> {
  String _sDN = '';
  String _sFN = '';
  String _sTC = '';
  String _sTUD = '';

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

    _getDeviceParams(widget.dvcName);
    _initPackageInfo();

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            Column(
              children: [
                Container(
                  color: white,
                  child: Image.asset('images/device.png'),
                ),
                Expanded(
                  child: ListView(
                    // TODO (yasliks):  если список небольшой и возникает ошибка констрента, можно юзать shrinkWrap: true и Expanded
                    shrinkWrap: true,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                    ),
                    children: [
                      Text(
                        S.of(context).dvcName(getShortDeviceName(widget.dvcName)),
//                        'Стимулятор ${getShortDeviceName(widget.dvcName)}',
                        style: const TextStyle(fontSize: 24),
                        textScaler: const TextScaler.linear(1.0),
                      ),
                      const Divider(),
                      // Text(  Номер не нужен. Пока закомментировал, ибо ветер может подуть с другого направления
                      //   'Номер стимулятора: $_sDN',
                      //   style: const TextStyle(fontSize: 20),
                      //   textScaler: const TextScaler.linear(1.0),
                      //   textAlign: TextAlign.left,
                      // ),
                      // const Divider(),
                      Text(
                        S.of(context).firmwareNumber(_sFN),
//                        'Номер прошивки: $_sFN',
                        style: const TextStyle(fontSize: 20),
                        textScaler: const TextScaler.linear(1.0),
                      ),
                      const Divider(),
                      Text(
                        S.of(context).workDuration(_sTUD, _sTC),
//                        'Время работы: $_sTUD $_sTC',
                        style: const TextStyle(fontSize: 20),
                        textScaler: const TextScaler.linear(1.0),
                      ),
                      const Divider(),
                      const SizedBox(height: 20),
                      Text(
                        S.of(context).appName(_packageInfo.appName),
//                        'Приложение: ${_packageInfo.appName}',
                        style: const TextStyle(fontSize: 24),
                        textScaler: const TextScaler.linear(1.0),
                      ),
                      const Divider(),
                      Text(
                        S.of(context).appVersion1(_packageInfo.version),
//                        'Версия: ${_packageInfo.version}',
                        style: const TextStyle(fontSize: 20),
                        textScaler: const TextScaler.linear(1.0),
                      ),
                      const Divider(),
                      Text(
                        S.of(context).buildNumber(_packageInfo.buildNumber),
//                        'Сборка: ${_packageInfo.buildNumber}',
                        style: const TextStyle(fontSize: 20),
                        textScaler: const TextScaler.linear(1.0),
                      ),
                      const Divider(),
                    ],
                  ),
                ),
              ],
            ),
            Positioned(
              top: 10,
              left: 10,
              child: BackScreenButton(
                onBack: () {
                  Navigator.pop(context);
                },
                hasBackground: true,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future _getDeviceParams(String dvcName) async {
    /// Получим параметры стимулятора. Главное - время работы
    var dp = await GetIt.I<BgsPropertyStorage>().getProperty(dvcName);
    setState(() {
      _sFN = '${dp.firmwareNumber}';
      _sTC = S.of(context).mm_ss;
      if (dp.timeUseDevice > 3600) {
        _sTC = S.of(context).hh_mm_ss;
      }
      _sTUD = getTimeBySecCount(dp.timeUseDevice);
    });
  }

  Future<void> _initPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      _packageInfo = info;
    });
  }

}