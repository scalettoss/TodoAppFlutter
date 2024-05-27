
import 'package:cloud_firestore/cloud_firestore.dart';

class Task {
  final String name;
  bool isCompleted;
  Task({required this.name, this.isCompleted = false});
}

class ToDoTask{
  String? taskName, createBy;
  bool? isCompleted;
  Timestamp? createAt;
  String? topic;
  String? time;

  ToDoTask({
    required this.taskName,
    required this.topic,
    required this.time,
    required this.isCompleted,
    required this.createBy,
    required this.createAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'taskName': taskName,
      'createBy': createBy,
      'isCompleted': isCompleted,
      'createAt': createAt,
      'topic': topic,
      'time': time,
    };
  }

  factory ToDoTask.fromJson(Map<String, dynamic> map) {
    return ToDoTask(
      taskName: map['taskName'] as String,
      createBy: map['createBy'] as String,
      isCompleted: map['isCompleted'] as bool,
      createAt: map['createAt'] as Timestamp,
      topic: map['topic'] as String,
      time: map['time'] as String,
    );
  }
}
class ToDoSnapshot {
  final ToDoTask toDoTask;
  final DocumentReference ref;

  ToDoSnapshot({
    required this.toDoTask,
    required this.ref
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
