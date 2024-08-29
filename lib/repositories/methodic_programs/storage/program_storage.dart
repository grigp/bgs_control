import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

import '../model/methodic_program.dart';

/// Класс, предоставляющий доступ к списку доступных программ
class ProgramStorage {

  List<dynamic>? _listPPWork = [];
  List<MethodicProgram> _listPrograms = [];

  void init() async {
    await _fillWorkList();
  }

  /// Возвращает список доступных программ
  Future<List<MethodicProgram>> getPrograms() async {
    return _listPrograms;
  }

  /// Заполняет рабочий список программ в файле
  Future _fillWorkList() async {
    /// Список программ по умолчанию
    String dataDef =
        await rootBundle.loadString('lib/assets/programs/prg_main.json');
    var dd = json.decode(dataDef);
    final listPPDef = dd['programs'] as List<dynamic>?;

    /// Список программ из рабочего файла
    final dir = await getExternalStorageDirectory();
    var f = File('${dir?.path}/programs.json');
    if (await f.exists()) {
      await f.readAsString().then((String dataWork) {
        var dd = json.decode(dataWork);
        _listPPWork = dd['programs'] as List<dynamic>?;
      });
    }

    /// Добавление в спсисок программ рабочего файла отсутствующих в нем программ,
    /// но имеющихся в дефолтном
    int n = 0;
    for (int i = 0; i < listPPDef!.length; ++i) {
      if (!_isProgramExists(_listPPWork!, listPPDef[i]['id'])) {
        _listPPWork?.add(listPPDef[i]);
        ++n;
      }
    }

    /// Записать в файл
    String sp = '{"programs": ${json.encode(_listPPWork)}}';
    await File('${dir?.path}/programs.json').writeAsString(sp);

    _listPrograms.clear();
    for (int i = 0; i < _listPPWork!.length; ++i){
      var program = MethodicProgram.fromJson(_listPPWork![i]);
      _listPrograms.add(program);
    }
  }

  /// Возвращает true, если в списке list имеется программа с заданным id
  bool _isProgramExists(List<dynamic> list, int id) {
    for (int i = 0; i < list.length; ++i) {
      if (list[i]['id'] == id) {
        return true;
      }
    }
    return false;
  }
}
