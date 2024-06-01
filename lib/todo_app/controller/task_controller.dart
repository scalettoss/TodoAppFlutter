import 'package:flutter/material.dart';
import 'package:project_final/todo_app/model/task.dart';


class TaskController extends ChangeNotifier {
  String todoName = "";
  List<Task> tasks = [];
  late bool isCompleted;
  final TextEditingController _controller = TextEditingController();

  TextEditingController get controller => _controller;

  void addNewTask() {
    final taskName = _controller.text;
    if (taskName.isNotEmpty) {
      tasks.add(Task(name: taskName));
      _controller.clear();
      isCompleted = false;
      notifyListeners();
    }
  }

  void changeTodoName(String value) {
    todoName = value;
  }
  void toggleTaskCompletion(int index, bool? value) {
    tasks[index].isCompleted = value ?? false;
    notifyListeners();
  }

  void deleteTask(int index) {
    tasks.removeAt(index);
    notifyListeners();
  }
  void checkCompleted() {
    for(Task task in tasks) {
      if(!task.isCompleted) isCompleted = false;
    }
    isCompleted = true;
  }
}
class TodoController{
  List<TaskController> list = [];
  void addTask(TaskController todo) {
    list.add(todo);
  }
  void removeTask(TaskController todo) {
    list.remove(todo);
  }
}
