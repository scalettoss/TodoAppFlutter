import 'package:flutter/material.dart';
import 'package:project_final/Firebase/widget_connect_firebase.dart';
import 'package:project_final/todo_app/controller/task_controller.dart';
import 'package:project_final/todo_app/view/home_screen.dart';
import 'package:project_final/todo_app/view/newhomescreen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => TaskController()),
      ],
      child: MaterialApp(
        title: 'Task Manager',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home:MyFirebaseConnect(
            errorMessage: "Kết nối không thành công",
            connectingMessage: "Đang kết nối",
            builder: (context) => NewHomeScreen()),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}