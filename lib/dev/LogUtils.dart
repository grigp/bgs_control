import 'package:flutter/foundation.dart';

/// утилита логирования
class LogUtils {
  static const String _DEFAULT_TAG_PREFIX = "texel_app";

  static const int DEBUG = 3;

  static const int INFO = 4;

  static const int WARN = 5;

  static const int ERROR = 6;

  static int _currentLogLevel = INFO;

  static setLogLevel(int priority) {
    int newPriority = priority;
    _currentLogLevel = newPriority;
  }

  static int getLogLevel() {
    LogUtils.i("Current Log Level is ${_getPriorityText(_currentLogLevel)}");
    return _currentLogLevel;
  }

  static _log(int priority, String tag, String message) {
    if (_currentLogLevel <= priority && kDebugMode) {
      print("${_getPriorityText(priority)}$tag: $message");
    }
  }

  static String _getPriorityText(int priority) {
    switch (priority) {
      case INFO:
        return "INFOⓘ|";
      case DEBUG:
        return "DEBUG|";
      case ERROR:
        return "ERROR⚠️|️";
      case WARN:
        return "WARN⚠️|";
      default:
        return "";
    }
  }

  ///Print info logs
  static i(String message, {String tag = _DEFAULT_TAG_PREFIX}) {
    _log(INFO, tag, message);
  }

  ///Print debug logs
  static d(String message, {String tag = _DEFAULT_TAG_PREFIX}) {
    _log(DEBUG, tag, message);
  }

  ///Print warning logs
  static w(String message, {String tag = _DEFAULT_TAG_PREFIX}) {
    _log(WARN, tag, message);
  }

  ///Print error logs
  static e(String message, {String tag = _DEFAULT_TAG_PREFIX}) {
    _log(ERROR, tag, message);
  }
}