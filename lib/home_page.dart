import 'package:flutter/material.dart';
import 'package:to_do_app/db.dart'; // Your database class
import 'package:to_do_app/util/dialog_box.dart';
import 'package:to_do_app/util/todo_tile.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _controller = TextEditingController();
  // Change to List<Map<String, dynamic>> for correct type
  List<Map<String, dynamic>> toDoList = []; 

  @override
  void initState() {
    super.initState();
    _refreshTaskList(); // Load tasks when the app starts
  }

  Future<void> _refreshTaskList() async {
    List<Map<String, dynamic>> tasks = await sql_db().getdb(); // Fetch tasks from the database
    setState(() {
      toDoList = tasks; // Update the task list
    });
  }

  void ChechBoxChanged(bool? value, int index) {
    int newDoneStatus = value! ? 1 : 0; // Convert bool to int
    sql_db().updatedb(newDoneStatus, toDoList[index]['id']); // Update in the database    
    setState(() {
      toDoList[index]['done'] = newDoneStatus; // Update the UI
    });
  }

  void savenewtask() async {
    String title = _controller.text;
    await sql_db().insertdb(title); // Insert new task into the database
    _controller.clear(); // Clear the input field
    Navigator.of(context).pop(); // Close the dialog
    await _refreshTaskList(); // Refresh the task list
  }

  void CreateNewTask() {
    showDialog(
      context: context,
      builder: (context) {
        return DialogBox(
          controller: _controller,
          onsave: savenewtask,
          oncancel: () => Navigator.of(context).pop(),
        );
      },
    );
  }

  void deletetask(int index) async {
    await sql_db().deletedb(toDoList[index]['id']); // Delete from the database
    setState(() {
      toDoList.removeAt(index); // Remove from the UI
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(167, 117, 7, 150),
      appBar: AppBar(
        title: Center(
          child: Text(
            'TO DO',
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: CreateNewTask,
        child: Icon(Icons.add),
      ),
      body: ListView.builder(
        itemCount: toDoList.length,
        itemBuilder: (context, index) {
          return ToDoTile(
            taskname: toDoList[index]['title'],
            taskcompleted: toDoList[index]['done'] == 1,
            onchanged: (value) => ChechBoxChanged(value, index),
            deletefunction: (context) => deletetask(index),
          );
        },
      ),
    );
  }
}
