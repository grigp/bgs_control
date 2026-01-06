/// Режимы работы БГС: Сон, ожидание, стимуляция, пауза
enum DeviceMode { dm_sleep, dm_wait, dm_execution, dm_pause }

/// Режимы амплитудной модуляции
enum AmMode { am_11, am_31, am_51 }

/// Интенсивности
enum Intensivity { one, two, three, four }

/// Текстовые представления амплитудной модуляции
Map<AmMode, String> amModeNames = <AmMode, String>{
  AmMode.am_11: '1:1',
  AmMode.am_31: '3:1',
  AmMode.am_51: '5:1',
};

/// Значения амплитудной модуляции в json
Map<int, AmMode> amModeFromJson = <int, AmMode>{
  11: AmMode.am_11,
  31: AmMode.am_31,
  51: AmMode.am_51,
};

/// Коды амплитудной модуляции
Map<AmMode, int> amModeCode = <AmMode, int>{
  AmMode.am_11: 3,
  AmMode.am_31: 1,
  AmMode.am_51: 2,
};

/// Коды интенсивности
Map<int, Intensivity> intensivityFromJson = <int, Intensivity>{
  1: Intensivity.one,
  2: Intensivity.two,
  3: Intensivity.three,
  4: Intensivity.four,
};
