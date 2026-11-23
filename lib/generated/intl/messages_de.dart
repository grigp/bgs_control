// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a de locale. All the
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
  String get localeName => 'de';

  static String m0(numStage) =>
      "Für Stufe ${numStage} wurde kein Name eingegeben";

  static String m1(appName) => "Anwendung: ${appName}";

  static String m2(version, buildNumber) => "Version ${version}+${buildNumber}";

  static String m3(appVersion) => "Version: ${appVersion}";

  static String m4(stage) => "Stufe \'${stage}\' aus der Methode löschen?";

  static String m5(cnt) =>
      "Es sind ${cnt} Einträge in der Datenbank. Ergebnisse in der Datenbank speichern?";

  static String m6(buildNumber) => "Build: ${buildNumber}";

  static String m7(deviceName) => "Verbindung zum Stimulator ${deviceName}";

  static String m8(progName) => "Methode ${progName} löschen?";

  static String m9(duration) => "Dauer: ${duration} min";

  static String m10(dvcName) => "Stimulator ${dvcName}";

  static String m11(shortDeviceName) => "Elektrostimulator ${shortDeviceName}";

  static String m12(sFN) => "Firmware-Version: ${sFN}";

  static String m13(frequency) => "${frequency} Hz";

  static String m14(average) => "Durchschnitt = ${average}";

  static String m15(duration) => "Dauer = ${duration}";

  static String m16(max) => "Maximum = ${max}";

  static String m17(playingTime) => "Verstrichene Zeit - ${playingTime}";

  static String m18(programTitle) => "Programm ${programTitle}";

  static String m19(idxStage, stageComment) =>
      "Stufe ${idxStage} : ${stageComment}";

  static String m20(idxStage, nameStage) => "Stufe ${idxStage} : ${nameStage}";

  static String m21(stageNum) => "Stufe ${stageNum}";

  static String m22(stageTime, duration) => "${stageTime} von ${duration}";

  static String m23(stimulatorNumber) =>
      "Elektrostimulator texel Nr. ${stimulatorNumber}";

  static String m24(timeRemain) => "Verbleibende Zeit ${timeRemain}";

  static String m25(sTUD, sTC) => "Arbeitsdauer: ${sTUD} ${sTC}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "Connect": MessageLookupByLibrary.simpleMessage("Verbinden"),
        "History": MessageLookupByLibrary.simpleMessage("Verlauf"),
        "InputElectrodeType":
            MessageLookupByLibrary.simpleMessage("Elektrodentyp eingeben"),
        "InputRecomendations":
            MessageLookupByLibrary.simpleMessage("Empfehlungen eingeben"),
        "InputStageName":
            MessageLookupByLibrary.simpleMessage("Stufenname eingeben"),
        "InputStimulAreases": MessageLookupByLibrary.simpleMessage(
            "Stimulationsbereiche eingeben"),
        "InputTime": MessageLookupByLibrary.simpleMessage("Zeit eingeben"),
        "InputTimeTotal_min_sec": MessageLookupByLibrary.simpleMessage(
            "Geben Sie die vollständige Zeit ein (mm:ss)"),
        "MethodDescription":
            MessageLookupByLibrary.simpleMessage("Beschreibung"),
        "MethodName": MessageLookupByLibrary.simpleMessage("Name der Methode"),
        "MinutesOutOfBound":
            MessageLookupByLibrary.simpleMessage("Maximal 99 Minuten"),
        "PersonalMethods":
            MessageLookupByLibrary.simpleMessage("Eigene Methoden"),
        "SecondsOutOfBounds": MessageLookupByLibrary.simpleMessage(
            "Es gibt keine Zeit über 59 Sekunden"),
        "ShouldInputAnyStages": MessageLookupByLibrary.simpleMessage(
            "Es muss mindestens eine Stufe vorhanden sein"),
        "ShouldInputProgramName": MessageLookupByLibrary.simpleMessage(
            "Der Programmname muss eingegeben werden"),
        "ShouldIntputStageName": m0,
        "Stages": MessageLookupByLibrary.simpleMessage("Stufen"),
        "TheStimulatorNeedsToBeCharged": MessageLookupByLibrary.simpleMessage(
            "Der Stimulator muss aufgeladen werden"),
        "Time_mm_ss": MessageLookupByLibrary.simpleMessage("Zeit (mm:ss)"),
        "addMethod": MessageLookupByLibrary.simpleMessage("Methode hinzufügen"),
        "addStage": MessageLookupByLibrary.simpleMessage("Stufe hinzufügen"),
        "addStimulator":
            MessageLookupByLibrary.simpleMessage("Stimulator hinzufügen"),
        "allList": MessageLookupByLibrary.simpleMessage("Gesamte Liste"),
        "amplitudeModulation":
            MessageLookupByLibrary.simpleMessage("Amplitudenmodulation"),
        "amplitudeModulationAM":
            MessageLookupByLibrary.simpleMessage("Amplitudenmod. (AM)"),
        "appName": m1,
        "appVersion": m2,
        "appVersion1": m3,
        "areasStimulation":
            MessageLookupByLibrary.simpleMessage("Stimulationsbereiche: "),
        "askClearLog":
            MessageLookupByLibrary.simpleMessage("Protokolldaten löschen?"),
        "askContinueInterrupted": MessageLookupByLibrary.simpleMessage(
            "Ausführung der unterbrochenen Methode fortsetzen?"),
        "askDeleteStageFromProgram": m4,
        "askExitProgram":
            MessageLookupByLibrary.simpleMessage("Programm beenden?"),
        "askRunCustomMethodic":
            MessageLookupByLibrary.simpleMessage("Eigene Methode ausführen?"),
        "askSafeLevel": MessageLookupByLibrary.simpleMessage(
            "Eine Erhöhung der Stimulationsleistung kann unsicher sein.\nStimulationsleistung weiter erhöhen?"),
        "askSwitchToOfflineMode": MessageLookupByLibrary.simpleMessage(
            "In den Offline-Modus wechseln?"),
        "askToSaveResults": m5,
        "attention": MessageLookupByLibrary.simpleMessage("Achtung"),
        "availableMethodics":
            MessageLookupByLibrary.simpleMessage("Verfügbare Methoden"),
        "averageStimulationPower": MessageLookupByLibrary.simpleMessage(
            "Durchschnittliche Stimulationsleistung"),
        "beforeConnectDescription": MessageLookupByLibrary.simpleMessage(
            "Schalten Sie den Stimulator ein, legen Sie ihn auf die Magnetkontakte der Elektrode und drücken Sie die Taste"),
        "buildNumber": m6,
        "byCategories": MessageLookupByLibrary.simpleMessage("Nach Kategorien"),
        "cancel": MessageLookupByLibrary.simpleMessage("Abbrechen"),
        "cancelProgramExecution": MessageLookupByLibrary.simpleMessage(
            "Programmausführung abbrechen?"),
        "clear": MessageLookupByLibrary.simpleMessage("Leeren"),
        "close": MessageLookupByLibrary.simpleMessage("Schließen"),
        "compatibleElectrodeTypes": MessageLookupByLibrary.simpleMessage(
            "Kompatible Elektrodentypen: "),
        "connectToStimulator": m7,
        "contraindications": MessageLookupByLibrary.simpleMessage(
            "- Bei Kindern;\n- Während der Schwangerschaft;\n- Am Kopf, am Herzen und an großen Gefäßen; bei Krampfadern, Thrombose und Thrombophlebitis; bei offenen und geschlossenen Blutungen; bei Verletzungen von Knochen, Nerven, Muskeln, Sehnen und Weichteilen; bei Hernien und Gewebevorwölbungen; bei Hautschäden und -erkrankungen (einschließlich Nävi (Muttermale));\n- Bei Personen mit instabiler psychischer Gesundheit;\n- Bei Personen mit Epilepsie, Herzschrittmachern (künstlichen Schrittmachern), akuten ischämischen und hämorrhagischen Läsionen des Gehirns und Herzens sowie onkologischen Erkrankungen;\n- Bei allergischen Reaktionen;\n- Beim Führen von Fahrzeugen, Bedienen von Maschinen oder elektrischen Geräten;\n- Wenn das Gerät beschädigt ist.\n\nNach dem Eingriff ist eine kurzzeitige Rötung im Behandlungsbereich möglich. Vermeiden Sie Schmerzen und Unbehagen. Verwenden Sie die Elektrode nicht auf trockenen leitfähigen Oberflächen."),
        "dataExchangeLog":
            MessageLookupByLibrary.simpleMessage("Datenübertragungsprotokoll"),
        "delSeance": MessageLookupByLibrary.simpleMessage("Sitzung löschen"),
        "delete": MessageLookupByLibrary.simpleMessage("Löschen"),
        "deleteMethod": MessageLookupByLibrary.simpleMessage("Methode löschen"),
        "deleteStimulatorFromList": MessageLookupByLibrary.simpleMessage(
            "Stimulator aus der Liste entfernen?"),
        "deleteUserProgram": m8,
        "disconnect": MessageLookupByLibrary.simpleMessage("Trennen"),
        "durationMin": m9,
        "durationMmSs": MessageLookupByLibrary.simpleMessage("Dauer, min:sek"),
        "dvcName": m10,
        "editMethod":
            MessageLookupByLibrary.simpleMessage("Methode bearbeiten"),
        "electrostimulationShouldNeverBeUsed":
            MessageLookupByLibrary.simpleMessage(
                "Elektrostimulation darf niemals angewendet werden:"),
        "electrostimulatorTexelN": m11,
        "electrostimulatorsTexel":
            MessageLookupByLibrary.simpleMessage("Elektrostimulatoren texel"),
        "exit": MessageLookupByLibrary.simpleMessage("Fertig"),
        "failedToConnect": MessageLookupByLibrary.simpleMessage(
            "Verbindung zum Stimulator fehlgeschlagen"),
        "firmwareNumber": m12,
        "freeMethodic": MessageLookupByLibrary.simpleMessage("Eigene Methode"),
        "freeMethodicDescription": MessageLookupByLibrary.simpleMessage(
            "Manuelle Steuerung des Stimulationsmodus"),
        "frequency": MessageLookupByLibrary.simpleMessage("Frequenz"),
        "frequencyModulation":
            MessageLookupByLibrary.simpleMessage("Frequenzmodulation"),
        "frequencyModulationFM":
            MessageLookupByLibrary.simpleMessage("Frequenzmod. (FM)"),
        "frequencyValue": m13,
        "frrequencyHZ": MessageLookupByLibrary.simpleMessage("Frequenz, Hz"),
        "goBack": MessageLookupByLibrary.simpleMessage("< Zurück"),
        "havingContraindications": MessageLookupByLibrary.simpleMessage(
            "es bestehen Kontraindikationen"),
        "hh_mm_ss": MessageLookupByLibrary.simpleMessage("hh:mm:ss"),
        "histAverage": m14,
        "histDuration": m15,
        "histMax": m16,
        "inputMethodDescription": MessageLookupByLibrary.simpleMessage(
            "Beschreibung der Methode eingeben"),
        "inputMethodName":
            MessageLookupByLibrary.simpleMessage("Name der Methode eingeben"),
        "intensity": MessageLookupByLibrary.simpleMessage("Intensität"),
        "interruptProgramExecution": MessageLookupByLibrary.simpleMessage(
            "Programmausführung unterbrechen?"),
        "itIsClear": MessageLookupByLibrary.simpleMessage("Alles klar"),
        "lowLevelBattery": MessageLookupByLibrary.simpleMessage(
            "Schwacher Akku.\nDer Stimulator kann jederzeit abschalten"),
        "maximumStimulationPower": MessageLookupByLibrary.simpleMessage(
            "Maximale Stimulationsleistung"),
        "met1_areases":
            MessageLookupByLibrary.simpleMessage("Gelenke der Arme und Beine"),
        "met1_attr0": MessageLookupByLibrary.simpleMessage("Gelenke"),
        "met1_description": MessageLookupByLibrary.simpleMessage(
            "Ein Zustand lang anhaltenden Unbehagens im Gelenkbereich, sowohl bei Bewegung als auch in Ruhe"),
        "met1_electrods": MessageLookupByLibrary.simpleMessage(
            "Knöchel, Knie, Schulter, Handgelenk"),
        "met1_recomendations": MessageLookupByLibrary.simpleMessage(
            "Beginnen Sie mit dem Gelenk, das dem Bereich des Unbehagens symmetrisch gegenüberliegt. Wenn beide Gelenke betroffen sind, behandeln Sie zuerst das Gelenk mit dem geringsten Unbehagen. In der zweiten Stufe versetzen Sie die Elektrode an das andere Gelenk."),
        "met1_stage0": MessageLookupByLibrary.simpleMessage(
            "Vorbereitung auf die Behandlung"),
        "met1_stage1":
            MessageLookupByLibrary.simpleMessage("Aufwärmen der Muskeln"),
        "met1_stage2": MessageLookupByLibrary.simpleMessage("Muskelbehandlung"),
        "met1_stage3":
            MessageLookupByLibrary.simpleMessage("Festigung der Ergebnisse"),
        "met1_title": MessageLookupByLibrary.simpleMessage(
            "Gelenke. Periodisches leichtes Unbehagen (chronisch)"),
        "mm_ss": MessageLookupByLibrary.simpleMessage("mm:ss"),
        "msgDisconnect": MessageLookupByLibrary.simpleMessage(
            "Der Stimulator wurde aufgrund von Verbindungsproblemen getrennt.\nBringen Sie Ihr Telefon näher an den Stimulator und verbinden Sie ihn erneut"),
        "myStimulators":
            MessageLookupByLibrary.simpleMessage("Meine Stimulatoren"),
        "no": MessageLookupByLibrary.simpleMessage("Nein"),
        "notDefined": MessageLookupByLibrary.simpleMessage("Nicht definiert"),
        "ok": MessageLookupByLibrary.simpleMessage("OK"),
        "personalMode":
            MessageLookupByLibrary.simpleMessage("Persönlicher Modus"),
        "personalModeDescription": MessageLookupByLibrary.simpleMessage(
            "Betriebsmodus des Stimulators mit individuellen Einstellungen"),
        "playingTime": m17,
        "previousDevices":
            MessageLookupByLibrary.simpleMessage("Frühere Geräte"),
        "programExecutionTime":
            MessageLookupByLibrary.simpleMessage("Programmlaufzeit"),
        "programTitle": m18,
        "recommendationsForProcedure": MessageLookupByLibrary.simpleMessage(
            "Empfehlungen für das Verfahren:"),
        "run": MessageLookupByLibrary.simpleMessage("Starten"),
        "save": MessageLookupByLibrary.simpleMessage("Ergebnisse speichern"),
        "searchStimulators":
            MessageLookupByLibrary.simpleMessage("Stimulatoren suchen"),
        "select": MessageLookupByLibrary.simpleMessage("Auswählen"),
        "selectMethodic":
            MessageLookupByLibrary.simpleMessage("Methode auswählen"),
        "sessionCompleted": MessageLookupByLibrary.simpleMessage(
            "Die Sitzung ist abgeschlossen"),
        "settings": MessageLookupByLibrary.simpleMessage("Einstellungen"),
        "share": MessageLookupByLibrary.simpleMessage("Teilen"),
        "stageDuration":
            MessageLookupByLibrary.simpleMessage("Dauer der Stufe"),
        "stageIdxComment": m19,
        "stageIdxNamestage": m20,
        "stageName": MessageLookupByLibrary.simpleMessage("Name der Stufe"),
        "stageNum": m21,
        "stageTmeDuration": m22,
        "start": MessageLookupByLibrary.simpleMessage("Start"),
        "stimulationWillBeContinue": MessageLookupByLibrary.simpleMessage(
            "Die Stimulation wird fortgesetzt"),
        "stimulatorSettings":
            MessageLookupByLibrary.simpleMessage("Stimulator-Einstellungen"),
        "stimulatorTurnedOffLowBattery": MessageLookupByLibrary.simpleMessage(
            "Der Stimulator wurde wegen schwachem Akku ausgeschaltet."),
        "texelStimulatorNumber": m23,
        "time": MessageLookupByLibrary.simpleMessage("Zeit"),
        "timeRemain": m24,
        "toGoMode": MessageLookupByLibrary.simpleMessage(
            "In den Offline-Modus wechseln"),
        "tryAgain": MessageLookupByLibrary.simpleMessage(
            "Bitte versuchen Sie es erneut"),
        "turnObBluetooth": MessageLookupByLibrary.simpleMessage(
            "Schalten Sie Bluetooth ein, um den Stimulator zu verbinden"),
        "turnOn": MessageLookupByLibrary.simpleMessage("Einschalten"),
        "warning": MessageLookupByLibrary.simpleMessage("Warnung"),
        "workDuration": m25,
        "yes": MessageLookupByLibrary.simpleMessage("Ja")
      };
}
