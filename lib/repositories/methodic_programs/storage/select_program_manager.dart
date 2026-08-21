import 'dart:convert';
import 'dart:ui';

import 'package:flutter/services.dart';

import '../model/select_item_info.dart';

/// Класс, предоставляющий доступ к дереву выбора программы
class SelectProgramManager {
  final List<SelectItemInfo> _listItems = [];

  void init() async {
    await _fillWorkList();
  }

  /// Заполняет рабочий список программ, беря его из предустановленного файла json
  Future _fillWorkList() async {
    Locale deviceLocale = PlatformDispatcher.instance.locale;

    String selPrgMenuFilePath = 'lib/assets/programs/select_prg.json';
    if (deviceLocale.languageCode == 'ru') {
      selPrgMenuFilePath = 'lib/assets/programs/select_prg.json';
    } else if (deviceLocale.languageCode == 'en') {
      selPrgMenuFilePath = 'lib/assets/programs/select_prg_en.json';
    }

    /// Список программ по умолчанию
    String dataDef = await rootBundle.loadString(selPrgMenuFilePath);
    var dd = json.decode(dataDef);
    final listItemsDef = dd['items'] as List<dynamic>?;

    _listItems.clear();
    for (int i = 0; i < listItemsDef!.length; ++i) {
      var item = SelectItemInfo.fromJson(listItemsDef[i]);
      _listItems.add(item);
    }
  }

  /// Возвращает список итемов по заданному предку
  List<SelectItemInfo> getItemsByParent(int parent)  {
    List<SelectItemInfo> retval = [];
    for (int i = 0; i < _listItems.length; ++i) {
      if (_listItems[i].parent == parent) {
        retval.add(SelectItemInfo(
          nodeType: _listItems[i].nodeType,
          id:  _listItems[i].id,
          parent: _listItems[i].parent,
          title: _listItems[i].title,
          description: _listItems[i].description,
          icon: _listItems[i].icon,
          methodicId: _listItems[i].methodicId,
        ));
      }
    }
    return retval;
  }
}
