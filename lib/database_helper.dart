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

  // Insert a new task
  Future<void> insertTask(TodoItem item) async {
    var db = await database;
    await db.insert('todo', item.toMap());
  }

  // Get all tasks
  Future<List<TodoItem>> getTasks() async {
    var db = await database;
    var result = await db.query('todo');
    return result.map((map) => TodoItem.fromMap(map)).toList();
  }

  // Delete a task
  Future<void> deleteTask(int id) async {
    var db = await database;
    await db.delete('todo', where: 'id = ?', whereArgs: [id]);
  }
}
