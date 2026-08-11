// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
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
  String get localeName => 'en';

  static String m0(appName) => "Application: ${appName}";

  static String m1(version, buildNumber) => "Version ${version}+${buildNumber}";

  static String m2(appVersion) => "Version: ${appVersion}";

  static String m3(buildNumber) => "Build:${buildNumber}";

  static String m4(deviceName) => "Connectiong to the stimulator ${deviceName}";

  static String m5(dvcName) => "Stimulator ${dvcName}";

  static String m6(sFN) => "Firmware number: ${sFN}";

  static String m7(frequency) => "${frequency} Гц";

  static String m8(playingTime) => "Time passed - ${playingTime}";

  static String m9(programTitle) => "Программа ${programTitle}";

  static String m10(idxStage, stageComment) =>
      "Stage ${idxStage} : ${stageComment}";

  static String m11(idxStage, nameStage) => "Stage ${idxStage} : ${nameStage}";

  static String m12(stageNum) => "Stage ${stageNum}";

  static String m13(stageTime, duration) => "${stageTime} out of ${duration}";

  static String m14(timeRemain) => "Time remaining ${timeRemain}";

  static String m15(sTUD, sTC) => "Work duration: ${sTUD} ${sTC}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "Connect": MessageLookupByLibrary.simpleMessage("Connect"),
        "addStimulator": MessageLookupByLibrary.simpleMessage("Add stimulator"),
        "allList": MessageLookupByLibrary.simpleMessage("All the list"),
        "amplitudeModulation":
            MessageLookupByLibrary.simpleMessage("Amplitude modulation"),
        "appName": m0,
        "appVersion": m1,
        "appVersion1": m2,
        "areasStimulation":
            MessageLookupByLibrary.simpleMessage("Areas of stimulation: "),
        "askContinueInterrupted": MessageLookupByLibrary.simpleMessage(
            "Continue execution of the interrupted methodic?"),
        "askExitProgram":
            MessageLookupByLibrary.simpleMessage("Exit the program?"),
        "askRunCustomMethodic":
            MessageLookupByLibrary.simpleMessage("Run a custom methodic?"),
        "askSwitchToOfflineMode":
            MessageLookupByLibrary.simpleMessage("Switch to offline mode?"),
        "availableMethodics":
            MessageLookupByLibrary.simpleMessage("Available methodics"),
        "beforeConnectDescription": MessageLookupByLibrary.simpleMessage(
            "Turn the stimulator on, place it on the magnetic contacts of the electrode and press the button"),
        "buildNumber": m3,
        "byCategories": MessageLookupByLibrary.simpleMessage("By categories"),
        "cancel": MessageLookupByLibrary.simpleMessage("Cancel"),
        "cancelProgramExecution":
            MessageLookupByLibrary.simpleMessage("Cancel program execution?"),
        "compatibleElectrodeTypes": MessageLookupByLibrary.simpleMessage(
            "Compatible electrode types: "),
        "connectToStimulator": m4,
        "dataExchangeLog":
            MessageLookupByLibrary.simpleMessage("Data exchange log"),
        "delete": MessageLookupByLibrary.simpleMessage("Delete"),
        "deleteStimulatorFromList": MessageLookupByLibrary.simpleMessage(
            "Remove stimulator from the list?"),
        "disconnect": MessageLookupByLibrary.simpleMessage("Disconnect"),
        "dvcName": m5,
        "failedToConnect": MessageLookupByLibrary.simpleMessage(
            "Failed to connect to the stimulator"),
        "firmwareNumber": m6,
        "freeMethodic": MessageLookupByLibrary.simpleMessage("Custom methodic"),
        "freeMethodicDescription": MessageLookupByLibrary.simpleMessage(
            "Manual control of the stimulation mode"),
        "frequency": MessageLookupByLibrary.simpleMessage("Frequency"),
        "frequencyModulation":
            MessageLookupByLibrary.simpleMessage("Frequency modulation"),
        "frequencyValue": m7,
        "goBack": MessageLookupByLibrary.simpleMessage("< Back"),
        "hh_mm_ss": MessageLookupByLibrary.simpleMessage("hh:mm:ss"),
        "intensity": MessageLookupByLibrary.simpleMessage("Intensity"),
        "interruptProgramExecution": MessageLookupByLibrary.simpleMessage(
            "Interrupt program execution?"),
        "lowLevelBattery": MessageLookupByLibrary.simpleMessage(
            "Low battery.\nThe stimulator may shut off at any time"),
        "mm_ss": MessageLookupByLibrary.simpleMessage("mm:ss"),
        "msgDisconnect": MessageLookupByLibrary.simpleMessage(
            "The stimulator disconnected due to connection issues.\nBring your phone closer to the stimulator and reconnect"),
        "myStimulators": MessageLookupByLibrary.simpleMessage("My stimulators"),
        "no": MessageLookupByLibrary.simpleMessage("No"),
        "notDefined": MessageLookupByLibrary.simpleMessage("Not defined"),
        "ok": MessageLookupByLibrary.simpleMessage("OK"),
        "personalMode": MessageLookupByLibrary.simpleMessage("Personal mode"),
        "personalModeDescription": MessageLookupByLibrary.simpleMessage(
            "Stimulator operating mode with individual settings"),
        "playingTime": m8,
        "previousDevices":
            MessageLookupByLibrary.simpleMessage("Previous devices"),
        "programExecutionTime":
            MessageLookupByLibrary.simpleMessage("Program execution time"),
        "programTitle": m9,
        "recommendationsForProcedure": MessageLookupByLibrary.simpleMessage(
            "Recommendations for the procedure:\n"),
        "searchStimulators":
            MessageLookupByLibrary.simpleMessage("Search for stimulators"),
        "select": MessageLookupByLibrary.simpleMessage("Select"),
        "selectMethodic":
            MessageLookupByLibrary.simpleMessage("Select methodic"),
        "settings": MessageLookupByLibrary.simpleMessage("Settings"),
        "stageIdxComment": m10,
        "stageIdxNamestage": m11,
        "stageNum": m12,
        "stageTmeDuration": m13,
        "start": MessageLookupByLibrary.simpleMessage("Start"),
        "stimulationWillBeContinue": MessageLookupByLibrary.simpleMessage(
            "The stimulation will be continue"),
        "stimulatorSettings":
            MessageLookupByLibrary.simpleMessage("Stimulator settings"),
        "time": MessageLookupByLibrary.simpleMessage("Time"),
        "timeRemain": m14,
        "toGoMode": MessageLookupByLibrary.simpleMessage("Go to offline mode"),
        "tryAgain": MessageLookupByLibrary.simpleMessage("Please try again"),
        "warning": MessageLookupByLibrary.simpleMessage("Warning"),
        "workDuration": m15,
        "yes": MessageLookupByLibrary.simpleMessage("Yes")
      };
}
