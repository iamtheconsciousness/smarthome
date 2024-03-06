import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'structure_model.dart';

class DbManager {
   Database? _database;

  Future openDb() async {
    _database = await openDatabase(join(await getDatabasesPath(), "ss.db"),
        version: 1, onCreate: (Database db, int version) async {
          await db.execute(
            "CREATE TABLE model(component_id TEXT PRIMARY KEY , state TEXT, room TEXT , variable TEXT , type TEXT, component_name TEXT)",
          );
        });
    return _database;
  }

  Future insertModel(List<Led> table) async {
    await openDb();
    for(int i=0;i<table.length;i++){
      _database!.insert('model', table[i].toJson());
    }
    return ;
  }

  Future<List<Led>> getDistRooms() async{
    await openDb();
    final List<Map<String, dynamic>> maps = await _database!.rawQuery(
        "SELECT * FROM model GROUP BY room"
    );
    print("inside distinct room");
    print(maps.length);
    return List.generate(maps.length, (i) {
      print(maps[i]);
      return Led(
          component_id: maps[i]['component_id'],
          state: maps[i]['state'],
          room: maps[i]['room'],
      variable: maps[i]['variable'],
          component_name: maps[i]['component_name'],
      type: maps[i]['type']);
    });
  }

   Future<List<Led>> getRoomWise(String room) async{
     await openDb();
     final List<Map<String, dynamic>> maps = await _database!.rawQuery(
         "SELECT * FROM model WHERE room=?",[room]);
     return List.generate(maps.length, (i) {
       return Led(
           component_id: maps[i]['component_id'],
           state: maps[i]['state'],
           room: maps[i]['room'],
           variable: maps[i]['variable'],
           component_name: maps[i]['component_name'],
           type: maps[i]['type']);
     });
   }

  Future<List<Led>> getModelList() async {
    await openDb();
    final List<Map<String, dynamic>> maps = await _database!.query('model');

    return List.generate(maps.length, (i) {
      return Led(
          component_id: maps[i]['component_id'],
          state: maps[i]['state'],
          room: maps[i]['room'],
          variable: maps[i]['variable'],
          component_name: maps[i]['component_name'],
          type: maps[i]['type']);

    });
    // return maps
    //     .map((e) => Model(
    //         id: e["id"], fruitName: e["fruitName"], quantity: e["quantity"]))
    //     .toList();
  }

  Future<int> updateModel(Led table) async {
    await openDb();
    return await _database!.update('model', table.toJson(),
        where: "id = ?", whereArgs: [table.component_id]);
  }

  Future<void> deleteModel(Led table) async {
    await openDb();
    await _database!.delete('model', where: "id = ?", whereArgs: [table.component_id]);
  }
}
