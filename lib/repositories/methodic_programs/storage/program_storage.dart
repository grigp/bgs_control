import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

import '../model/methodic_program.dart';

/// Класс, предоставляющий доступ к списку доступных программ
class ProgramStorage {
  final List<MethodicProgram> _listPrograms = [];
  late int _currentSelectProgramPage = 0;

  Future<void> init() async {
    await _fillWorkList();
    await _readCurrentPageFromFile();
  }

  /// Возвращает список доступных программ
  List<MethodicProgram> getPrograms() {
    return _listPrograms;
  }

  /// Возвращает программу по ее id
  MethodicProgram getProgram(String methId) {
    for (int i = 0; i < _listPrograms.length; ++i) {
      if (_listPrograms[i].uid == methId) {
        return MethodicProgram.copy(_listPrograms[i]);
      }
    }
    return MethodicProgram(
      uid: '',
      statsTitle: '',
      title: '',
      description: '',
      electrods: "",
      areases: "",
      recomendations: "",
      image: '',
      mpk: MethodicProgramKind.mpkNormal,
      isDefault: false,
    );
  }

  /// Добавить пользовательскую программу
  void addUserProgram(MethodicProgram program) {
    program.uid = _getNextProgramUid();
    program.image = 'man.png';
    _listPrograms.add(program);
    _saveUserPrograms();
  }

  /// Изменить пользовательскую программу
  void editUserProgram(MethodicProgram program) {
    for (int i = 0; i < _listPrograms.length; ++i) {
      if (_listPrograms[i].uid == program.uid) {
        _listPrograms[i].title = program.title;
        _listPrograms[i].description = program.description;
        _listPrograms[i].electrods = program.electrods;
        _listPrograms[i].areases = program.areases;
        _listPrograms[i].recomendations = program.recomendations;

        _listPrograms[i].clearStages();
        for (int j = 0; j < program.stagesCount(); ++j) {
          _listPrograms[i].newStage();
          var stage = program.stage(j);
          _listPrograms[i].setStageComment(j, stage.comment);
          _listPrograms[i].setStageDuration(j, stage.duration);
          _listPrograms[i].setStageIsAm(j, stage.isAm);
          _listPrograms[i].setStageAmMode(j, stage.amMode);
          _listPrograms[i].setStageIsFm(j, stage.isFm);
          _listPrograms[i].setStageFrequency(j, stage.frequency);
          _listPrograms[i].setStageIntensivity(j, stage.intensivity);
        }
      }
    }
    _saveUserPrograms();
  }

  /// Удалить пользовательскую программу
  void delUserProgram(String prgUid) {
    for (int i = 0; i < _listPrograms.length; ++i) {
      if (_listPrograms[i].uid == prgUid) {
        _listPrograms.removeAt(i);
      }
    }
    _saveUserPrograms();
  }

  /// Сохраняет пользовательские программы стимуляции в отдельном файле
  void _saveUserPrograms() async {
    List<Map<String, dynamic>> programs = [];
    for (int i = 0; i < _listPrograms.length; ++i) {
      /// Сохраняем только программы, введенные пользователем (isDefault == false)
      if (!_listPrograms[i].isDefault) {
        var jsonProgram = _listPrograms[i].toJson();
        programs.add(jsonProgram);
      }
    }

    Map<String, dynamic> jsonPrograms = {
      'programs' : programs,
    };
    var strJsonPrograms = jsonEncode(jsonPrograms);

    final dir = Platform.isAndroid
        ? await getExternalStorageDirectory()
        : await getApplicationSupportDirectory();

    final file = File('${dir?.path}/user_programs.json');
    await file.writeAsString(strJsonPrograms);

    // print('');
    // print('');
    // print('<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>');
    // print('$jsonPrograms');
    // print('<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>');
    // print('');
    // print('');
  }

  /// Заполняет рабочий список программ, беря его из предустановленного файла json
  Future _fillWorkList() async {
    Locale deviceLocale = PlatformDispatcher.instance.locale;
    if (kDebugMode) {
      print('<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>');
      print('${deviceLocale.languageCode}_${deviceLocale.countryCode}');
      print('<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>');
    }

    /// Список программ по умолчанию
    String methodicFilePath = 'lib/assets/programs/prg_main.json';
    if (deviceLocale.languageCode == 'ru') {
      methodicFilePath = 'lib/assets/programs/prg_main.json';
    } else if (deviceLocale.languageCode == 'en') {
      methodicFilePath = 'lib/assets/programs/prg_main_en.json';
    } else if (deviceLocale.languageCode == 'de') {
      methodicFilePath = 'lib/assets/programs/prg_main_de.json';
    }
    String dataDef = await rootBundle.loadString(methodicFilePath);

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

    /// Чтение пользовательских программ
    final dir = Platform.isAndroid
        ? await getExternalStorageDirectory()
        : await getApplicationSupportDirectory();

    var f = File('${dir?.path}/user_programs.json');
    if (await f.exists()) {
      await f.readAsString().then((String sJsonProgram) {
        var dd = json.decode(sJsonProgram);
        final listPPDef = dd['programs'] as List<dynamic>?;

        for (int i = 0; i < listPPDef!.length; ++i) {
          var program = MethodicProgram.fromJson(listPPDef[i]);
          _listPrograms.add(program);
        }
      });
    }
  }

  /// Возвращает следующий свободный uid в списке методик
  String _getNextProgramUid() {
    /// Ищем максимальный занятый
    int iu = -1;
    for (int i = 0; i < _listPrograms.length; ++i) {
      String suid = _listPrograms[i].uid;
      int? uid = int.tryParse(suid);
      if (uid! > iu) {
        iu = uid;
      }
    }

    /// Если он допустим, то возратим его + 1
    if (iu < 256) {
      return '${iu + 1}';
    }
    /// А если нет, то 255 - макс. для байта
    return '255';
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
  Future<void> _readCurrentPageFromFile() async {
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
