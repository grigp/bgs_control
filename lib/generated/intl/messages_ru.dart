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

  static String m5(duration) => "Длительность: ${duration} мин";

  static String m6(dvcName) => "Стимулятор ${dvcName}";

  static String m7(shortDeviceName) => "Электростимулятор ${shortDeviceName}";

  static String m8(sFN) => "Номер прошивки: ${sFN}";

  static String m9(frequency) => "${frequency} Hz";

  static String m10(playingTime) => "Прошло времени - ${playingTime}";

  static String m11(programTitle) => "Программа ${programTitle}";

  static String m12(idxStage, stageComment) =>
      "Этап ${idxStage} : ${stageComment}";

  static String m13(idxStage, nameStage) => "Этап ${idxStage} : ${nameStage}";

  static String m14(stageNum) => "Стадия ${stageNum}";

  static String m15(stageTime, duration) => "${stageTime} из ${duration}";

  static String m16(stimulatorNumber) =>
      "Электростимулятор texel №${stimulatorNumber}";

  static String m17(timeRemain) => "До завершения осталось ${timeRemain}";

  static String m18(sTUD, sTC) => "Время работы: ${sTUD} ${sTC}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "Connect": MessageLookupByLibrary.simpleMessage("Подключить"),
        "TheStimulatorNeedsToBeCharged": MessageLookupByLibrary.simpleMessage(
            "Необходимо зарядить стимулятор"),
        "addStimulator":
            MessageLookupByLibrary.simpleMessage("Добавить стимулятор"),
        "allList": MessageLookupByLibrary.simpleMessage("Весь список"),
        "amplitudeModulation":
            MessageLookupByLibrary.simpleMessage("Амплитудная модуляция"),
        "amplitudeModulationAM":
            MessageLookupByLibrary.simpleMessage("Ампл. модуляция (AM)"),
        "appName": m0,
        "appVersion": m1,
        "appVersion1": m2,
        "areasStimulation":
            MessageLookupByLibrary.simpleMessage("Области воздействия: "),
        "askClearLog": MessageLookupByLibrary.simpleMessage("Очистить лог?"),
        "askContinueInterrupted": MessageLookupByLibrary.simpleMessage(
            "Продолжить выполнение прерванной программы?"),
        "askExitProgram":
            MessageLookupByLibrary.simpleMessage("Выйти из программы?"),
        "askRunCustomMethodic": MessageLookupByLibrary.simpleMessage(
            "Запустить выполнение произвольной программы?"),
        "askSafeLevel": MessageLookupByLibrary.simpleMessage(
            "Увеличение мощности воздействия может быть небезопасным.\nПродолжить увеличение мощности воздействия?"),
        "askSwitchToOfflineMode": MessageLookupByLibrary.simpleMessage(
            "Перейти в режим автономной работы?"),
        "attention": MessageLookupByLibrary.simpleMessage("Внимание"),
        "availableMethodics":
            MessageLookupByLibrary.simpleMessage("Доступные программы"),
        "averageStimulationPower":
            MessageLookupByLibrary.simpleMessage("Средний уровень воздействия"),
        "beforeConnectDescription": MessageLookupByLibrary.simpleMessage(
            "Включите стимулятор, установите его на магнитные контакты электрода и нажмите кнопку"),
        "buildNumber": m3,
        "byCategories": MessageLookupByLibrary.simpleMessage("По категориям"),
        "cancel": MessageLookupByLibrary.simpleMessage("Отмена"),
        "cancelProgramExecution": MessageLookupByLibrary.simpleMessage(
            "Отменить выполнение программы?"),
        "clear": MessageLookupByLibrary.simpleMessage("Очистить"),
        "close": MessageLookupByLibrary.simpleMessage("Закрыть"),
        "compatibleElectrodeTypes": MessageLookupByLibrary.simpleMessage(
            "Совместимые типы электродов: "),
        "connectToStimulator": m4,
        "contraindications": MessageLookupByLibrary.simpleMessage(
            "- Для детей;\n- Во время беременности;\n- На область головы, сердца, крупных сосудов, при варикозном расширении вен, тромбозе, тромбофлебите; при открытых и закрытых кровотечениях, травмах костей, нервов, мышц, сухожилий и мягких тканей, грыжах и выпячиваниях тканей; при поражениях и заболеваниях кожи (включая невусы (родимые пятна));\n- Лицам с нестабильным психическим состоянием;\n- Лицам с эпилепсией, кардиостимуляторами (искусственными кардиостимуляторами), острыми ишемическими и геморрагическими поражениями тканей головного и сердца, а также онкологическими заболеваниями;\n- При аллергических реакциях;\n- При управлении транспортными средствами, работе с механизмами или электрооборудованием;\n- При нарушении целостности устройства.\n\nПосле процедуры возможно кратковременное покраснение в области обработки. Избегайте боли и дискомфорта. Не используйте электрод на сухих проводящих поверхностях."),
        "dataExchangeLog":
            MessageLookupByLibrary.simpleMessage("Лог обмена данными"),
        "delete": MessageLookupByLibrary.simpleMessage("Удалить"),
        "deleteStimulatorFromList": MessageLookupByLibrary.simpleMessage(
            "Удалить стимулятор из списка?"),
        "disconnect": MessageLookupByLibrary.simpleMessage("Отключить"),
        "durationMin": m5,
        "durationMmSs":
            MessageLookupByLibrary.simpleMessage("Продолжительность, мин:сек"),
        "dvcName": m6,
        "electrostimulationShouldNeverBeUsed":
            MessageLookupByLibrary.simpleMessage(
                "Элетростимуляция никогда не должна применяться:"),
        "electrostimulatorTexelN": m7,
        "electrostimulatorsTexel":
            MessageLookupByLibrary.simpleMessage("Электростимуляторы texel"),
        "exit": MessageLookupByLibrary.simpleMessage("Выйти"),
        "failedToConnect": MessageLookupByLibrary.simpleMessage(
            "Не удалось подключиться к стимулятору"),
        "firmwareNumber": m8,
        "freeMethodic":
            MessageLookupByLibrary.simpleMessage("Произвольная программа"),
        "freeMethodicDescription": MessageLookupByLibrary.simpleMessage(
            "Ручное управление режимом воздействия"),
        "frequency": MessageLookupByLibrary.simpleMessage("Частота"),
        "frequencyModulation":
            MessageLookupByLibrary.simpleMessage("Частотная модуляция"),
        "frequencyModulationFM":
            MessageLookupByLibrary.simpleMessage("Част. модуляция (FM)"),
        "frequencyValue": m9,
        "frrequencyHZ": MessageLookupByLibrary.simpleMessage("Частота, Гц"),
        "goBack": MessageLookupByLibrary.simpleMessage("< Назад"),
        "havingContraindications":
            MessageLookupByLibrary.simpleMessage("имеются противопоказания"),
        "hh_mm_ss": MessageLookupByLibrary.simpleMessage("чч:мм:сс"),
        "intensity": MessageLookupByLibrary.simpleMessage("Интенсивность"),
        "interruptProgramExecution":
            MessageLookupByLibrary.simpleMessage("Прервать воздействие?"),
        "itIsClear": MessageLookupByLibrary.simpleMessage("Понятно"),
        "lowLevelBattery": MessageLookupByLibrary.simpleMessage(
            "Низкий заряд аккумулятора.\nСтимулятор может отключиться в любой момент"),
        "maximumStimulationPower": MessageLookupByLibrary.simpleMessage(
            "Максимальный уровень воздействия"),
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
        "playingTime": m10,
        "previousDevices":
            MessageLookupByLibrary.simpleMessage("Подключенные ранее"),
        "programExecutionTime":
            MessageLookupByLibrary.simpleMessage("Время выполнения программы"),
        "programTitle": m11,
        "recommendationsForProcedure": MessageLookupByLibrary.simpleMessage(
            "Рекомендации по проведению процедуры:\n"),
        "run": MessageLookupByLibrary.simpleMessage("Запустить"),
        "searchStimulators":
            MessageLookupByLibrary.simpleMessage("Поиск стимуляторов"),
        "select": MessageLookupByLibrary.simpleMessage("Выбрать"),
        "selectMethodic":
            MessageLookupByLibrary.simpleMessage("Выбор программы"),
        "sessionCompleted":
            MessageLookupByLibrary.simpleMessage("Сеанс завершен"),
        "settings": MessageLookupByLibrary.simpleMessage("Свойства"),
        "share": MessageLookupByLibrary.simpleMessage("Поделиться"),
        "stageIdxComment": m12,
        "stageIdxNamestage": m13,
        "stageNum": m14,
        "stageTmeDuration": m15,
        "start": MessageLookupByLibrary.simpleMessage("Начать"),
        "stimulationWillBeContinue": MessageLookupByLibrary.simpleMessage(
            "При этом воздействие будет продолжено"),
        "stimulatorSettings":
            MessageLookupByLibrary.simpleMessage("Параметры стимулятора"),
        "stimulatorTurnedOffLowBattery": MessageLookupByLibrary.simpleMessage(
            "Стимулятор отключился из за низкого заряда аккумулятора."),
        "texelStimulatorNumber": m16,
        "time": MessageLookupByLibrary.simpleMessage("Time"),
        "timeRemain": m17,
        "toGoMode": MessageLookupByLibrary.simpleMessage("Работать автономно"),
        "tryAgain": MessageLookupByLibrary.simpleMessage(
            "Попробуйте повторить попытку"),
        "turnObBluetooth": MessageLookupByLibrary.simpleMessage(
            "Включите Bluetooth, чтобы подключить стимулятор"),
        "turnOn": MessageLookupByLibrary.simpleMessage("Включить"),
        "warning": MessageLookupByLibrary.simpleMessage("Предупреждение"),
        "workDuration": m18,
        "yes": MessageLookupByLibrary.simpleMessage("Да")
      };
}
