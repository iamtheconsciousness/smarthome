import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'schedule_model.dart';

class DbManagerSc {
  Database? _database;

  Future openDb() async {
    _database = await openDatabase(join(await getDatabasesPath(), "sc.db"),
        version: 1, onCreate: (Database db, int version) async {
          await db.execute(
            "CREATE TABLE schedule(idSchedule INTEGER PRIMARY KEY, scheduleName TEXT, id INTEGER, name TEXT, state INTEGER, room TEXT, variable INTEGER, type INTEGER, date TEXT, time TEXT, disabled INTEGER, recurring TEXT, addState INTEGER)",
          );
        });
    return _database;
  }

  Future<void> insertBulkJSON(List<Map<String, dynamic>> jsonData) async {
    await openDb();

    Batch batch = _database!.batch();

    for (Map<String, dynamic> data in jsonData) {
      batch.insert('schedule', data);
    }

    await batch.commit(noResult: true);
  }

  Future insertModel(S_Model model) async {
    await openDb();
    print("Hi from insert table");
    return await _database!.insert('schedule', model.toJson());
  }

  Future<List<S_Model>> getModelList() async {
    await openDb();
    final List<Map<String, dynamic>> maps = await _database!.query('schedule');

    return List.generate(maps.length, (i) {
      return S_Model(
          idSchedule: maps[i]['idSchedule'],
          scheduleName: maps[i]['scheduleName'],
          id: maps[i]['id'],
          name: maps[i]['name'],
          state: maps[i]['state'],
          room: maps[i]['room'],
          variable: maps[i]['variable'],
          type: maps[i]['type'],
          date: maps[i]['date'],
          time: maps[i]['time'],
          disabled: maps[i]['disabled'],
          recurring: maps[i]['recurring'],
          addState: maps[i]['addState']);
      
    });
  }

  Future<int> updateModel(S_Model model) async {
    await openDb();
    return await _database!.update('schedule', model.toJson(),
        where: "idSchedule = ?", whereArgs: [model.idSchedule]);
  }

  Future<void> deleteModel(S_Model model) async {
    await openDb();
    await _database!.delete('schedule', where: "idSchedule = ?", whereArgs: [model.idSchedule]);
  }
}
Future<void> deleteDatabase() =>
    databaseFactory.deleteDatabase('/data/user/0/com.example.flutter_hands_on_2_database/databases/sc.db');