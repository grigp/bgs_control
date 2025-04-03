import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Класс списка стимуляторов, подключавшихся когда - либо к программе
/// Содержит списиок в параметрах FlutterSecureStorage в виде:
/// BG_0025 BG_0032 BG_0042 BG_0050
class BgsList {
  BgsList() {
    _init();
  }

  List<String> _list = [];

  void _init() async {
    const storage = FlutterSecureStorage();
    String? sList = await storage.read(key: 'bgs_list');
    if (sList != null && sList != '') {
      _list = sList.split(' ');
    }
  }

  Future _save() async {
    const storage = FlutterSecureStorage();
    var s = '';
    for (int i = 0; i < _list.length; ++i) {
      if (i == 0) {
        s = _list[i];
      } else {
        if (s != '') {
          s = '$s ${_list[i]}';
        } else {
          s = _list[i];
        }
      }
    }
    await storage.write(key: 'bgs_list', value: s);
  }

  void add(String bgsName) {
    if (!isContains(bgsName)) {
      _list.add(bgsName);
      _save();
    }
  }

  Future delete(String bgsName) async {
    _list.remove(bgsName);
    await _save();
  }

  bool isContains(String bgsName) {
    return _list.contains(bgsName);
  }

  List<String> getList() {
    return _list;
  }
}
