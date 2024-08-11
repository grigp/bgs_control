import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class BgsList {
  BgsList() {
    _init();
  }

  List<String> _list = [];

  void _init() async {
    const storage = FlutterSecureStorage();
    String? sList = await storage.read(key: 'bgs_list');
    if (sList != null) {
      _list = sList.split(' ');
    }
  }

  void _save() async {
    const storage = FlutterSecureStorage();
    var s = '';
    for (int i = 0; i < _list.length; ++i) {
      if (i == 0) {
        s = _list[i];
      } else {
        s = '$s ${_list[i]}';
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

  void delete(String bgsName) {
    _list.remove(bgsName);
    _save();
  }

  bool isContains(String bgsName) {
    return _list.contains(bgsName);
  }

  List<String> getList() {
    return _list;
  }
}
