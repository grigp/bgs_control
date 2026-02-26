import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

import '../model/methodic_program.dart';

/// Класс, предоставляющий доступ к списку доступных программ
class ProgramStorage {
  final List<MethodicProgram> _listPrograms = [];
  late int _currentSelectProgramPage = 0;

  void init() async {
    await _fillWorkList();
    _readCurrentPageFromFile();
  }

  /// Возвращает список доступных программ
  List<MethodicProgram> getPrograms() {
    return _listPrograms;
  }

  /// Возвращает программу по ее id
  MethodicProgram getProgram(String methId) {
    for (int i = 0; i < _listPrograms.length; ++i) {
      if (_listPrograms[i].uid == methId) return _listPrograms[i];
    }
    return MethodicProgram(
        uid: '',
        statsTitle: '',
        title: '',
        description: '',
        image: '',
        mpk: MethodicProgramKind.mpkNormal);
  }

  /// Заполняет рабочий список программ, беря его из предустановленного файла json
  Future _fillWorkList() async {
    /// Список программ по умолчанию
    String dataDef = await rootBundle.loadString(
      'lib/assets/programs/prg_main.json',
    );
    var dd = json.decode(dataDef);
    final listPPDef = dd['programs'] as List<dynamic>?;

    _listPrograms.clear();
    for (int i = 0; i < listPPDef!.length; ++i) {
      var program = MethodicProgram.fromJson(listPPDef[i]);

      /// Добавляем программы, имеющие аттрибут debug только в debug режиме
      if ((!kDebugMode && !program.attributes.contains('debug')) ||
          kDebugMode) {
        _listPrograms.add(program);
      }
    }
  }

  ///// Заполняет рабочий список программ в файле
  // Future _fillWorkList() async {
  //   /// Список программ по умолчанию
  //   String dataDef = await rootBundle.loadString(
  //     'lib/assets/programs/prg_main.json',
  //   );
  //   var dd = json.decode(dataDef);
  //   final listPPDef = dd['programs'] as List<dynamic>?;
  //
  //   /// Список программ из рабочего файла
  //   final dir = Platform.isAndroid
  //       ? await getExternalStorageDirectory()
  //       : await getApplicationSupportDirectory();
  //
  //   ///-------------------------------------------------------------------
  //   ///Закомментировать этот участок, если надо полностью обновить рабочий файл
  //   /// из дефолтного списка доступных программ
  //   var f = File('${dir?.path}/programs.json');
  //   if (await f.exists()) {
  //     await f.readAsString().then((String dataWork) {
  //       var dd = json.decode(dataWork);
  //       _listPPWork = dd['programs'] as List<dynamic>?;
  //     });
  //   }
  //
  //   ///-------------------------------------------------------------------
  //
  //   /// Добавление в спсисок программ рабочего файла отсутствующих в нем программ,
  //   /// но имеющихся в дефолтном
  //   int n = 0;
  //   for (int i = 0; i < listPPDef!.length; ++i) {
  //     if (!_isProgramExists(_listPPWork!, listPPDef[i]['id'])) {
  //       _listPPWork?.add(listPPDef[i]);
  //       ++n;
  //     }
  //   }
  //
  //   /// Записать в файл
  //   String sp = '{"programs": ${json.encode(_listPPWork)}}';
  //   await File('${dir?.path}/programs.json').writeAsString(sp);
  //
  //   _listPrograms.clear();
  //   for (int i = 0; i < _listPPWork!.length; ++i) {
  //     var program = MethodicProgram.fromJson(_listPPWork![i]);
  //     _listPrograms.add(program);
  //   }
  // }

  /// Возвращает true, если в списке list имеется программа с заданным id
  bool _isProgramExists(List<dynamic> list, int id) {
    for (int i = 0; i < list.length; ++i) {
      if (list[i]['id'] == id) {
        return true;
      }
    }
    return false;
  }

  /// Записывает текущую страницу PageView в файл
  void writeCurrentPageToFile(int idx) async {
    final dir = Platform.isAndroid
        ? await getExternalStorageDirectory()
        : await getApplicationSupportDirectory();

    /// Записать в файл
    String sp = '${idx}';
    await File('${dir?.path}/select_programs.ini').writeAsString(sp);
  }

  /// Читает текущую страницу PageView из файла
  void _readCurrentPageFromFile() async {
    final dir = Platform.isAndroid
        ? await getExternalStorageDirectory()
        : await getApplicationSupportDirectory();

    var f = File('${dir?.path}/select_programs.ini');
    if (await f.exists()) {
      await f.readAsString().then((String sIdx) {
        int idx = int.parse(sIdx);
        _currentSelectProgramPage = idx;
      });
    }
  }

  int getCurrentSelectProgramPage() {
    return _currentSelectProgramPage;
  }
}
