import 'package:flutter/material.dart';
import 'todo_item.dart';
import 'database_helper.dart';
import 'package:flutter/foundation.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  // Initialize sqflite for FFI platforms (Windows, Linux, macOS)
  if (defaultTargetPlatform == TargetPlatform.windows ||
      defaultTargetPlatform == TargetPlatform.linux ||
      defaultTargetPlatform == TargetPlatform.macOS) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi; // Initialize the database factory for FFI
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter To-Do App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  final TextEditingController _taskController = TextEditingController();
  List<TodoItem> _tasks = [];

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  void _loadTasks() async {
    try {
      var tasks = await _dbHelper.getTasks();
      setState(() {
        _tasks = tasks;
      });
    } catch (e) {
      print("Error loading tasks: $e");
    }
  }

  void _addTask() async {
    if (_taskController.text.isNotEmpty) {
      try {
        await _dbHelper.insertTask(TodoItem(task: _taskController.text.trim()));
        _loadTasks();
        _taskController.clear();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Task added!')),
        );
      } catch (e) {
        print("Error adding task: $e");
      }
    }
  }

  void _deleteTask(int id) async {
    try {
      await _dbHelper.deleteTask(id);
      _loadTasks();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Task deleted!')),
      );
    } catch (e) {
      print("Error deleting task: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('To-Do List')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _taskController,
              decoration: InputDecoration(labelText: 'Enter task'),
            ),
          ),
          ElevatedButton(
            onPressed: _addTask,
            child: Text('Add Task'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _tasks.length,
              itemBuilder: (context, index) {
                final task = _tasks[index];
                return ListTile(
                  title: Text(task.task),
                  onLongPress: () => _deleteTask(task.id!),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
