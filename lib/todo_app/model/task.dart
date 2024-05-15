class Task {
  final String name;
  bool isCompleted;

  Task({required this.name, this.isCompleted = false});
}
// class Todo{
//   final String name;
//   bool isCompleted; // Khi tất cả các task đều hoàn thành
//   List<Task> tasks = List.empty() ;
//   Todo({
//     required this.name,
//     required this.isCompleted,
//   });
//   void addTask(Task task) {
//     tasks.add(task);
//   }
//   void delTask(Task task) {
//     tasks.remove(task);
//   }
// }