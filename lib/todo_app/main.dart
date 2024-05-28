import 'package:flutter/material.dart';
import 'package:project_final/Firebase/widget_connect_firebase.dart';
import 'package:project_final/todo_app/controller/task_controller.dart';
import 'package:project_final/todo_app/view/newhomescreen.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:project_final/todo_app/view/home_todo_app.dart';


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
        title: 'Home Todo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home:MyFirebaseConnect(
            errorMessage: "Kết nối không thành công",
            connectingMessage: "Đang kết nối",
            builder: (context) => HomeTodoApp(title: "Home Todo")),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
//
// class MyHomePage extends StatefulWidget {
//   const MyHomePage({super.key, required this.title});
//   final String title;
//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }
//
// class _MyHomePageState extends State<MyHomePage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("To do app"),
//       ),
//       body: SingleChildScrollView(
//         child: _homeListView(context),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           Navigator.push(context, MaterialPageRoute(builder: (context) => HomeTodoApp(),));
//         },
//         child: const Text("+"),
//       ),
//     );
//   }
// }
// /// TODO: Cho tất cả các task trong một màn hình thành một đối tượng TaskController,
// /// cho tối đượng todo bằng list các taskController .
// /// Sau đó hiển thị ra màn hình
// Widget _homeListView(BuildContext context) {
//   List<TaskController> tasks = Provider.of<TodoController>(context, listen: false).list;
//   return ListView.builder(
//     itemCount: tasks.length,
//     itemBuilder: (context, index) {
//       return ListTile(
//         title: Text(tasks[index].todoName),
//         onTap: () {
//           Navigator.push(context, MaterialPageRoute(builder: (context) => HomeTodoApp(),));
//         },
//       );
//     },
//   );
// }