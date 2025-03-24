class CommunicationLogger {
  final List<String> _log = [];

  void log(String message) {
    _log.add(message);
  }

  List<String> get() => _log;

  void clear() {
    _log.clear();
  }
}

/// Что можно логировать
/// lsComm - коммуникационную связь
/// lsCharge - уровень заряда поминутный
/// lsAll - всё
enum LogSubject {lsComm, lsCharge, lsAll}
/// Что логируем в настоящий момент
LogSubject logSubject = LogSubject.lsComm;


