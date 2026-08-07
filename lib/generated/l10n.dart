// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Connect`
  String get Connect {
    return Intl.message(
      'Connect',
      name: 'Connect',
      desc: '',
      args: [],
    );
  }

  /// `Version {version}+{buildNumber}`
  String appVersion(Object version, Object buildNumber) {
    return Intl.message(
      'Version $version+$buildNumber',
      name: 'appVersion',
      desc: '',
      args: [version, buildNumber],
    );
  }

  /// `Turn the stimulator on, place it on the magnetic contacts of the electrode and press the button`
  String get beforeConnectDescription {
    return Intl.message(
      'Turn the stimulator on, place it on the magnetic contacts of the electrode and press the button',
      name: 'beforeConnectDescription',
      desc: '',
      args: [],
    );
  }

  /// `Data exchange log`
  String get dataExchangeLog {
    return Intl.message(
      'Data exchange log',
      name: 'dataExchangeLog',
      desc: '',
      args: [],
    );
  }

  /// `Previous devices`
  String get previousDevices {
    return Intl.message(
      'Previous devices',
      name: 'previousDevices',
      desc: '',
      args: [],
    );
  }

  /// `Search for stimulators`
  String get searchStimulators {
    return Intl.message(
      'Search for stimulators',
      name: 'searchStimulators',
      desc: '',
      args: [],
    );
  }

  /// `Add stimulator`
  String get addStimulator {
    return Intl.message(
      'Add stimulator',
      name: 'addStimulator',
      desc: '',
      args: [],
    );
  }

  /// `Select methodic`
  String get selectMethodic {
    return Intl.message(
      'Select methodic',
      name: 'selectMethodic',
      desc: '',
      args: [],
    );
  }

  /// `Continue execution of the interrupted methodic?`
  String get askContinueInterrupted {
    return Intl.message(
      'Continue execution of the interrupted methodic?',
      name: 'askContinueInterrupted',
      desc: '',
      args: [],
    );
  }

  /// `No`
  String get no {
    return Intl.message(
      'No',
      name: 'no',
      desc: '',
      args: [],
    );
  }

  /// `Yes`
  String get yes {
    return Intl.message(
      'Yes',
      name: 'yes',
      desc: '',
      args: [],
    );
  }

  /// `Remove stimulator from the list?`
  String get deleteStimulatorFromList {
    return Intl.message(
      'Remove stimulator from the list?',
      name: 'deleteStimulatorFromList',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get cancel {
    return Intl.message(
      'Cancel',
      name: 'cancel',
      desc: '',
      args: [],
    );
  }

  /// `OK`
  String get ok {
    return Intl.message(
      'OK',
      name: 'ok',
      desc: '',
      args: [],
    );
  }

  /// `Stimulator settings`
  String get stimulatorSettings {
    return Intl.message(
      'Stimulator settings',
      name: 'stimulatorSettings',
      desc: '',
      args: [],
    );
  }

  /// `Exit the program?`
  String get askExitProgram {
    return Intl.message(
      'Exit the program?',
      name: 'askExitProgram',
      desc: '',
      args: [],
    );
  }

  /// `Warning`
  String get warning {
    return Intl.message(
      'Warning',
      name: 'warning',
      desc: '',
      args: [],
    );
  }

  /// `The stimulator disconnected due to connection issues.\nBring your phone closer to the stimulator and reconnect`
  String get msgDisconnect {
    return Intl.message(
      'The stimulator disconnected due to connection issues.\nBring your phone closer to the stimulator and reconnect',
      name: 'msgDisconnect',
      desc: '',
      args: [],
    );
  }

  /// `Delete`
  String get delete {
    return Intl.message(
      'Delete',
      name: 'delete',
      desc: '',
      args: [],
    );
  }

  /// `Settings`
  String get settings {
    return Intl.message(
      'Settings',
      name: 'settings',
      desc: '',
      args: [],
    );
  }

  /// `Select`
  String get select {
    return Intl.message(
      'Select',
      name: 'select',
      desc: '',
      args: [],
    );
  }

  /// `Disconnect`
  String get disconnect {
    return Intl.message(
      'Disconnect',
      name: 'disconnect',
      desc: '',
      args: [],
    );
  }

  /// `My stimulators`
  String get myStimulators {
    return Intl.message(
      'My stimulators',
      name: 'myStimulators',
      desc: '',
      args: [],
    );
  }

  /// `Stimulator {dvcName}`
  String dvcName(Object dvcName) {
    return Intl.message(
      'Stimulator $dvcName',
      name: 'dvcName',
      desc: '',
      args: [dvcName],
    );
  }

  /// `Firmware number: {sFN}`
  String firmwareNumber(Object sFN) {
    return Intl.message(
      'Firmware number: $sFN',
      name: 'firmwareNumber',
      desc: '',
      args: [sFN],
    );
  }

  /// `Work duration: {sTUD} {sTC}`
  String workDuration(Object sTUD, Object sTC) {
    return Intl.message(
      'Work duration: $sTUD $sTC',
      name: 'workDuration',
      desc: '',
      args: [sTUD, sTC],
    );
  }

  /// `Application: {appName}`
  String appName(Object appName) {
    return Intl.message(
      'Application: $appName',
      name: 'appName',
      desc: '',
      args: [appName],
    );
  }

  /// `Version: {appVersion}`
  String appVersion1(Object appVersion) {
    return Intl.message(
      'Version: $appVersion',
      name: 'appVersion1',
      desc: '',
      args: [appVersion],
    );
  }

  /// `Build:{buildNumber}`
  String buildNumber(Object buildNumber) {
    return Intl.message(
      'Build:$buildNumber',
      name: 'buildNumber',
      desc: '',
      args: [buildNumber],
    );
  }

  /// `mm:ss`
  String get mm_ss {
    return Intl.message(
      'mm:ss',
      name: 'mm_ss',
      desc: '',
      args: [],
    );
  }

  /// `hh:mm:ss`
  String get hh_mm_ss {
    return Intl.message(
      'hh:mm:ss',
      name: 'hh_mm_ss',
      desc: '',
      args: [],
    );
  }

  /// `Connectiong to the stimulator {deviceName}`
  String connectToStimulator(Object deviceName) {
    return Intl.message(
      'Connectiong to the stimulator $deviceName',
      name: 'connectToStimulator',
      desc: '',
      args: [deviceName],
    );
  }

  /// `Available methodics`
  String get availableMethodics {
    return Intl.message(
      'Available methodics',
      name: 'availableMethodics',
      desc: '',
      args: [],
    );
  }

  /// `All the list`
  String get allList {
    return Intl.message(
      'All the list',
      name: 'allList',
      desc: '',
      args: [],
    );
  }

  /// `By categories`
  String get byCategories {
    return Intl.message(
      'By categories',
      name: 'byCategories',
      desc: '',
      args: [],
    );
  }

  /// `< Back`
  String get goBack {
    return Intl.message(
      '< Back',
      name: 'goBack',
      desc: '',
      args: [],
    );
  }

  /// `Low battery.\nThe stimulator may shut off at any time`
  String get lowLevelBattery {
    return Intl.message(
      'Low battery.\nThe stimulator may shut off at any time',
      name: 'lowLevelBattery',
      desc: '',
      args: [],
    );
  }

  /// `Failed to connect to the stimulator`
  String get failedToConnect {
    return Intl.message(
      'Failed to connect to the stimulator',
      name: 'failedToConnect',
      desc: '',
      args: [],
    );
  }

  /// `Please try again`
  String get tryAgain {
    return Intl.message(
      'Please try again',
      name: 'tryAgain',
      desc: '',
      args: [],
    );
  }

  /// `Personal mode`
  String get personalMode {
    return Intl.message(
      'Personal mode',
      name: 'personalMode',
      desc: '',
      args: [],
    );
  }

  /// `Run a custom methodic?`
  String get askRunCustomMethodic {
    return Intl.message(
      'Run a custom methodic?',
      name: 'askRunCustomMethodic',
      desc: '',
      args: [],
    );
  }

  /// `Программа {programTitle}`
  String programTitle(Object programTitle) {
    return Intl.message(
      'Программа $programTitle',
      name: 'programTitle',
      desc: '',
      args: [programTitle],
    );
  }

  /// `Custom methodic`
  String get freeMethodic {
    return Intl.message(
      'Custom methodic',
      name: 'freeMethodic',
      desc: '',
      args: [],
    );
  }

  /// `Manual control of the stimulation mode`
  String get freeMethodicDescription {
    return Intl.message(
      'Manual control of the stimulation mode',
      name: 'freeMethodicDescription',
      desc: '',
      args: [],
    );
  }

  /// `Stimulator operating mode with individual settings`
  String get personalModeDescription {
    return Intl.message(
      'Stimulator operating mode with individual settings',
      name: 'personalModeDescription',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'ru'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
