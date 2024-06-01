import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:project_final/todo_app/model/task.dart';
import 'package:provider/provider.dart';
import 'package:project_final/todo_app/controller/task_controller.dart';

class AddNewTask extends StatefulWidget {
  final String? topic;
  const AddNewTask({Key? key, this.topic}) : super(key: key);

  @override
  State<AddNewTask> createState() => _AddNewTaskState();
}

class _AddNewTaskState extends State<AddNewTask> {
  TextEditingController txtnameTask = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.topic!),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),

      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                Expanded(
                    child: Container(
                      height: 55,
                      width: MediaQuery.of(context).size.width,
                      child: TextFormField(
                        controller: txtnameTask,
                        decoration: InputDecoration(
                          hintText: "Nhap nhiem vu moi",
                        ),
                        validator: (value){
                          if (value == null || value.isEmpty) {
                            return 'Vui long nhap nhiem vu';
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
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(child: Text("Error Data"),);
                  }
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator(),);
                  }
                  var docs = snapshot.data!.docs;
                  var toDoSnapshotList = docs.map((doc) => ToDoSnapshot.fromMap(doc)).toList();
                  // toDoSnapshotList.sort((a, b) => a.toDoTask.createAt!.compareTo(b.toDoTask.createAt!));

                  return ListView.builder(
                    itemCount: toDoSnapshotList.length,
                    itemBuilder: (context, index) {
                      var toDoSnapshot = ToDoSnapshot.fromMap(docs[index]);
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
                                await ToDoSnapshot.updateTaskStatus(docs[index].reference, value!);
                              },
                            ),
                            title: Text(toDoSnapshot.toDoTask.taskName!,
                              style: TextStyle(
                                decoration: toDoSnapshot.toDoTask.isCompleted! ? TextDecoration.lineThrough : TextDecoration.none,
                              ),),
                            subtitle: Text('Created at: ${DateFormat('dd/MM/yy HH:mm').format(toDoSnapshot.toDoTask.createAt!.toDate())}'),
                          ));
                    },
                  );
                },
              )
          ),
        ],
      ),
    );
  }
}
