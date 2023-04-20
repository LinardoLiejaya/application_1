import 'package:flutter/material.dart';
import 'package:to_do_list/login_page.dart';

class TodoList extends StatefulWidget {
  @override
  _TodoListState createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  final List<String> _todoItems = [];

  final screen = [TodoList(), LoginPage()];

  void _addTodoItem(String task) {
    if (task.length > 0) {
      setState(() => _todoItems.add("□ $task"));
    }
  }

  void _removeTodoItem(int index) {
    setState(() => _todoItems.removeAt(index));
  }

  void _toggleTodoItem(int index) {
    final String item = _todoItems[index];
    setState(() {
      if (item.startsWith('□')) {
        _todoItems[index] = '✓' + item.substring(1);
      } else {
        _todoItems[index] = '□' + item.substring(1);
      }
    });
  }

  Widget _buildTodoItem(String todoText, int index) {
    return ListTile(
      title: Text(todoText),
      trailing: Checkbox(
        value: todoText.startsWith('✓'),
        onChanged: (bool? isChecked) {
          _toggleTodoItem(index);
        },
      ),
      onTap: () => _removeTodoItem(index),
    );
  }

  Widget _buildTodoList() {
    final completedTasks =
        _todoItems.where((item) => item.startsWith('✓')).length;
    final totalTasks = _todoItems.length;

    return Column(
      children: [
        LinearProgressIndicator(
          value: totalTasks == 0 ? 1 : completedTasks / totalTasks,
          backgroundColor: Colors.grey[300],
          valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
        ),
        Expanded(
          child: ListView.builder(
            itemBuilder: (BuildContext context, int index) {
              if (index < _todoItems.length) {
                return _buildTodoItem(_todoItems[index], index);
              }
            },
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo List'),
      ),
      body: _buildTodoList(),
      floatingActionButton: FloatingActionButton(
        onPressed: _pushAddTodoScreen,
        tooltip: 'Add task',
        child: const Icon(Icons.add),
      ),
    );
  }

  void _pushAddTodoScreen() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Add a new task'),
            ),
            body: TextField(
              autofocus: true,
              onSubmitted: (val) {
                _addTodoItem(val);
                Navigator.pop(context);
              },
              decoration: const InputDecoration(
                hintText: 'Enter something to do...',
                contentPadding: EdgeInsets.all(16.0),
              ),
            ),
          );
        },
      ),
    );
  }
}
