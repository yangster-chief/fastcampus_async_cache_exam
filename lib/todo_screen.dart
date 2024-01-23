import 'package:async_cache_exam/data/todo_repository.dart';
import 'package:async_cache_exam/model/todo.dart';
import 'package:flutter/material.dart';

///
/// async_cache_exam
/// File Name: todo_screen
/// Created by sujangmac
///
/// Description:
///
class ToDoScreen extends StatefulWidget {
  final ToDoRepository repository;
  const ToDoScreen({super.key, required this.repository});

  @override
  State<ToDoScreen> createState() => _ToDoScreenState();
}

class _ToDoScreenState extends State<ToDoScreen> {
  void _addNewTodo() async {
    final text = await _showAddToDoDialog();
    if (text != null && text.isNotEmpty) {
      widget.repository.createToDo(text);
    }
  }

  Future<String?> _showAddToDoDialog() {
    TextEditingController controller = TextEditingController();
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('New ToDo'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: 'Enter ToDo text here'),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel')),
          TextButton(
              onPressed: () => Navigator.of(context).pop(controller.text),
              child: const Text('Add')),
        ],
      ),
    );
  }

  void _toggleToDoStatus(ToDo toDo) {
    widget.repository.updateToDo(toDo.id);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('ToDo List')),
        body: RefreshIndicator(
          onRefresh: () async {
            await widget.repository.refreshToDos();
          },
          child: StreamBuilder<List<ToDo>>(
            stream: widget.repository.toDosStream,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting &&
                  !snapshot.hasData) {
                return const CircularProgressIndicator();
              }
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              }
              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Text('No ToDo items');
              }
              return ListView(
                children: snapshot.data!
                    .map(
                      (toDo) => ToDoItem(
                        toDo,
                        onChecked: () => _toggleToDoStatus(toDo),
                      ),
                    )
                    .toList(),
              );
            },
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _addNewTodo,
          tooltip: 'Add ToDo',
          child: const Icon(Icons.add),
        ),
      );
}

class ToDoItem extends StatelessWidget {
  final ToDo toDo;
  final VoidCallback onChecked; // Callback for when the item is checked
  const ToDoItem(this.toDo, {super.key, required this.onChecked});

  @override
  Widget build(BuildContext context) => ListTile(
        title: Text(toDo.text),
        leading: Checkbox(
          value: toDo.done,
          onChanged: (bool? value) => onChecked(),
        ),
      );
}
