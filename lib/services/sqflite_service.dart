import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/actor_model.dart';

class DatabaseHelper {
  initializeDB() async {
    final Database database = await openDatabase(
      join(await getDatabasesPath(), 'actors_database.db'),
      onCreate: ((db, version) async {
        await db
            .execute('CREATE TABLE actors(name TEXT PRIMARY KEY, image TEXT)');
      }),
      version: 4,
    );
    return database;
  }

  ///////////////////////////////
  Future<int> createActors(Actor actor) async {
    final Database db = await initializeDB();
    int a = await db.insert(
      'actors',
      actor.toMap(),
    );
    return a;
  }

  //////////////////////
  Future<void> deleteActors(String name) async {
    final Database db = await initializeDB();
    try {
      db.delete(
        'actors',
        where: 'name = ?',
        whereArgs: [name],
      );
    } catch (error) {
      print('$error');
    }
  }

///////////////////////////////////
  Future<List<Actor>>? getActors() async {
    final Database db = await initializeDB();
    final List<Map<String, Object?>> queryResult = await db.query(
      'actors',
    );

    return queryResult.map((e) => Actor.fromMap(e)).toList();
  }
}

//////////////////////////////////