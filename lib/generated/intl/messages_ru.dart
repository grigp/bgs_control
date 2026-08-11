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

  static String m4(deviceName) => "Подключение к стимулятору ${deviceName}";

  static String m5(dvcName) => "Стимулятор ${dvcName}";

  static String m6(sFN) => "Номер прошивки: ${sFN}";

  static String m7(frequency) => "${frequency} Hz";

  static String m8(playingTime) => "Прошло времени - ${playingTime}";

  static String m9(programTitle) => "Программа ${programTitle}";

  static String m10(idxStage, stageComment) =>
      "Этап ${idxStage} : ${stageComment}";

  static String m11(idxStage, nameStage) => "Этап ${idxStage} : ${nameStage}";

  static String m12(stageNum) => "Стадия ${stageNum}";

  static String m13(stageTime, duration) => "${stageTime} из ${duration}";

  static String m14(timeRemain) => "До завершения осталось ${timeRemain}";

  static String m15(sTUD, sTC) => "Время работы: ${sTUD} ${sTC}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "Connect": MessageLookupByLibrary.simpleMessage("Подключить"),
        "addStimulator":
            MessageLookupByLibrary.simpleMessage("Добавить стимулятор"),
        "allList": MessageLookupByLibrary.simpleMessage("Весь список"),
        "amplitudeModulation":
            MessageLookupByLibrary.simpleMessage("Амплитудная модуляция"),
        "appName": m0,
        "appVersion": m1,
        "appVersion1": m2,
        "areasStimulation":
            MessageLookupByLibrary.simpleMessage("Области воздействия: "),
        "askContinueInterrupted": MessageLookupByLibrary.simpleMessage(
            "Продолжить выполнение прерванной программы?"),
        "askExitProgram":
            MessageLookupByLibrary.simpleMessage("Выйти из программы?"),
        "askRunCustomMethodic": MessageLookupByLibrary.simpleMessage(
            "Запустить выполнение произвольной программы?"),
        "askSwitchToOfflineMode": MessageLookupByLibrary.simpleMessage(
            "Перейти в режим автономной работы?"),
        "availableMethodics":
            MessageLookupByLibrary.simpleMessage("Доступные программы"),
        "beforeConnectDescription": MessageLookupByLibrary.simpleMessage(
            "Включите стимулятор, установите его на магнитные контакты электрода и нажмите кнопку"),
        "buildNumber": m3,
        "byCategories": MessageLookupByLibrary.simpleMessage("По категориям"),
        "cancel": MessageLookupByLibrary.simpleMessage("Отмена"),
        "cancelProgramExecution": MessageLookupByLibrary.simpleMessage(
            "Отменить выполнение программы?"),
        "compatibleElectrodeTypes": MessageLookupByLibrary.simpleMessage(
            "Совместимые типы электродов: "),
        "connectToStimulator": m4,
        "dataExchangeLog":
            MessageLookupByLibrary.simpleMessage("Лог обмена данными"),
        "delete": MessageLookupByLibrary.simpleMessage("Удалить"),
        "deleteStimulatorFromList": MessageLookupByLibrary.simpleMessage(
            "Удалить стимулятор из списка?"),
        "disconnect": MessageLookupByLibrary.simpleMessage("Отключить"),
        "dvcName": m5,
        "failedToConnect": MessageLookupByLibrary.simpleMessage(
            "Не удалось подключиться к стимулятору"),
        "firmwareNumber": m6,
        "freeMethodic":
            MessageLookupByLibrary.simpleMessage("Произвольная программа"),
        "freeMethodicDescription": MessageLookupByLibrary.simpleMessage(
            "Ручное управление режимом воздействия"),
        "frequency": MessageLookupByLibrary.simpleMessage("Частота"),
        "frequencyModulation":
            MessageLookupByLibrary.simpleMessage("Частотная модуляция"),
        "frequencyValue": m7,
        "goBack": MessageLookupByLibrary.simpleMessage("< Назад"),
        "hh_mm_ss": MessageLookupByLibrary.simpleMessage("чч:мм:сс"),
        "intensity": MessageLookupByLibrary.simpleMessage("Интенсивность"),
        "interruptProgramExecution":
            MessageLookupByLibrary.simpleMessage("Прервать воздействие?"),
        "lowLevelBattery": MessageLookupByLibrary.simpleMessage(
            "Низкий заряд аккумулятора.\nСтимулятор может отключиться в любой момент"),
        "mm_ss": MessageLookupByLibrary.simpleMessage("мм:сс"),
        "msgDisconnect": MessageLookupByLibrary.simpleMessage(
            "Произошло отключение от стимулятора из за проблем со связью.\nПоднесите телефон ближе к стимулятору и подключите его заново"),
        "myStimulators":
            MessageLookupByLibrary.simpleMessage("Мои стимуляторы"),
        "no": MessageLookupByLibrary.simpleMessage("Нет"),
        "notDefined": MessageLookupByLibrary.simpleMessage("Не задано"),
        "ok": MessageLookupByLibrary.simpleMessage("OK"),
        "personalMode":
            MessageLookupByLibrary.simpleMessage("Индивидуальный режим"),
        "personalModeDescription": MessageLookupByLibrary.simpleMessage(
            "Режим работы стимулятора с индивидуальными настройками"),
        "playingTime": m8,
        "previousDevices":
            MessageLookupByLibrary.simpleMessage("Подключенные ранее"),
        "programExecutionTime":
            MessageLookupByLibrary.simpleMessage("Время выполнения программы"),
        "programTitle": m9,
        "recommendationsForProcedure": MessageLookupByLibrary.simpleMessage(
            "Рекомендации по проведению процедуры:\n"),
        "searchStimulators":
            MessageLookupByLibrary.simpleMessage("Поиск стимуляторов"),
        "select": MessageLookupByLibrary.simpleMessage("Выбрать"),
        "selectMethodic":
            MessageLookupByLibrary.simpleMessage("Выбор программы"),
        "settings": MessageLookupByLibrary.simpleMessage("Свойства"),
        "stageIdxComment": m10,
        "stageIdxNamestage": m11,
        "stageNum": m12,
        "stageTmeDuration": m13,
        "start": MessageLookupByLibrary.simpleMessage("Начать"),
        "stimulationWillBeContinue": MessageLookupByLibrary.simpleMessage(
            "При этом воздействие будет продолжено"),
        "stimulatorSettings":
            MessageLookupByLibrary.simpleMessage("Параметры стимулятора"),
        "time": MessageLookupByLibrary.simpleMessage("Time"),
        "timeRemain": m14,
        "toGoMode": MessageLookupByLibrary.simpleMessage("Работать автономно"),
        "tryAgain": MessageLookupByLibrary.simpleMessage(
            "Попробуйте повторить попытку"),
        "warning": MessageLookupByLibrary.simpleMessage("Предупреждение"),
        "workDuration": m15,
        "yes": MessageLookupByLibrary.simpleMessage("Да")
      };
}
