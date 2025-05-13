import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:get_it/get_it.dart';
import 'package:uuid/uuid.dart';

import '../../utils/baseutils.dart';
import '../../utils/charge_values.dart';
import '../logger/communication_logger.dart';
import '../methodic_programs/model/methodic_program.dart';
import 'bgs_defines.dart';

/// Класс функций, вызываемых при получении данных
class Handler {
  const Handler({
    required this.uid,
    required this.handler,
  });

  final String uid;
  final Function handler;
}

/// Режим работы при потере связи
/// cfmResetPower - сбрасывать мощность
/// cfmWorking - продолжать работу
enum ConnectionFailureMode { cfmResetPower, cfmWorking }

/// Класс пакета данных от устройства
class BlockData {
  const BlockData({
    required this.power,
    required this.isAM,
    required this.isFM,
    required this.amMode,
    required this.freq,
    required this.isPowerReset,
    required this.intensity,
    required this.chargeLevel,
    required this.chargeValue,
    required this.chargeValueExt,
    required this.methodUid,
    required this.stage,
    required this.playingTime,
    required this.source,
    required this.firmwareNumber,
  });

  final double power;
  final bool isAM;
  final bool isFM;
  final AmMode amMode;
  final double freq;
  final bool isPowerReset;
  final Intensivity intensity;
  final double chargeLevel;
  final double chargeValue;
  final double chargeValueExt;
  final int methodUid;
  final int stage;
  final double playingTime;
  final List<int> source;
  final int firmwareNumber;
}

/// Класс для управления устройством БГС
class BgsConnect {
  BgsConnect();

  late BluetoothDevice device;
  List<int> _value = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];

  int _firmwareNumber = -1;
  int _timeUseDevice = -1;

  final List<Handler> _dataHandlers = [];
  late BluetoothCharacteristic _characteristic;
  late StreamSubscription _subscription;
  late Timer _setPowerTimer;

  int _curPower = 0;
  bool _isSending = false;
  double _chargeLevel = 100.0;

  int _targetPower = 0;

  /// Целевая мощность, получаемая по запросу
  List<double> _stagesDuration = [];

  /// Длительности этапов программы, получаемые по запросу

  Intensivity _intensivity = Intensivity.one;

  /// Команда большой длины, разбитая на несколько пакетов
  List<List<int>> _commandMultiRun = [];

  var uid = const Uuid().v1(); //TODO: Убрать!!!

  Future<bool> init(BluetoothDevice device) async {
    this.device = device;

    try {
      List<BluetoothService> services = await device.discoverServices();
      for (var service in services) {
        /// Сервис bluetooth для управления БГС - ffe0
        if (service.uuid.toString() == 'ffe0') {
          var characteristics = service.characteristics;
          for (BluetoothCharacteristic c in characteristics) {
            _characteristic = c;
            _isSending = true;

            /// Вешаем потоковый слушатель на изменение характеристики bluetooth
            final subscription = c.lastValueStream.listen((value) async {
              /// Данные нужной длины
              if (_isSending && value.length == 15) {
                /// Логирование принятого значения
                if (logSubject == LogSubject.lsComm ||
                    logSubject == LogSubject.lsAll) {
                  GetIt.I<CommunicationLogger>().log('>> $value');
                }

                /// Это ежесекундный пакет данных
                /// Передача его зарегистрированным слушателям,
                /// чтобы отображать данные и управлять БГС
                if (value[0] == 0xBC) {
                  if (kDebugMode) {
                    print('data block from device: $value');
                  }

                  _value = value;
                  var bd = _createBlockData(_value);
                  for (int i = 0; i < _dataHandlers.length; ++i) {
                    _dataHandlers[i].handler(bd);
                  }
                } else

                /// Это информационный пакет по методике
                if (value[0] == 0xBE) {
                  if (kDebugMode) {
                    print('program params: $value');
                  }

                  _assignProgramParams(value);
                }
              }
            });
            _subscription = subscription;
            device.cancelWhenDisconnected(subscription);
            await c.setNotifyValue(true);

            /// Анализируем события жизненного цикла, чтобы выключить БГС.
            /// Но, не выключается...
            AppLifecycleListener(onStateChange: _onStateChanged);
          }
        }
      }
    } catch (e) {
      if (logSubject == LogSubject.lsComm || logSubject == LogSubject.lsAll) {
        GetIt.I<CommunicationLogger>().log('bgs_connect. fail connection');
      }
      if (kDebugMode) {
        print(
            '================================================================');
        print('Подключиться к стимулятору не удалось: $e');
        print(
            '================================================================');
      }
      return false;
    }

    // services.forEach((service) async {});
    return true;
  }

  void done() {
    _isSending = false;
    _subscription.cancel();
  }

  Future addHandler(String uid, Function handler) async {
    _dataHandlers.add(Handler(uid: uid, handler: handler));
  }

  Future removeHandler(String uid) async {
    for (int i = 0; i < _dataHandlers.length; ++i) {
      if (_dataHandlers[i].uid == uid) {
        _dataHandlers.removeAt(i);
      }
    }
  }

  Future removeHandlers() async {
    _dataHandlers.clear();
  }

  void setPower(double power) async {
    _curPower = power.toInt();
    await _write([0x91, _curPower]);
  }

  void reset() async {
    await _write([0x91, 0x00]);
  }

  /// Записывает паузу в устройство
  /// isPlay = false - пауза
  /// isPlay = true - нет паузы
  void pause(bool isPlay) async {
    int b = 1;
    if (isPlay) {
      b = 2;
    }
    await _write([0xB1, b]);
  }

  /// Записывает программу в устройство
  void setProgram(MethodicProgram prg) async {
    /// Общие параметры программы
    List<int> command = [0xB3];
    command.add(int.parse(prg.uid));
    command.add(prg.stagesCount());

    /// Этапы программы
    for (int i = 0; i < prg.stagesCount(); ++i) {
      /// Длительность (2 байта)
      int d = prg.stage(i).duration ~/ 1000;
      command.add(d & 0xFF);
      command.add((d & 0xFF00) >> 8);

      /// AM
      if (prg.stage(i).isAm) {
        var ami = amModeCode[prg.stage(i).amMode];
        command.add(ami!);
      } else {
        command.add(0);
      }

      /// FM
      if (prg.stage(i).isFm) {
        command.add(1);
      } else {
        command.add(0);
      }

      /// Частота
      int f = prg.stage(i).frequency.toInt();
      command.add(f & 0xFF);
      command.add((f & 0xFF00) >> 8);

      /// Интенсивность
      if (prg.stage(i).intensivity == Intensivity.one) {
        command.add(0);
      } else if (prg.stage(i).intensivity == Intensivity.two) {
        command.add(1);
      } else if (prg.stage(i).intensivity == Intensivity.three) {
        command.add(2);
      } else if (prg.stage(i).intensivity == Intensivity.four) {
        command.add(3);
      }
    }
    await _write(command);
  }

  /// Передает команду в устройство перейти в режим ожидания
  /// При этом программа, выполняемая в настоящий момент прерывается
  void stopProgram() async {
    await _write([0xB1, 3]);
  }

  /// Запрашивает пакет данных о параметрах программы
  /// (целевая мощность + длительности этапов)
  void getProgramParams() async {
    await _write([0xB4, 1]);
  }

  /// Возвращает номер прошивки
  int firmwareNumber() {
    return _firmwareNumber;
  }

  /// Возвращает время работы устройства
  int timeUseDevice() {
    return _timeUseDevice;
  }

  /// Устанавливает время работы устройства
  void setTimeUseDevice(int startVal) {
    _timeUseDevice = startVal;
  }

  /// Целевая мощность, получаемая по запросу
  int targetPower() {
    return _targetPower;
  }

  /// Кол-во этапов программы, получаемые по запросу
  int stagesCount() {
    return _stagesDuration.length;
  }

  /// Длительность этапа программы, получаемые по запросу
  double stageDuration(int stage) {
    assert(stage >= 0 && stage < _stagesDuration.length);
    return _stagesDuration[stage];
  }

  static const int maxBytesPerCommand = 16;
  static const int delayBetweenCommands = 200;

  /// Записывает команду в устройство
  Future<void> _write(List<int> command) async {
    if (!_isSending) return;
    if (!device.isConnected) return;

    /// Поскольку нельзя передавать команды длиной более maxBytesPerComand байт, придется
    /// передавать их по частям, если длительность превышает maxBytesPerComand байт
    if (command.length <= maxBytesPerCommand) {
      await _characteristic.write(command, withoutResponse: true);
    } else {
      _commandMultiRun.clear();
      int b = 0;
      do {
        List<int> cmd = [];
        for (int i = b; i < command.length; ++i) {
          if (cmd.length == maxBytesPerCommand) break;
          cmd.add(command[i]);
        }
        _commandMultiRun.add(cmd);

        b += maxBytesPerCommand;
      } while (b < command.length);

      /// Запускаем таймер передачи команды
      Timer(const Duration(milliseconds: 100), _sendPartCommand);
    }
    if (logSubject == LogSubject.lsComm || logSubject == LogSubject.lsAll) {
      GetIt.I<CommunicationLogger>().log('<< $command');
    }
  }

  /// Передача команды
  void _sendPartCommand() async {
    /// Еще есть что передавать
    if (_commandMultiRun.isNotEmpty) {
      /// Собираем команду
      List<int> cmd = [];
      for (int i = 0; i < _commandMultiRun[0].length; ++i) {
        cmd.add(_commandMultiRun[0][i]);
      }

      /// Удаляем ее из общей очереди
      _commandMultiRun.removeAt(0);

      /// Передаем
      if (kDebugMode) {
        print(
            '--- send command --- time: ${DateTime.now()} --- cmd: $cmd ------------------------------------------------');
      }
      await _characteristic.write(cmd, withoutResponse: true);

      /// Запускаем таймер передачи остальной части команды
      Timer(
          const Duration(milliseconds: delayBetweenCommands), _sendPartCommand);
    }
  }

  /// Сбрасывает уровень заряда
  void resetChargeLevel() {
    _chargeLevel = 100.0;
  }

  /// Сбор данных для передачи
  BlockData _createBlockData(List<int> value) {
    var power = value[5].toDouble();

    var isAM = value[9] > 0;
    AmMode amMode = AmMode.am_11;
    if (isAM) {
      for (final element in amModeCode.entries) {
        if (element.value == value[9]) {
          amMode = element.key;
        }
      }
    }

    var isFM = value[10] == 7;
    double freq = (value[13] * 256 + value[12]).toDouble();

    bool isPowerReset = false;
    if ((value[4] & 0x80) != 0) {
      isPowerReset = true;
    }

    _intensivity = Intensivity.values[value[11]];

    /// Уровень заряда батареи
    /// TODO: Убрать вариант выбора источника, когда будет решение
    var vRare = value[3];

    /// Вариант с большим шагом
    var cl = getChargeLevelByADC(vRare);

    /// Управление отображаемым уровнем заряда батареи
    if (cl < _chargeLevel) {
      /// Уменьшаем легко
      _chargeLevel = cl;
    } else {
      /// А увеличиваем, если за один шаг + 10% или больше или 100%
      if (cl >= _chargeLevel + 10 || cl == 100) {
        _chargeLevel = cl;
      }
    }

    int methodUid = value[2];
    int stage = 0;
    double playingTime = 0;
    if (methodUid > 0 && value[6] > 0) {
      stage = value[6] - 1;
      playingTime = (value[8] * 256 + value[7]).toDouble();
    }

    _firmwareNumber = value[4] & 0x7F;
    ++_timeUseDevice;

    /// Передача данных
    return BlockData(
      power: power,
      isAM: isAM,
      isFM: isFM,
      amMode: amMode,
      freq: freq,
      isPowerReset: isPowerReset,
      intensity: _intensivity,
      chargeLevel: _chargeLevel,
      chargeValue: value[3].toDouble(),
      chargeValueExt: value[2].toDouble() * 256 + value[1].toDouble(),
      source: value,
      firmwareNumber: _firmwareNumber,
      methodUid: methodUid,
      stage: stage,
      playingTime: playingTime,
    );
  }

  /// Разбирает пакет данных с параметрами программы
  /// (целевая мощность + длительности этапов)
  void _assignProgramParams(List<int> value) {
    /// Целевая мощность
    _targetPower = value[1];

    /// Длительности этапов
    int cnt = value[2];

    /// Кол-во этапов
    _stagesDuration.clear();
    for (int i = 0; i < cnt; ++i) {
      double duration =
          ((value[3 + 2 * i + 1] * 256 + value[3 + 2 * i]) * 1000).toDouble();
      _stagesDuration.add(duration);
      if (i == 5) break;

      /// Максимум 6 этапов
    }
  }

  void _onStateChanged(AppLifecycleState state) {
    /// При завершении приложения неплохо было бы выключать воздействие
    /// Но не работает reset() из этой точки. При передаче команды через _characteristic
    /// Неплохо бы понять, почему...
    /// А будет ли при этом прерываться, если перешли в автономку - вопрос...
    /// Вообщем, пока нет заявки на эту функцию - поставим на паузу
    if (state == AppLifecycleState.detached) {
      reset();
    }
    if (kDebugMode) {
      print(
        '================================ AppLifecycleState : $state =====================',
      );
    }
  }
}
