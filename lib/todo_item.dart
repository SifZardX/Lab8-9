class TodoItem {
  final int? id;
  final String task;

  TodoItem({this.id, required this.task});

  Map<String, dynamic> toMap() {
    return {'task': task};
  }

  static TodoItem fromMap(Map<String, dynamic> map) {
    return TodoItem(id: map['id'], task: map['task']);
  }
}
