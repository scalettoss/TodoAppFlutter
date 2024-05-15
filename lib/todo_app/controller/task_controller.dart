import 'package:flutter/material.dart';
import 'package:project_final/todo_app/model/task.dart';

import '../view/home_screen.dart';

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

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}


class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("To do app"),
      ),
      body: SingleChildScrollView(
        child: _homeListView(context),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen(),));
        },
        child: const Text("+"),
      ),
    );
  }
}

/// TODO: Cho tất cả các task trong một màn hình thành một đối tượng TaskController,
/// cho tối đượng todo bằng list các taskController .
/// Sau đó hiển thị ra màn hình
Widget _homeListView(BuildContext context) {
  List<TaskController> tasks = TodoController().list;
  return ListView.builder(
    itemCount: tasks.length,
    itemBuilder: (context, index) {
      return ListTile(
        title: Text(tasks[index].todoName),
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen(),));
        },
      );
    },
  );
}
