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

  static String m0(version, buildNumber) => "Version ${version}+${buildNumber}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "Connect": MessageLookupByLibrary.simpleMessage("Connect"),
        "addStimulator": MessageLookupByLibrary.simpleMessage("Add stimulator"),
        "appVersion": m0,
        "askContinueInterrupted": MessageLookupByLibrary.simpleMessage(
            "Continue execution of the interrupted methodic?"),
        "askExitProgram":
            MessageLookupByLibrary.simpleMessage("Exit the program?"),
        "beforeConnectDescription": MessageLookupByLibrary.simpleMessage(
            "Turn the stimulator on, place it on the magnetic contacts of the electrode and press the button"),
        "cancel": MessageLookupByLibrary.simpleMessage("Cancel"),
        "dataExchangeLog":
            MessageLookupByLibrary.simpleMessage("Data exchange log"),
        "delete": MessageLookupByLibrary.simpleMessage("Delete"),
        "deleteStimulatorFromList": MessageLookupByLibrary.simpleMessage(
            "Remove stimulator from the list?"),
        "disconnect": MessageLookupByLibrary.simpleMessage("Disconnect"),
        "msgDisconnect": MessageLookupByLibrary.simpleMessage(
            "The stimulator disconnected due to connection issues.\nBring your phone closer to the stimulator and reconnect"),
        "myStimulators": MessageLookupByLibrary.simpleMessage("My stimulators"),
        "no": MessageLookupByLibrary.simpleMessage("No"),
        "ok": MessageLookupByLibrary.simpleMessage("OK"),
        "previousDevices":
            MessageLookupByLibrary.simpleMessage("Previous devices"),
        "searchStimulators":
            MessageLookupByLibrary.simpleMessage("Search for stimulators"),
        "select": MessageLookupByLibrary.simpleMessage("Select"),
        "selectMethodic":
            MessageLookupByLibrary.simpleMessage("Select methodic"),
        "settings": MessageLookupByLibrary.simpleMessage("Settings"),
        "stimulatorSettings":
            MessageLookupByLibrary.simpleMessage("Stimulator settings"),
        "warning": MessageLookupByLibrary.simpleMessage("Warning"),
        "yes": MessageLookupByLibrary.simpleMessage("Yes")
      };
}
