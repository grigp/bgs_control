// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a ru locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'ru';

  static String m0(appName) => "Приложение: ${appName}";

  static String m1(version, buildNumber) => "Версия ${version}+${buildNumber}";

  static String m2(appVersion) => "Версия: ${appVersion}";

  static String m3(buildNumber) => "Сборка:${buildNumber}";

  static String m4(dvcName) => "Стимулятор ${dvcName}";

  static String m5(sFN) => "Номер прошивки: ${sFN}";

  static String m6(sTUD, sTC) => "Время работы: ${sTUD} ${sTC}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "Connect": MessageLookupByLibrary.simpleMessage("Подключить"),
        "addStimulator":
            MessageLookupByLibrary.simpleMessage("Добавить стимулятор"),
        "appName": m0,
        "appVersion": m1,
        "appVersion1": m2,
        "askContinueInterrupted": MessageLookupByLibrary.simpleMessage(
            "Продолжить выполнение прерванной программы?"),
        "askExitProgram":
            MessageLookupByLibrary.simpleMessage("Выйти из программы?"),
        "beforeConnectDescription": MessageLookupByLibrary.simpleMessage(
            "Включите стимулятор, установите его на магнитные контакты электрода и нажмите кнопку"),
        "buildNumber": m3,
        "cancel": MessageLookupByLibrary.simpleMessage("Отмена"),
        "dataExchangeLog":
            MessageLookupByLibrary.simpleMessage("Лог обмена данными"),
        "delete": MessageLookupByLibrary.simpleMessage("Удалить"),
        "deleteStimulatorFromList": MessageLookupByLibrary.simpleMessage(
            "Удалить стимулятор из списка?"),
        "disconnect": MessageLookupByLibrary.simpleMessage("Отключить"),
        "dvcName": m4,
        "firmwareNumber": m5,
        "hh_mm_ss": MessageLookupByLibrary.simpleMessage("чч:мм:сс"),
        "mm_ss": MessageLookupByLibrary.simpleMessage("мм:сс"),
        "msgDisconnect": MessageLookupByLibrary.simpleMessage(
            "Произошло отключение от стимулятора из за проблем со связью.\nПоднесите телефон ближе к стимулятору и подключите его заново"),
        "myStimulators":
            MessageLookupByLibrary.simpleMessage("Мои стимуляторы"),
        "no": MessageLookupByLibrary.simpleMessage("Нет"),
        "ok": MessageLookupByLibrary.simpleMessage("OK"),
        "previousDevices":
            MessageLookupByLibrary.simpleMessage("Подключенные ранее"),
        "searchStimulators":
            MessageLookupByLibrary.simpleMessage("Поиск стимуляторов"),
        "select": MessageLookupByLibrary.simpleMessage("Выбрать"),
        "selectMethodic":
            MessageLookupByLibrary.simpleMessage("Выбор программы"),
        "settings": MessageLookupByLibrary.simpleMessage("Свойства"),
        "stimulatorSettings":
            MessageLookupByLibrary.simpleMessage("Параметры стимулятора"),
        "warning": MessageLookupByLibrary.simpleMessage("Предупреждение"),
        "workDuration": m6,
        "yes": MessageLookupByLibrary.simpleMessage("Да")
      };
}
