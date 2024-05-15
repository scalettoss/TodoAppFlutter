import 'package:flutter/material.dart';
import 'package:project_final/todo_app/model/task.dart';

class TaskController extends ChangeNotifier {
  List<Task> tasks = [];
  final TextEditingController _controller = TextEditingController();

  TextEditingController get controller => _controller;

  void addNewTask() {
    final taskName = _controller.text;
    if (taskName.isNotEmpty) {
      tasks.add(Task(name: taskName));
      _controller.clear();
      notifyListeners();
    }
  }

  void toggleTaskCompletion(int index, bool? value) {
    tasks[index].isCompleted = value ?? false;
    notifyListeners();
  }

  void deleteTask(int index) {
    tasks.removeAt(index);
    notifyListeners();
  }
}
