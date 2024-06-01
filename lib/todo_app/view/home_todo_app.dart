import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_final/todo_app/model/task.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeTodoApp extends StatefulWidget {
  const HomeTodoApp({super.key, required this.title});
  final String title;

  @override
  _HomeTodoAppState createState() => _HomeTodoAppState();
}

class _HomeTodoAppState extends State<HomeTodoApp> {
  final TextEditingController txtnameTopic = TextEditingController();
  TimeOfDay selectedTime = TimeOfDay.now();
  bool hienThiInputName = false;
  Future<String> _getUserNameFromSP() async {
    final prefs = await SharedPreferences.getInstance();
    String userName = "";
    userName = prefs.getString('userName') ?? "";
    return userName;
  }

  void _setUserNameToSP(String userName) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userName', userName);
  }

  void _removeUserNameFromSP() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('userName');
  }

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
                setState(() {});
              },
              child: const Text('Lưu'),
            ),
          ],
        );
      },
    );
  }

  Widget _inputName() {
    if (!hienThiInputName) {
      return ListTile(
        title: const Text("Thay đổi tên người dùng"),
        leading: const Icon(Icons.people),
        onTap: () {
          _removeUserNameFromSP();
          setState(() {
            hienThiInputName = true;
          });
        },
      );
    } else {
      return TextField(
        onSubmitted: (value) {
          _setUserNameToSP(value);
          setState(() {
            hienThiInputName = false;
          });
        },
        decoration: const InputDecoration(label: Text("Người dùng")),
        maxLines: 1,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    int numberOfTodo = 0;
    Future<String> userName = _getUserNameFromSP();
    String userName0 = "";
    userName.then((value) => userName0 = value);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home App Todo"),
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
              accountName: FutureBuilder(
                future: userName,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Text(userName0);
                  } else if (snapshot.hasError)
                    return const Text("Error");
                  else
                    return const CircularProgressIndicator();
                },
              ),
              accountEmail: const Text("email"),
            ),
            ListTile(
              title: Text("Số lượng todo hiện tại: $numberOfTodo"),
              leading: const Icon(Icons.numbers),
            ),
            _inputName(),
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
                    // Navigator.push(context, MaterialPageRoute
                    //   (builder: (context) => addNewTask(),));
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
