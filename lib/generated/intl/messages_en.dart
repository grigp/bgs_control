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

  static String m5(duration) => "Длительность: ${duration} мин";

  static String m6(dvcName) => "Stimulator ${dvcName}";

  static String m7(shortDeviceName) =>
      "Electrical stimulator ${shortDeviceName}";

  static String m8(sFN) => "Firmware number: ${sFN}";

  static String m9(frequency) => "${frequency} Гц";

  static String m10(playingTime) => "Time passed - ${playingTime}";

  static String m11(programTitle) => "Программа ${programTitle}";

  static String m12(idxStage, stageComment) =>
      "Stage ${idxStage} : ${stageComment}";

  static String m13(idxStage, nameStage) => "Stage ${idxStage} : ${nameStage}";

  static String m14(stageNum) => "Stage ${stageNum}";

  static String m15(stageTime, duration) => "${stageTime} out of ${duration}";

  static String m16(stimulatorNumber) =>
      "Electrical stimulator texel №${stimulatorNumber}";

  static String m17(timeRemain) => "Time remaining ${timeRemain}";

  static String m18(sTUD, sTC) => "Work duration: ${sTUD} ${sTC}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "Connect": MessageLookupByLibrary.simpleMessage("Connect"),
        "TheStimulatorNeedsToBeCharged": MessageLookupByLibrary.simpleMessage(
            "The stimulator needs to be charged"),
        "addStimulator": MessageLookupByLibrary.simpleMessage("Add stimulator"),
        "allList": MessageLookupByLibrary.simpleMessage("All the list"),
        "amplitudeModulation":
            MessageLookupByLibrary.simpleMessage("Amplitude modulation"),
        "amplitudeModulationAM":
            MessageLookupByLibrary.simpleMessage("Ampl. modulation (AM)"),
        "appName": m0,
        "appVersion": m1,
        "appVersion1": m2,
        "areasStimulation":
            MessageLookupByLibrary.simpleMessage("Areas of stimulation: "),
        "askClearLog":
            MessageLookupByLibrary.simpleMessage("Clear the log data?"),
        "askContinueInterrupted": MessageLookupByLibrary.simpleMessage(
            "Continue execution of the interrupted methodic?"),
        "askExitProgram":
            MessageLookupByLibrary.simpleMessage("Exit the program?"),
        "askRunCustomMethodic":
            MessageLookupByLibrary.simpleMessage("Run a custom methodic?"),
        "askSafeLevel": MessageLookupByLibrary.simpleMessage(
            "Increasing the stimulation power may be unsafe.\nContinue increasing the stimulation power?"),
        "askSwitchToOfflineMode":
            MessageLookupByLibrary.simpleMessage("Switch to offline mode?"),
        "attention": MessageLookupByLibrary.simpleMessage("Attention"),
        "availableMethodics":
            MessageLookupByLibrary.simpleMessage("Available methodics"),
        "averageStimulationPower":
            MessageLookupByLibrary.simpleMessage("Average stimulation power"),
        "beforeConnectDescription": MessageLookupByLibrary.simpleMessage(
            "Turn the stimulator on, place it on the magnetic contacts of the electrode and press the button"),
        "buildNumber": m3,
        "byCategories": MessageLookupByLibrary.simpleMessage("By categories"),
        "cancel": MessageLookupByLibrary.simpleMessage("Cancel"),
        "cancelProgramExecution":
            MessageLookupByLibrary.simpleMessage("Cancel program execution?"),
        "clear": MessageLookupByLibrary.simpleMessage("Clear"),
        "close": MessageLookupByLibrary.simpleMessage("Close"),
        "compatibleElectrodeTypes": MessageLookupByLibrary.simpleMessage(
            "Compatible electrode types: "),
        "connectToStimulator": m4,
        "contraindications": MessageLookupByLibrary.simpleMessage(
            "- For children;\n- During pregnancy;\n- On the head, heart, and major vessels; in cases of varicose veins, thrombosis, and thrombophlebitis; in cases of open and closed bleeding; injuries to bones, nerves, muscles, tendons, and soft tissue; hernias and tissue protrusions; in cases of skin lesions and diseases (including nevi (birthmarks));\n- Individuals with unstable mental health;\n- Individuals with epilepsy, pacemakers (artificial pacemakers), acute ischemic and hemorrhagic lesions of the brain and heart, and oncological diseases;\n- In case of allergic reactions;\n- When driving vehicles, operating machinery, or electrical equipment;\n- If the device is damaged.\n\nAfter the procedure, short-term redness in the treatment area is possible. Avoid pain and discomfort. Do not use the electrode on dry conductive surfaces."),
        "dataExchangeLog":
            MessageLookupByLibrary.simpleMessage("Data exchange log"),
        "delete": MessageLookupByLibrary.simpleMessage("Delete"),
        "deleteStimulatorFromList": MessageLookupByLibrary.simpleMessage(
            "Remove stimulator from the list?"),
        "disconnect": MessageLookupByLibrary.simpleMessage("Disconnect"),
        "durationMin": m5,
        "durationMmSs":
            MessageLookupByLibrary.simpleMessage("Duration, min:sec"),
        "dvcName": m6,
        "electrostimulationShouldNeverBeUsed":
            MessageLookupByLibrary.simpleMessage(
                "Electrostimulation should never be used:"),
        "electrostimulatorTexelN": m7,
        "electrostimulatorsTexel": MessageLookupByLibrary.simpleMessage(
            "Electrical stimulators texel"),
        "exit": MessageLookupByLibrary.simpleMessage("Done"),
        "failedToConnect": MessageLookupByLibrary.simpleMessage(
            "Failed to connect to the stimulator"),
        "firmwareNumber": m8,
        "freeMethodic": MessageLookupByLibrary.simpleMessage("Custom methodic"),
        "freeMethodicDescription": MessageLookupByLibrary.simpleMessage(
            "Manual control of the stimulation mode"),
        "frequency": MessageLookupByLibrary.simpleMessage("Frequency"),
        "frequencyModulation":
            MessageLookupByLibrary.simpleMessage("Frequency modulation"),
        "frequencyModulationFM":
            MessageLookupByLibrary.simpleMessage("Freq. modulation (FM)"),
        "frequencyValue": m9,
        "frrequencyHZ": MessageLookupByLibrary.simpleMessage("frequency, Hz"),
        "goBack": MessageLookupByLibrary.simpleMessage("< Back"),
        "havingContraindications":
            MessageLookupByLibrary.simpleMessage("there are contraindications"),
        "hh_mm_ss": MessageLookupByLibrary.simpleMessage("hh:mm:ss"),
        "intensity": MessageLookupByLibrary.simpleMessage("Intensity"),
        "interruptProgramExecution": MessageLookupByLibrary.simpleMessage(
            "Interrupt program execution?"),
        "itIsClear": MessageLookupByLibrary.simpleMessage("It\'s clear"),
        "lowLevelBattery": MessageLookupByLibrary.simpleMessage(
            "Low battery.\nThe stimulator may shut off at any time"),
        "maximumStimulationPower":
            MessageLookupByLibrary.simpleMessage("Maximum stimulation power"),
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
        "playingTime": m10,
        "previousDevices":
            MessageLookupByLibrary.simpleMessage("Previous devices"),
        "programExecutionTime":
            MessageLookupByLibrary.simpleMessage("Program execution time"),
        "programTitle": m11,
        "recommendationsForProcedure": MessageLookupByLibrary.simpleMessage(
            "Recommendations for the procedure:\n"),
        "run": MessageLookupByLibrary.simpleMessage("Run"),
        "searchStimulators":
            MessageLookupByLibrary.simpleMessage("Search for stimulators"),
        "select": MessageLookupByLibrary.simpleMessage("Select"),
        "selectMethodic":
            MessageLookupByLibrary.simpleMessage("Select methodic"),
        "sessionCompleted":
            MessageLookupByLibrary.simpleMessage("The session has completed"),
        "settings": MessageLookupByLibrary.simpleMessage("Settings"),
        "share": MessageLookupByLibrary.simpleMessage("Share"),
        "stageIdxComment": m12,
        "stageIdxNamestage": m13,
        "stageNum": m14,
        "stageTmeDuration": m15,
        "start": MessageLookupByLibrary.simpleMessage("Start"),
        "stimulationWillBeContinue": MessageLookupByLibrary.simpleMessage(
            "The stimulation will be continue"),
        "stimulatorSettings":
            MessageLookupByLibrary.simpleMessage("Stimulator settings"),
        "stimulatorTurnedOffLowBattery": MessageLookupByLibrary.simpleMessage(
            "The stimulator turned off due to low battery."),
        "texelStimulatorNumber": m16,
        "time": MessageLookupByLibrary.simpleMessage("Time"),
        "timeRemain": m17,
        "toGoMode": MessageLookupByLibrary.simpleMessage("Go to offline mode"),
        "tryAgain": MessageLookupByLibrary.simpleMessage("Please try again"),
        "turnObBluetooth": MessageLookupByLibrary.simpleMessage(
            "Turn on Bluetooth to connect the stimulator"),
        "turnOn": MessageLookupByLibrary.simpleMessage("Turn On"),
        "warning": MessageLookupByLibrary.simpleMessage("Warning"),
        "workDuration": m18,
        "yes": MessageLookupByLibrary.simpleMessage("Yes")
      };
}
