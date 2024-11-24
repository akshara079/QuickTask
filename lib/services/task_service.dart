import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

class TaskService {
  Future<List<ParseObject>> fetchTasks() async {
    final query = QueryBuilder<ParseObject>(ParseObject('Task'));
    final response = await query.query();
    return response.success && response.results != null
        ? response.results as List<ParseObject>
        : [];
  }

  Future<void> addTask(String title, DateTime dueDate) async {
    final task = ParseObject('Task')
      ..set('title', title)
      ..set('dueDate', dueDate)
      ..set('isCompleted', false);
    await task.save();
  }

  Future<void> toggleTaskCompletion(ParseObject task) async {
    final currentStatus = task.get<bool>('isCompleted') ?? false;
    task.set('isCompleted', !currentStatus);
    await task.save();
  }

  Future<void> deleteTask(ParseObject task) async {
    await task.delete();
  }
}
