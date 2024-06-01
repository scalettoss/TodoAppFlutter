import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:project_final/todo_app/model/task.dart';
import 'package:project_final/todo_app/controller/task_controller.dart';
import 'package:provider/provider.dart';

class AddNewTask extends StatefulWidget {
  final String? topic;
  const AddNewTask({Key? key, this.topic}) : super(key: key);


  @override
  State<AddNewTask> createState() => _AddNewTaskState();
}

class _AddNewTaskState extends State<AddNewTask> {
  TextEditingController txtnameTask = TextEditingController();

  void _showInputDialog(BuildContext context, {ToDoSnapshot? snapshot}) {
    if (snapshot != null) {
      txtnameTask.text = snapshot.toDoTask.taskName!;
    } else {
      txtnameTask.clear();
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Nhập task"),
          content: TextField(
            controller: txtnameTask,
            decoration: InputDecoration(labelText: 'Nhập task'),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Hủy'),
            ),
            TextButton(
              onPressed: () async {
                if (txtnameTask.text.isNotEmpty) {
                  String newTaskName = txtnameTask.text;
                  if (snapshot != null) {
                    // Update existing task
                    await snapshot.ref.update({
                      'taskName': newTaskName,
                      'createBy': 'Bao',
                      'createAt': DateTime.now(),
                      'isCompleted': snapshot.toDoTask.isCompleted,
                    });
                  } else {
                    // Add new task
                    await FirebaseFirestore.instance.collection("ToDoDB").add({
                      'taskName': newTaskName,
                      'createBy': 'Bao',
                      'createAt': Timestamp.now(),
                      'isCompleted': false,
                    });
                  }
                  Navigator.of(context).pop();
                }
              },
              child: Text('Lưu'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home Page"),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              _showInputDialog(context);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                Expanded(
                    child: SizedBox(
                      height: 55,
                      width: MediaQuery.of(context).size.width,
                      child: TextFormField(
                        controller: txtnameTask,
                        decoration: const InputDecoration(
                          hintText: "Nhập nhiệm vụ mới",
                        ),
                        validator: (value){
                          if (value == null || value.isEmpty) {
                            return 'Vui lòng nhập nhiệm vụ';
                          }
                          return null;
                        },
                      ),
                    )),
                FloatingActionButton(
                  onPressed: () {
                    if(txtnameTask.text.isNotEmpty){
                      String newtaskName = txtnameTask.text;
                      FirebaseFirestore.instance.collection("ToDoDB").add({
                        'taskName': newtaskName,
                        'createBy': 'Bao',
                        'createAt': DateTime.now(),
                        'isCompleted': false,
                      });
                      txtnameTask.clear();
                    }
                  },
                  child: const Icon(Icons.add),
                ),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance.collection("ToDoDB").snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return const Center(child: Text("Error Data"),);
                }
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator(),);
                }

                var docs = snapshot.data!.docs;
                var toDoSnapshotList = docs.map((doc) => ToDoSnapshot.fromMap(doc)).toList();

                return ListView.builder(
                  itemCount: toDoSnapshotList.length,
                  itemBuilder: (context, index) {
                    var toDoSnapshot = toDoSnapshotList[index];
                    return Dismissible(
                      key: Key(toDoSnapshot.toDoTask.taskName!),
                      direction: DismissDirection.endToStart,
                      onDismissed: (direction) async {
                        await toDoSnapshot.xoa();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Đã xóa 1 nhiệm vụ'),
                          ),
                        );
                      },
                      background: Container(
                        color: Colors.red,
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: const Icon(
                          Icons.delete,
                          color: Colors.white,
                        ),
                      ),
                      child: ListTile(
                        trailing: Checkbox(
                          value: toDoSnapshot.toDoTask.isCompleted!,
                          onChanged: (value) async {
                            if (value != null) {
                              await ToDoSnapshot.updateTaskStatus(toDoSnapshot.ref, value);
                            }
                          },
                        ),
                        title: Text(
                          toDoSnapshot.toDoTask.taskName!,
                          style: TextStyle(
                            decoration: toDoSnapshot.toDoTask.isCompleted!
                                ? TextDecoration.lineThrough
                                : TextDecoration.none,
                          ),
                        ),
                        subtitle: Text(
                          'Created at: ${DateFormat('dd/MM/yy HH:mm').format(toDoSnapshot.toDoTask.createAt!.toDate())}',
                        ),
                        onTap: () {
                          _showInputDialog(context, snapshot: toDoSnapshot);
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
