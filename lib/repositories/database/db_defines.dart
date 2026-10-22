

/// Класс данных о записи пациента
class RecordSeance {
  String uid;
  DateTime dt;
  int duration;
  int max;
  int average;
  String comment;

  RecordSeance({
    required this.uid,
    required this.dt,
    required this.duration,
    required this.max,
    required this.average,
    required this.comment,
  });
}