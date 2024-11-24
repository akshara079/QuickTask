class Task {
  String title;
  DateTime dueDate;
  bool isCompleted;

  Task({
    required this.title,
    required this.dueDate,
    this.isCompleted = false,
  });
}
