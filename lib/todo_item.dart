class TodoItem {
  final int? id;
  final String task;

  TodoItem({this.id, required this.task});

  // Convert a TodoItem into a Map for SQLite
  Map<String, dynamic> toMap() {
    return {'task': task};
  }

  // Convert a Map to a TodoItem
  static TodoItem fromMap(Map<String, dynamic> map) {
    return TodoItem(id: map['id'], task: map['task']);
  }
}
