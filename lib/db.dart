import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class sql_db {
  Future<Database> opendb() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'todo.db');
    Database database = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute(
          'CREATE TABLE Todo (id INTEGER PRIMARY KEY, title TEXT, done INTEGER)');
      print('table created');
    });
    return database;
  }

  // Update return type to List<Map<String, dynamic>>
  Future<List<Map<String, dynamic>>> getdb() async {
    Database database = await opendb();
    // Fetch and cast result
    List<Map<String, dynamic>> todo = List<Map<String, dynamic>>.from(
        await database.rawQuery('SELECT * FROM Todo'));
    return todo;
  }

  Future<void> insertdb(String title) async {
    Database database = await opendb();
    await database.transaction((txn) async {
      int id1 = await txn
          .rawInsert('INSERT INTO Todo(title, done) VALUES("$title", 0)');
      print('inserted1: $id1');
    });
  }

  Future<void> updatedb(int done, int id) async {
    Database database = await opendb();
    int count = await database
        .rawUpdate('UPDATE Todo SET done = ? WHERE id = ?', [done, id]);
    print('updated: $count');
  }

  Future<void> deletedb(int id) async {
    Database database = await opendb();
    int count = await database.rawDelete('DELETE FROM Todo WHERE id = ?', [id]);
    print('deleted: $count');
  }
}
