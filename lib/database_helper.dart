import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'todo_item.dart';

class DatabaseHelper {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    var dir = await getApplicationDocumentsDirectory();
    String path = '${dir.path}/todo.db';

    _database = await openDatabase(path, version: 1, onCreate: _onCreate);
    return _database!;
  }

  void _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE todo (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        task TEXT
      )
    ''');
  }

  Future<void> insertTask(TodoItem item) async {
    try {
      var db = await database;
      await db.insert('todo', item.toMap());
    } catch (e) {
      print("Error inserting task: $e");
    }
  }

  Future<List<TodoItem>> getTasks() async {
    try {
      var db = await database;
      var result = await db.query('todo');
      return result.map((map) => TodoItem.fromMap(map)).toList();
    } catch (e) {
      print("Error fetching tasks: $e");
      return [];
    }
  }

  Future<void> deleteTask(int id) async {
    try {
      var db = await database;
      await db.delete('todo', where: 'id = ?', whereArgs: [id]);
    } catch (e) {
      print("Error deleting task: $e");
    }
  }
}
