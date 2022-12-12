import 'package:alarm_clock/feature/alarm_page/data/models/alarm_info_model.dart';
import 'package:sqflite/sqflite.dart';

abstract class AlarmLocalDataSources {
  Future<void> saveAlarm(AlarmInfoModel? alarmInfoModel);
  Future<List<AlarmInfoModel>> loadAlarms();
  Future<int?> deleteAlarm(int? id);
  Future<int?> saveDurationRinging(String? duration, String? id);
}

const dbAlarm = 'alarm.db';
const dbAlarmTable = 'alarm';
const String columnId = 'id';
const String columnTitle = 'title';
const String columnDateTime = 'alarmDateTime';
const String columnDuration = 'duration';
const String columnColorIndex = 'gradientColorIndex';

class AlarmLocalDataSourcesImpl implements AlarmLocalDataSources {
  Future<Database?> _openDB(String? dbName) async {
    return await openDatabase(dbName!, version: 1,
        onCreate: (Database db, int version) {
      db.execute('''
          CREATE TABLE IF NOT EXISTS $dbAlarmTable ( 
          $columnId INTEGER PRIMARY KEY, 
          $columnTitle TEXT NOT NULL,
          $columnDateTime TEXT NOT NULL,
          $columnDuration TEXT,
          $columnColorIndex INTEGER)
        ''');
    });
  }

  @override
  Future<void> saveAlarm(AlarmInfoModel? alarmInfoModel) async {
    try {
      var db = await _openDB(dbAlarm);
      var result = await db!.insert(dbAlarmTable, alarmInfoModel!.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace);
      print('result : $result');
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<AlarmInfoModel>> loadAlarms() async {
    List<AlarmInfoModel> _alarms = [];
    try {
      var db = await _openDB(dbAlarm);
      var result = await db?.query(dbAlarmTable);
      result?.forEach(
        (element) {
          var alarmInfo = AlarmInfoModel.fromMap(element);
          _alarms.add(alarmInfo);
        },
      );
      return _alarms;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<int?> deleteAlarm(int? id) async {
    try {
      var db = await _openDB(dbAlarm);
      return await db
          ?.delete(dbAlarmTable, where: '$columnId = ?', whereArgs: [id]);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<int?> saveDurationRinging(String? duration, String? id) async {
    try {
      var db = await _openDB(dbAlarm);
      return await db?.rawUpdate(
          'UPDATE $dbAlarmTable SET $columnDuration = ? WHERE id = ?',
          [duration, id]);
    } catch (e) {
      rethrow;
    }
  }
}
