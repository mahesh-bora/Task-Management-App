import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../helpers/database_helper.dart';
import '../models/task_model.dart';
import '../presentation/widgets/neumorphic_dropdown.dart';
import '../presentation/widgets/primary_container.dart';
import 'home_screen.dart';

class AddTaskScreen extends StatefulWidget {
  final Function updateTaskList;
  final Task? task;

  const AddTaskScreen({Key? key, required this.updateTaskList, this.task})
      : super(key: key);

  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _title;
  String? _priority;
  late DateTime _date;
  final TextEditingController _dateController = TextEditingController();
  final DateFormat _dateFormatter = DateFormat('MMM dd, yyyy');

  final List<String> _priorities = ['Top Focus', 'High Key', 'Zero Chill'];

  @override
  void initState() {
    super.initState();

    _title = widget.task?.title ?? '';
    _date = widget.task?.date ?? DateTime.now();
    _priority = widget.task?.priority;

    _dateController.text = _dateFormatter.format(_date);
  }

  @override
  void dispose() {
    _dateController.dispose();
    super.dispose();
  }

  Future<void> _handleDatePicker() async {
    final DateTime? date = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (date != null && date != _date) {
      setState(() {
        _date = date;
      });
      _dateController.text = _dateFormatter.format(date);
    }
  }

  void _delete() {
    if (widget.task != null) {
      DatabaseHelper.instance.deleteTask(widget.task!.id!);
      Navigator.pop(context);
      widget.updateTaskList();
    }
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      print('$_title, $_date, $_priority');

      final task =
          Task(title: _title, date: _date, priority: _priority!, status: 0);
      if (widget.task == null) {
        // Insert the task to our user's database
        task.status = 0;
        DatabaseHelper.instance.insertTask(task);
      } else {
        // Update the task
        task.id = widget.task!.id;
        task.status = widget.task!.status;
        DatabaseHelper.instance.updateTask(task);
      }

      Navigator.pop(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => HomeScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(-1.0, 0.0);
            const end = Offset.zero;
            const curve = Curves.easeInOut;

            var tween =
                Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
            var offsetAnimation = animation.drive(tween);

            return SlideTransition(position: offsetAnimation, child: child);
          },
        ),
      );
      widget.updateTaskList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white70,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.task == null ? 'Add Task' : 'Update Task',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 30.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
        elevation: 0,
      ),
      backgroundColor: Colors.deepPurple,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 10),
              Container(
                height: MediaQuery.of(context).size.height,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  ),
                ),
                padding: const EdgeInsets.symmetric(
                    horizontal: 40.0, vertical: 40.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Form(
                      key: _formKey,
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20.0),
                            child: NeumorphicInputField(
                              hintText: 'Title',
                              initialValue: _title,
                              onChanged: (value) => _title = value,
                              validator: (input) => input!.trim().isEmpty
                                  ? 'Please enter a task title'
                                  : null,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20.0),
                            child: NeumorphicInputField(
                              hintText: 'Date',
                              controller: _dateController,
                              readOnly: true,
                              onTap: _handleDatePicker,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20.0),
                            child: NeumorphicDropdownField(
                              hintText: 'Priority',
                              value: _priority,
                              items: _priorities.map((String priority) {
                                return DropdownMenuItem(
                                  value: priority,
                                  child: Text(priority),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  _priority = value as String?;
                                });
                              },
                              validator: (input) => input == null
                                  ? 'Please select a priority level'
                                  : null,
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 20.0),
                            height: 60.0,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            child: TextButton(
                              child: Text(
                                widget.task == null ? 'Add' : 'Update',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20.0,
                                ),
                              ),
                              onPressed: _submit,
                            ),
                          ),
                          if (widget.task != null)
                            Container(
                              margin: const EdgeInsets.symmetric(vertical: 0.0),
                              height: 60.0,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor,
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                              child: TextButton(
                                child: const Text(
                                  'Delete',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20.0,
                                  ),
                                ),
                                onPressed: _delete,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class NeumorphicInputField extends StatelessWidget {
  final String hintText;
  final String? initialValue;
  final TextEditingController? controller;
  final bool readOnly;
  final Function(String)? onChanged;
  final Function()? onTap;
  final String? Function(String?)? validator;

  const NeumorphicInputField({
    Key? key,
    required this.hintText,
    this.initialValue,
    this.controller,
    this.readOnly = false,
    this.onChanged,
    this.onTap,
    this.validator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PrimaryContainer(
      child: TextFormField(
        initialValue: initialValue,
        controller: controller,
        readOnly: readOnly,
        onChanged: onChanged,
        onTap: onTap,
        validator: validator,
        style: const TextStyle(fontSize: 18, color: Colors.black45),
        decoration: InputDecoration(
          filled: false,
          contentPadding: EdgeInsets.only(left: 20, right: 20, bottom: 3),
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          hintText: hintText,
          hintStyle: TextStyle(fontSize: 14, color: Colors.grey),
        ),
      ),
    );
  }
}
