
import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

/// Класс данных о стимуляторе БГС
class BgsProperty {
  BgsProperty({
    required this.bgsName,
    required this.deviceNumber,
    required this.firmwareNumber,
    required this.timeUseDevice,
  });

  /// Конструктор из json
  factory BgsProperty.fromJson(dynamic data) {
    ///Разбор методики в json
    /// Сначала сам объект с заголовочными полями
    var retval = BgsProperty(
      bgsName: data['bgs'].toString(),
      deviceNumber: data['dvc_number'],
      firmwareNumber: data['fwr_number'],
      timeUseDevice:  data['time_use_dvc'],
    );

    return retval;
  }

  static Map<String, dynamic> toJson(BgsProperty value) =>
      {'bgs': value.bgsName,
        'dvc_number': value.deviceNumber,
        'fwr_number': value.firmwareNumber,
        'time_use_dvc': value.timeUseDevice,
      };


  String bgsName;
  int deviceNumber;
  int firmwareNumber;
  int timeUseDevice;
}

/// Класс хранилища данных о свойствах стмуляторов
class BgsPropertyStorage {
  final List<BgsProperty> _listBgs = [];


  void saveProperty(BgsProperty data) async {
    await _fillListBgs();

    bool fnd = false;
    for (int i = 0; i < _listBgs.length; ++i) {
      if (_listBgs[i].bgsName == data.bgsName) {
        _listBgs[i].deviceNumber = data.deviceNumber;
        _listBgs[i].firmwareNumber = data.firmwareNumber;
        _listBgs[i].timeUseDevice = data.timeUseDevice;
        fnd = true;
        break;
      }
    }

    if (!fnd) {
      _listBgs.add(data);
    }


    List<Map<String, dynamic>> list = [];
    for (int i = 0; i < _listBgs.length; ++i) {
      var objBgs = BgsProperty.toJson(_listBgs[i]);
      list.add(objBgs);
    }
    Map<String, dynamic> root = {'bgs': list};
    print('>>>>>>>>>>>>>>>>>> ${json.encode(root)}');

    final dir = Platform.isAndroid
        ? await getExternalStorageDirectory()
        : await getApplicationSupportDirectory();

    var f = File('${dir?.path}/bgs_properties.json');
    await f.writeAsString(json.encode(root));
  }

  Future<BgsProperty> getProperty(String bgsName) async {
    await _fillListBgs();

    for (int i = 0; i < _listBgs.length; ++i) {
      if (_listBgs[i].bgsName == bgsName) {
        return BgsProperty(
            bgsName: bgsName,
            deviceNumber: _listBgs[i].deviceNumber,
            firmwareNumber: _listBgs[i].firmwareNumber,
            timeUseDevice: _listBgs[i].timeUseDevice,
        );
      }
    }

    return BgsProperty(
        bgsName: '',
        deviceNumber: 0,
        firmwareNumber: 0,
        timeUseDevice: 0
    );
  }

  Future _fillListBgs() async {
    final dir = Platform.isAndroid
        ? await getExternalStorageDirectory()
        : await getApplicationSupportDirectory();

    var f = File('${dir?.path}/bgs_properties.json');
    if (await f.exists()) {
      await f.readAsString().then((String dataWork) {
        var dd = json.decode(dataWork);
        final listPPDef = dd['bgs'] as List<dynamic>?;

        for (int i = 0; i < listPPDef!.length; ++i) {
          var program = BgsProperty.fromJson(listPPDef[i]);
          _listBgs.add(program);
        }
      });
    }

  }



}