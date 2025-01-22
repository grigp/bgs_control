import 'dart:async';
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
      timeUseDevice: data['time_use_dvc'],
    );

    return retval;
  }

  static Map<String, dynamic> toJson(BgsProperty value) => {
        'bgs': value.bgsName,
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
/// НЕЛЬЗЯ ОБЪЕДИНЯТЬ С bgs_list, ибо там можно легко редактировать
/// и длительность использования будет забываться
class BgsPropertyStorage {
  final List<BgsProperty> _listBgs = [];

  /// Сохраняет свойства стимулятора и добавляет его в список при отсутствии
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

    await _saveListBgs();
  }

  /// Запрашивает параметры стимулятора
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
        bgsName: '', deviceNumber: 0, firmwareNumber: 0, timeUseDevice: 0);
  }

  Future add(String bgsName) async {
    await _fillListBgs();

    bool fnd = false;
    for (int i = 0; i < _listBgs.length; ++i) {
      if (_listBgs[i].bgsName == bgsName) {
        fnd = true;
        break;
      }
    }

    if (!fnd) {
      _listBgs.add(BgsProperty(
        bgsName: bgsName,
        deviceNumber: 0,
        firmwareNumber: 0,
        timeUseDevice: 0,
      ));
    }

    await _saveListBgs();
  }

  /// Возвращает true, если стимулятор есть в списке
  Future<bool> isContains(String bgsName) async {
    await _fillListBgs();

    for (int i = 0; i < _listBgs.length; ++i) {
      if (_listBgs[i].bgsName == bgsName) {
        return true;
      }
    }
    return false;
  }

  /// Удаляет стимулятор из списка
  Future delete(String bgsName) async {
    await _fillListBgs();

    for (int i = 0; i < _listBgs.length; ++i) {
      if (_listBgs[i].bgsName == bgsName) {
        _listBgs.removeAt(i);
        break;
      }
    }

    await _saveListBgs();
  }

  /// Возвращает список подключенных стимуляторов в формате списка строк
  Future<List<String>> getList() async {
    await _fillListBgs();

    List<String> retval = [];
    for (int i = 0; i < _listBgs.length; ++i) {
      retval.add(_listBgs[i].bgsName);
    }

    return retval;
  }

  Future _fillListBgs() async {
    _listBgs.clear();

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

  Future _saveListBgs() async {
    List<Map<String, dynamic>> list = [];
    for (int i = 0; i < _listBgs.length; ++i) {
      var objBgs = BgsProperty.toJson(_listBgs[i]);
      list.add(objBgs);
    }
    Map<String, dynamic> root = {'bgs': list};

    final dir = Platform.isAndroid
        ? await getExternalStorageDirectory()
        : await getApplicationSupportDirectory();

    var f = File('${dir?.path}/bgs_properties.json');
    await f.writeAsString(json.encode(root));
  }
}
