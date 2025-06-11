/// Класс, содержащий данные о выполнении программы
/// В частности возвращает, открыто или нет то или иное окно
class AppMonitor {
  final List<bool> _openedWindows = [false, false, false];

  /// Устанавливает статус окна, открыто ли оно
  void setWindowStatus(AppWindows wnd, bool status) {
    _openedWindows[wnd.index] = status;
  }

  /// Возвращает статус окна, открыто ли оно
  bool isWindowOpened(AppWindows wnd) {
    return _openedWindows[wnd.index];
  }
}

/// Отслеживаемые окна:
/// awSelectProgram - выбора программы стимуляции
/// awExecute - выполнения программы
/// awDirectControl - прямого управления
enum AppWindows {awSelectProgram, awExecute, awDirectControl}