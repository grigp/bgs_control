import '../../bgs_connect/bgs_defines.dart';

/// Класс, содержащий данные об этапе
class ProgramStage {
  ProgramStage({
    required this.comment,
    required this.duration,

    /// Длительность. -1 - неограничена по времени
    required this.isAm,
    required this.isFm,
    required this.amMode,
    required this.intensivity,
    required this.frequency,
  });

  String comment;
  int duration;
  bool isAm;
  bool isFm;
  AmMode amMode;
  Intensivity intensivity;
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
    required this.mpk
  });

  /// Конструктор из json
  factory MethodicProgram.fromJson(dynamic data) {
    ///Разбор методики в json
    /// Сначала сам объект с заголовочными полями
    var retval = MethodicProgram(
      uid: data['id'].toString(),
      statsTitle: 'program ${data['id']}',
      title: data['title'],
      description: data['description'],
      image: data['icon'],
      mpk: MethodicProgramKind.mpkNormal,
    );

    /// Затем атрибуты из массива
    var attr = data['attributes'] as List<dynamic>;
    retval.attributes.clear();
    for (int i = 0; i < attr.length; ++i) {
      retval.attributes.add(attr[i]['id']);
    }

    /// Ну и в конце - этапы
    var stages = data['stage'] as List<dynamic>;
    retval._stages.clear();
    for (int i = 0; i < stages.length; ++i) {
      int f = stages[i]['frequency'];
      var stage = ProgramStage(
        comment: stages[i]['comment'],
        duration: stages[i]['duration'],
        isAm: stages[i]['am'],
        isFm: stages[i]['fm'],
        amMode: amModeFromJson[stages[i]['am_mode']]!,
        intensivity: intensivityFromJson[stages[i]['intensivity']]!,
        frequency: f.toDouble(),
      );
      retval._stages.add(stage);
    }

    /// И на сладкое - возвращаем программу
    return retval;
  }

  /// Конструктор в режиме togo
  factory MethodicProgram.togo(bool isAm, bool isFm, AmMode amMode,
      Intensivity intensity, double frequency, int duration) {
    return MethodicProgram(
      uid: '254',
      statsTitle: 'togo program',
      title: 'Индивидуальный режим',
      description: 'Работа с индивидуальными настройками',
      image: 'togo.png',
      mpk: MethodicProgramKind.mpkPersonal,
    ).._addStage(
        'индивидуальные настройки',
        duration,
        isAm,
        isFm,
        amMode,
        intensity,
        frequency,
      );
  }

  /// Конструктор в режиме direct control
  factory MethodicProgram.one(bool isAm, bool isFm, AmMode amMode,
      Intensivity intensity, double frequency, int duration) {
    return MethodicProgram(
      uid: '255',
      statsTitle: 'togo program',
      title: 'Индивидуальный режим',
      description: 'Работа с индивидуальными настройками',
      image: 'togo.png',
      mpk: MethodicProgramKind.mpkDirect,
    ).._addStage(
      'индивидуальные настройки',
      duration,
      isAm,
      isFm,
      amMode,
      intensity,
      frequency,
    );
  }

  String uid;
  String statsTitle;
  String title;
  String description;
  String image;
  MethodicProgramKind mpk;
  List<String> attributes = [];

  final List<ProgramStage> _stages = [];

  void _addStage(String comment, int duration, bool isAm, bool isFm,
      AmMode amMode, Intensivity intensity, double frequency) {
    var stage = ProgramStage(
      comment: comment,
      duration: duration,
      isAm: isAm,
      isFm: isFm,
      amMode: amMode,
      intensivity: intensity,
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
      intensivity: _stages[idx].intensivity,
    );
  }
}

/// Типы программ
/// mpkNormal - обычная
/// mpkPersonal - индивидуальная
/// mpkDirect = прямого управления
enum MethodicProgramKind {mpkNormal, mpkPersonal, mpkDirect}
