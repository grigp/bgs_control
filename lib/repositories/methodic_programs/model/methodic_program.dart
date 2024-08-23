import 'package:bgs_control/repositories/bgs_connect/bgs_connect.dart';

/// Класс, содержащий данные об этапе
class ProgramStage {
  ProgramStage({
    required this.comment,
    required this.duration,  /// Длительность. -1 - неограничена по времени
    required this.isAm,
    required this.isFm,
    required this.amMode,
    required this.intensity,
    required this.frequency,
  });

  String comment;
  int duration;
  bool isAm;
  bool isFm;
  AmMode amMode;
  Intensity intensity;
  double frequency;
}

/// Класс, содержащий данные о программе.
/// Заголовок и этапы
class MethodicProgram {
  MethodicProgram({
    required this.uid,
    required this.statsTitle,
    required this.title,
    required this.description,
    required this.image,
  });

  /// Конструктор из json
  factory MethodicProgram.fromJson(String data) {
    //TODO: Здесь написать код разбора методики в json

    return MethodicProgram(
      uid: '',
      statsTitle: '',
      title: '',
      description: '',
      image: '',
    );
  }

  /// Конструктор в режиме togo
  factory MethodicProgram.togo(bool isAm, bool isFm, AmMode amMode,
      Intensity intensity, double frequency) {
    return MethodicProgram(
      uid: '',
      statsTitle: 'togo program',
      title: 'Свободный режим',
      description: 'Автономный режим работы стимулятора',
      image: 'images/togo.png',
    ).._addStage('свободная стимуляция', -1, isAm, isFm, amMode, intensity, frequency);
  }

  String uid;
  String statsTitle;
  String title;
  String description;
  String image;

  final List<ProgramStage> _stages = [];

  void _addStage(String comment, int duration, bool isAm, bool isFm,
      AmMode amMode, Intensity intensity, double frequency) {
    var stage = ProgramStage(
      comment: comment,
      duration: duration,
      isAm: isAm,
      isFm: isFm,
      amMode: amMode,
      intensity: intensity,
      frequency: frequency,
    );
    _stages.add(stage);
  }

  /// Возвращает кол-во этапов
  int stagesCount() => _stages.length;

  ProgramStage stage(int idx) {
    assert(idx >= 0 && idx < _stages.length);
    return ProgramStage(
      comment: _stages[idx].comment,
      duration: _stages[idx].duration,
      isAm: _stages[idx].isAm,
      isFm: _stages[idx].isFm,
      amMode: _stages[idx].amMode,
      frequency: _stages[idx].frequency,
      intensity: _stages[idx].intensity,
    );
  }
}
