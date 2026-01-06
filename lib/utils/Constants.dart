/// Класс с константами
abstract final class Constants {
  /// Уровень заряда, при котором показывается сообщение о необходимости зарядить аккумулятор
  static const double chargeAlarmBoundLevel = 15;

  /// Уровень заряда, при котором невозможно запускать программы
  static const double chargeBreakBoundLevel = 5;

  /// Максимальное время длительности стимуляции в режиме прямого управления в минутах
  static const double maxDirectModeDuration = 40;

  /// Время максимального воздействия в режиме Direct Control при отсутствии нажатия на кнопки
  static const double maxTimeDirectControlMode = 3600;

  /// Уровень безопасной мощности, при пересечении которого появляется предупреждение о небезопасном уровне мощности
  static const double powerSafeLevel = 10;

  /// Константа для числа 60
  static const int sixty = 60;
}
