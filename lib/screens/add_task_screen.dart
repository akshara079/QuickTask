import 'package:flutter/material.dart';
import '../models/task.dart';

class AddTaskScreen extends StatefulWidget {
  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _titleController = TextEditingController();
  DateTime? _dueDate;

  void _saveTask() {
    if (_titleController.text.isEmpty || _dueDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please provide a title and due date')),
      );
      return;
    }
    final newTask = Task(
      title: _titleController.text,
      dueDate: _dueDate!,
    );
    Navigator.pop(context, newTask);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Task')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Task Title'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
                onPressed: () async {
                  final selectedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2100),
                  );
                  if (selectedDate != null) {
                    setState(() {
                      _dueDate = selectedDate;
                    });
                  }
                },
                child: Text(_dueDate == null
                    ? 'Select Due Date'
                    : 'Due: ${_dueDate!.toLocal()}')),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _saveTask,
              child: Text('Save Task'),
            ),
          ],
        ),
      ),
    );
  }
}
