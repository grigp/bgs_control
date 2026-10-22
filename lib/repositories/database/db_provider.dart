import 'dart:typed_data';

import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';

import 'db_defines.dart';


/// Обработчик событий в БД
class HandlerInfo {
  String uid;
  Function func;

  HandlerInfo({
    required this.uid,
    required this.func,
  });
}

class DbProvider {
  DbProvider() {
  }

  String _dbPath = '';
  late Database _db;

  List<HandlerInfo> _handlers = [];

  Future _openDB() async {
    if (_dbPath == '') {
      _dbPath = '${await getDatabasesPath()}/data/database.db';
      _db = await openDatabase(_dbPath, version: 1,
          onCreate: (Database db, int version) async {
            await db.execute(
                'CREATE TABLE Seances  (uid STRING PRIMARY KEY, dt STRING, duration STRING, max INT, average INT, comment STRING)');
          });
    }
  }

  /// Записывает информацию о тесте в базу данных
  Future addSeance(RecordSeance rec) async {
    await _openDB();
    await _db.insert('Seances', {
      'uid': rec.uid,
      'dt': rec.dt,
      'duration': rec.duration,
      'max': rec.max,
      'average': rec.average,
      'comment': rec.comment,
    });

    /// Известим интересующихся о появлении сеанса
    for (int i = 0; i < _handlers.length; ++i) {
      _handlers[i].func(DBEvents.dbeAddSeance, rec.uid);
    }
  }

  /// Возвращает кол-во сеансов
  Future<int?> seancesCount() async {
    await _openDB();
    return Sqflite.firstIntValue(
        await _db.rawQuery('SELECT COUNT(*) FROM Seances'));
  }

  /// Возвращает список сеансов.
  Future<List<RecordSeance>> getListSeances() async {
    await _openDB();
    List<Map> list =
    await _db.rawQuery(
        'SELECT uid, dt, duration, max, average, comment FROM Seances');
    List<RecordSeance> retval = [];
    print(list);
    for (int i = 0; i < list.length; ++i) {
      retval.add(
        RecordSeance(
          uid: list[i]['uid'].toString(),
          dt: DateTime.parse(list[i]['born']),
          duration: list[i]['duration'].toInt(),
          max: list[i]['max'].toint(),
          average: list[i]['average'].toint(),
          comment: list[i]['comment'].toString(),
        ),
      );
    }
    return retval;
  }

  Future deleteSeance(String seanceUid) async {
    await _openDB();

    /// Удалить запись для этого пациента
    await _db.rawQuery('DELETE FROM Seances WHERE uid = \'seanceUid\'');

    /// Известим интересующихся об удалении теста
    for (int i = 0; i < _handlers.length; ++i) {
      _handlers[i].func(DBEvents.dbeDeleteSeance, seanceUid);
    }
  }

  /// Добавляет обработчик событий.
  /// Возвращает uid. присвоенный обработчику
  String addHandler(Function handler) {
    var uid = const Uuid().v1();
    var hi = HandlerInfo(
      uid: uid,
      func: handler,
    );
    _handlers.add(hi);
    return uid;
  }

  /// Удаляет обработчик событий
  void removeHandler(String uid) {
    int idx = -1;
    for (int i = 0; i < _handlers.length; ++i) {
      if (_handlers[i].uid == uid) {
        idx = i;
        break;
      }
    }
    if (idx > -1) {
      _handlers.removeAt(idx);
    }
  }

  /// Добавляет в список list по байтам значение value, начиная с индекса idx
  void _addValueToIntList(List<int> list, int idx, double value) {
    ByteData bd = ByteData(8);
    bd.setFloat64(0, value);
    var vBt = bd.buffer.asUint8List();
    for (int j = 0; j < 8; ++j) {
      list[idx + j] = vBt[j];
    }
  }

}

enum DBEvents { dbeAddSeance, dbeDeleteSeance }
