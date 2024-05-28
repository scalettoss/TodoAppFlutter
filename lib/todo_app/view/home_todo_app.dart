
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_final/todo_app/model/task.dart';
import 'package:project_final/todo_app/view/newhomescreen.dart';

class HomeTodoApp extends StatefulWidget {

  const HomeTodoApp({super.key});
=======
  const HomeTodoApp({super.key, required this.title});
  final String title;


  @override
  _HomeTodoAppState createState() => _HomeTodoAppState();
}

class _HomeTodoAppState extends State<HomeTodoApp> {


  final TextEditingController txtnameTopic = TextEditingController();
  TimeOfDay selectedTime = TimeOfDay.now();

  void _showInputDialog(BuildContext context, {ToDoSnapshot? snapshot}) {
    if (snapshot != null) {
      txtnameTopic.text = snapshot.toDoTask.topic!;
      selectedTime = TimeOfDay(
        hour: int.parse(snapshot.toDoTask.time!.split(":")[0]),
        minute: int.parse(snapshot.toDoTask.time!.split(":")[1]),
      );
    }
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Nhập Dữ Liệu"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                controller: txtnameTopic,
                decoration: const InputDecoration(labelText: 'Nhập dữ liệu'),
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () async {
                  TimeOfDay? picked = await showTimePicker(
                    context: context,
                    initialTime: selectedTime,
                  );
                  if (picked != null && picked != selectedTime) {
                    setState(() {
                      selectedTime = picked;
                    });
                  }
                },
                child: const Text('Chọn thời gian'),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Hủy'),
            ),
            TextButton(
              onPressed: () async {
                final String time = selectedTime.format(context);
                String newnametopic = txtnameTopic.text;

                if (snapshot != null) {

                  await snapshot.ref.update({
                    'topic': newnametopic,
                    'time': time,
                  });
                } else {
                  // Add new task
                  await FirebaseFirestore.instance.collection("ToDoDB").add({
                    'topic': newnametopic,
                    'time': time,
                  });
                }

                Navigator.of(context).pop();
                setState(() {

                });
              },
              child: const Text('Lưu'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    int numberOfTodo = 0;
    String userName = "";
    return Scaffold(
      appBar: AppBar(

        title: const Text("Home App Todo"),

        title: Text(widget.title),
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () {
            // Nút menu chưa có chức năng
          },
        ),

        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              _showInputDialog(context);
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              accountName: TextField(
                onSubmitted: (value) {
                  userName = value;
                },

                decoration: const InputDecoration(label: Text("Người dùng")),
                maxLines: 1,
              ),
              accountEmail: null, // Email người dùng
              currentAccountPicture: const Icon(Icons.face),
            ),
            ListTile(
              title: Text("Số lượng todo hiện tại: $numberOfTodo"),
              leading: const Icon(Icons.numbers),

            )
          ],
        ),
      ),
      body: StreamBuilder<List<ToDoSnapshot>>(
        stream: ToDoSnapshot.getAll(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text("Error Data"));
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

           // var docs = snapshot.data!.docs;
           // var toDoSnapshotList = docs.map((doc) => ToDoSnapshot.fromMap(doc)).toList();
           var toDoSnapshotList = snapshot.data as List<ToDoSnapshot>;
          numberOfTodo = toDoSnapshotList.length;
          return ListView.builder(
            itemCount: toDoSnapshotList.length,
            itemBuilder: (context, index) {
              var item = toDoSnapshotList[index];
              // var item = ToDoSnapshot.fromMap(docs[index]);
              return Card(
                child: ListTile(
                  title: Text(item.toDoTask.topic!),
                  subtitle: Text(item.toDoTask.time!),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          _showInputDialog(context, snapshot: item);
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () async {
                          await item.xoa();
                        },
                      ),
                    ],
                  ),
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute
                      (builder: (context) => AddNewTask(topic : item.toDoTask.topic),));
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
