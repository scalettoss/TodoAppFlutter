import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:project_final/todo_app/controller/task_controller.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          decoration: const InputDecoration(label: Text("Tiêu đề")),
          onSubmitted: (value) {
            Provider.of<TaskController>(context, listen: false).changeTodoName(value);
          },
        ),

      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                Expanded(
                  child: Consumer<TaskController>(
                    builder: (context, controller, child) => TextField(
                      controller: controller.controller,
                      decoration: const InputDecoration(
                        labelText: "Thêm nhiệm vụ mới",
                        hintText: "Nhập nhiệm vụ mới",
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                FloatingActionButton(
                  onPressed: () {
                    Provider.of<TaskController>(context, listen: false)
                        .addNewTask();
                  },
                  child: const Icon(Icons.add),
                ),
              ],
            ),
          ),
          Expanded(
            child: Consumer<TaskController>(
              builder: (context, controller, child) => controller.tasks.isEmpty
                  ? const Center(child: Text('Không có nhiệm vụ nào!'))
                  : ListView.builder(
                      itemCount: controller.tasks.length,
                      itemBuilder: (context, index) {
                        return Dismissible(
                          key: Key(controller.tasks[index].name),
                          direction: DismissDirection.endToStart,
                          onDismissed: (direction) {
                            controller.deleteTask(index);
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
                            leading: Checkbox(
                              value: controller.tasks[index].isCompleted,
                              onChanged: (value) {
                                controller.toggleTaskCompletion(index, value);
                              },
                            ),
                            title: Text(
                              controller.tasks[index].name,
                              style: TextStyle(
                                decoration: controller.tasks[index].isCompleted
                                    ? TextDecoration.lineThrough
                                    : TextDecoration.none,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
