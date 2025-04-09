
enum AmMode { am_11, am_31, am_51 }

enum Intensivity { one, two, three, four }

Map<AmMode, String> amModeNames = <AmMode, String>{
  AmMode.am_11: '1:1',
  AmMode.am_31: '3:1',
  AmMode.am_51: '5:1',
};

Map<int, AmMode> amModeFromJson = <int, AmMode>{
  11: AmMode.am_11,
  31: AmMode.am_31,
  51: AmMode.am_51,
};

Map<AmMode, int> amModeCode = <AmMode, int>{
  AmMode.am_11: 3,
  AmMode.am_31: 1,
  AmMode.am_51: 2,
};

Map<int, Intensivity> intensivityFromJson = <int, Intensivity>{
  1: Intensivity.one,
  2: Intensivity.two,
  3: Intensivity.three,
  4: Intensivity.four,
};

Map<double, double> freqValue = <double, double>{
  0: 15,
  1: 30,
  2: 60,
  3: 90,
  4: 120,
  5: 180,
  6: 350,
};

