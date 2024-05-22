import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_final/todo_app/model/task.dart';

class Task {
  final String name;
  bool isCompleted;
  Task({required this.name, this.isCompleted = false});
}

class ToDoTask{
    String? taskName, createBy;
    bool? isCompleted;
    Timestamp? createAt;
    ToDoTask({ required this.taskName,required this.createBy,required this.isCompleted,required this.createAt});

    Map<String, dynamic> toJson() {
      return {
        'taskName': this.taskName,
        'createBy': this.createBy,
        'isCompleted': this.isCompleted,
        'createAt': this.createAt,
      };
    }

    factory ToDoTask.fromJson(Map<String, dynamic> map) {
      return ToDoTask(
        taskName: map['taskName'] as String,
        createBy: map['createBy'] as String,
        isCompleted: map['isCompleted'] as bool,
        createAt: map['createAt'] as Timestamp,
      );
    }
}
class ToDoSnapshot{
  ToDoTask toDoTask;
  DocumentReference ref;
  ToDoSnapshot({
      required this.toDoTask,
      required this.ref,
  });
  factory ToDoSnapshot.fromMap(DocumentSnapshot docSnap){
      return ToDoSnapshot(toDoTask: ToDoTask.fromJson(docSnap.data() as Map<String, dynamic>), ref: docSnap.reference);
  }
  static Future<void> updateTaskStatus(DocumentReference ref, bool isCompleted) async {
      await ref.update({'isCompleted': isCompleted});
  }
  Future<void> xoa(){
      return ref.delete();
  }
  Future<void> them(ToDoTask newTask) async {
      final CollectionReference tasksCollection = FirebaseFirestore.instance.collection('ToDoDB');
      await tasksCollection.add(newTask.toJson());
  }
  static Stream<List<ToDoSnapshot>> getAll(){
      Stream<QuerySnapshot> sqs = FirebaseFirestore.instance.collection("ToDoDB").snapshots();
      return sqs.map((qs) => qs.docs.map((docSnap) => ToDoSnapshot.fromMap(docSnap)).toList());
  }
}


