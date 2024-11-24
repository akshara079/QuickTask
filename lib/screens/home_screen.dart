import 'package:flutter/material.dart';
import 'package:quick_task_project/models/task.dart';
import '../screens/add_task_screen.dart';
import '../screens/login_screen.dart';
import '../services/auth_service.dart';
import '../services/task_service.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TaskService _taskService = TaskService();
  final AuthService _authService = AuthService();

  List<ParseObject> _tasks = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    setState(() {
      _isLoading = true;
    });

    final tasks = await _taskService.fetchTasks();
    setState(() {
      _tasks = tasks;
      _isLoading = false;
    });
  }

  Future<void> _addTask(Task task) async {
    await _taskService.addTask(
      task.title,
      task.dueDate,
    );

    await _loadTasks();
  }

  Future<void> _deleteTask(ParseObject task) async {
    await _taskService.deleteTask(task);
    await _loadTasks();
  }

  Future<void> _toggleTaskCompletion(ParseObject task) async {
    await _taskService.toggleTaskCompletion(task);
    await _loadTasks();
  }

  Future<void> _logout() async {
    await _authService.logout();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QuickTask'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _tasks.isEmpty
              ? Center(
                  child: Text(
                    'No tasks found. Add a new task to get started!',
                    style: TextStyle(fontSize: 18),
                  ),
                )
              : ListView.builder(
                  itemCount: _tasks.length,
                  itemBuilder: (context, index) {
                    final task = _tasks[index];
                    final isCompleted = task.get<bool>('isCompleted') ?? false;

                    return Card(
                      margin: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 16),
                      child: ListTile(
                        title: Text(
                          task.get<String>('title') ?? '',
                          style: TextStyle(
                            decoration: isCompleted
                                ? TextDecoration.lineThrough
                                : TextDecoration.none,
                          ),
                        ),
                        subtitle: Text(
                          'Due: ${task.get<DateTime>('dueDate')?.toLocal().toString().split(' ')[0]}',
                        ),
                        trailing: Wrap(
                          spacing: 12,
                          children: [
                            Checkbox(
                              value: isCompleted,
                              onChanged: (_) => _toggleTaskCompletion(task),
                            ),
                            IconButton(
                              icon: Icon(Icons.delete,
                                  color:
                                      const Color.fromARGB(255, 244, 54, 54)),
                              onPressed: () => _deleteTask(task),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddTaskScreen()),
          );

          if (result != null) {
            await _addTask(result);
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
