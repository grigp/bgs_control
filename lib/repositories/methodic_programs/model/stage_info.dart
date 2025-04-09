import '../../bgs_connect/bgs_defines.dart';

class StageInfo {
  StageInfo({
    required this.idxStage,
    required this.nameStage,
    required this.duration,  /// Длительность. -1 - неограничена по времени
    required this.stageTime,
    required this.isAm,
    required this.isFm,
    required this.amMode,
    required this.intensivity,
    required this.frequency,
  });

  int idxStage;
  String nameStage;
  int duration;
  int stageTime;
  bool isAm;
  bool isFm;
  AmMode amMode;
  Intensivity intensivity;
  double frequency;
}