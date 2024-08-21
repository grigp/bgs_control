import 'package:bgs_control/repositories/bgs_connect/bgs_connect.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// Класс, содержащий данные об этапе
class ProgramStage {
  ProgramStage({
    required this.comment,
    required this.duration,
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
    required this.icon,
  });

  factory MethodicProgram.fromJson(String data) {
    //TODO: Здесь написать код разбора методики в json

    return MethodicProgram(
      uid: '',
      statsTitle: '',
      title: '',
      description: '',
      icon: Icons.add,
    );
  }

  factory MethodicProgram.togo(bool isAm, bool isFm, AmMode amMode,
      Intensity intensity, double frequency) {
    return MethodicProgram(
      uid: '',
      statsTitle: 'togo program',
      title: 'Режим ToGo',
      description: 'Автономный режим работы стимулятора',
      icon: Icons.add,
    ).._addStage('режим togo', -1, isAm, isFm, amMode, intensity, frequency);
  }

  String uid;
  String statsTitle;
  String title;
  String description;
  IconData icon;

  late List<ProgramStage> _stages;

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
}
