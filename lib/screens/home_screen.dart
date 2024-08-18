import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../helpers/database_helper.dart';
import '../models/task_model.dart';
import '../presentation/widgets/custom_check_box.dart';
import 'add_task_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Task>> _taskList;
  final DateFormat _dateFormatter = DateFormat('MMM dd, yyyy');

  @override
  void initState() {
    super.initState();
    _updateTaskList();
  }

  _updateTaskList() {
    setState(() {
      _taskList = DatabaseHelper.instance.getTaskList();
    });
  }

  Future<bool> onBackPressed() {
    return Future.value(true);
  }

  Widget _buildTask(Task task) {
    return Dismissible(
      key: UniqueKey(), // Ensure the key is unique for each task
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: const Icon(Icons.delete, color: Colors.white),
      ), // Background color and icon for swipe
      direction: DismissDirection.endToStart, // Swipe direction
      onDismissed: (direction) {
        DatabaseHelper.instance.deleteTask(task.id!);
        _updateTaskList(); // Update the task list after deletion
      },
      child: Container(
        color: task.status == 1
            ? Colors.green
            : Colors.transparent, // Set background color based on task status
        child: ListTile(
          title: Text(
            task.title,
            style: TextStyle(
              fontSize: 18.0,
              color: task.status == 1
                  ? Colors.white
                  : Colors.black87, // Adjust text color based on background
              decoration: task.status == 0
                  ? TextDecoration.none
                  : TextDecoration.lineThrough,
            ),
          ),
          subtitle: Text(
            '${_dateFormatter.format(task.date)} • ${task.priority}',
            style: TextStyle(
              fontSize: 15.0,
              color: task.status == 1
                  ? Colors.white
                  : Colors.black45, // Adjust text color based on background
              decoration: task.status == 0
                  ? TextDecoration.none
                  : TextDecoration.lineThrough,
            ),
          ),
          trailing: CustomCheckbox(
            isChecked: task.status == 1,
            onChanged: (value) {
              setState(() {
                task.status = (value ?? false) ? 1 : 0;
                DatabaseHelper.instance.updateTask(task);
                _updateTaskList(); // Update the task list after status change
              });
            },
          ),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => AddTaskScreen(
                updateTaskList: _updateTaskList,
                task: task,
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onBackPressed,
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.deepPurpleAccent,
          foregroundColor: Colors.white,
          child: const Icon(Icons.add_outlined),
          onPressed: () => Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) =>
                  AddTaskScreen(
                updateTaskList: _updateTaskList,
              ),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                const begin = Offset(1.0, 0.0);
                const end = Offset.zero;
                const curve = Curves.easeInOut;

                var tween = Tween(begin: begin, end: end)
                    .chain(CurveTween(curve: curve));
                var offsetAnimation = animation.drive(tween);

                return SlideTransition(position: offsetAnimation, child: child);
              },
            ),
          ),
        ),
        appBar: AppBar(
          backgroundColor: Colors.deepPurple,
          title: const Row(
            children: [
              Text(
                "BusyBee",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30.0,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -1.2,
                ),
              ),
            ],
          ),
          centerTitle: false,
          elevation: 0,
        ),
        backgroundColor: Colors.deepPurple,
        body: Container(
          decoration: BoxDecoration(
            color: Colors.white, // Adjust the color as needed
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(40),
              topRight: Radius.circular(40),
            ),
          ),
          child: FutureBuilder<List<Task>>(
            future: _taskList,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              final int completedTaskCount = snapshot.data!
                  .where((Task task) => task.status == 0)
                  .toList()
                  .length;

              return AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: ListView.builder(
                  key: ValueKey(snapshot
                      .data!.length), // Key to trigger animation on list change
                  padding: const EdgeInsets.symmetric(vertical: 0.0),
                  itemCount: 1 + snapshot.data!.length,
                  itemBuilder: (BuildContext context, int index) {
                    if (index == 0) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 0.0,
                            vertical: 20.0), // Added vertical padding
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                                decoration: const BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0)),
                                ),
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20.0),
                                    child: RichText(
                                      text: TextSpan(
                                        children: [
                                          TextSpan(
                                            text: '$completedTaskCount ',
                                            style: TextStyle(
                                              fontSize: 20.0,
                                              fontWeight: FontWeight.bold,
                                              color: Colors
                                                  .black, // Highlight the number of pending tasks
                                            ),
                                          ),
                                          TextSpan(
                                            text: 'out of ',
                                            style: TextStyle(
                                              fontSize: 20.0,
                                              fontWeight: FontWeight.normal,
                                              color: Colors.blueGrey,
                                            ),
                                          ),
                                          TextSpan(
                                            text: '${snapshot.data!.length} ',
                                            style: TextStyle(
                                              fontSize: 20.0,
                                              fontWeight: FontWeight.bold,
                                              color: Colors
                                                  .black, // Highlight the total number of tasks
                                            ),
                                          ),
                                          TextSpan(
                                            text: 'Tasks Pending',
                                            style: TextStyle(
                                              fontSize: 20.0,
                                              fontWeight: FontWeight.normal,
                                              color: Colors.blueGrey,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ))
                          ],
                        ),
                      );
                    }
                    return _buildTask(snapshot.data![index - 1]);
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
