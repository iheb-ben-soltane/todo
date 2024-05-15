import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:to_do/TaskProvider.dart';
import 'package:to_do/models/task.dart';

class UpdateTask extends StatefulWidget {
  final String taskId;

  UpdateTask({required this.taskId});

  @override
  _UpdateTaskState createState() => _UpdateTaskState();
}

class _UpdateTaskState extends State<UpdateTask> {
  final _formKey = GlobalKey<FormState>();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late SharedPreferences prefs;
  Task _task = Task.empty();
  String dropdownValue = 'To Do';
  String dropdownValue1 = 'Low';
  String _name = '';
  String _description = '';

  String selectedDate = '';
  String selectedTime = '';

  Future<void> _loadTaskDetails(String taskId) async {
    DocumentSnapshot doc =
        await _firestore.collection("tasks").doc(taskId).get();
    if (doc.exists) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      setState(() {
        _task = Task.fromMap(data);
        print(_task.toMap());
        _name = _task.name;
        _description = _task.description;
        selectedDate = _task.date;
        selectedTime = _task.time;
        dropdownValue = _task.state;
        dropdownValue1 = _task.priority;
      });
    } else {
      print("Document does not exist");
    }
  }

  @override
  void initState() {
    super.initState();
    _loadTaskDetails(widget.taskId);
    _initializePrefs();
  }

  Future<void> _initializePrefs() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      _task.userId = prefs.getString('Id')!;
    });
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor:
                Color.fromARGB(255, 34, 120, 154), // Header background color
            hintColor:
                const Color.fromARGB(255, 34, 120, 154), // Color of buttons
            colorScheme: ColorScheme.light(
                primary: const Color.fromARGB(255, 34, 120, 154)),
            buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _task.time = picked.format(context);
        print(_task.time);
      });
    }
  }

  Widget TimePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: [
            Text(
              "    Time: ",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            IconButton(
              onPressed: () {
                _selectTime(context);
              },
              icon: Icon(
                Icons.access_time,
                color: Color.fromARGB(255, 133, 228, 233),
              ),
            ),
          ],
        ),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.grey,
              width: 2,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(selectedTime),
          ),
        ),
      ],
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1935, 8),
      lastDate: DateTime(2101),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor:
                Color.fromARGB(255, 34, 120, 154), // Header background color
            hintColor:
                const Color.fromARGB(255, 34, 120, 154), // Color of buttons
            colorScheme: ColorScheme.light(
                primary: const Color.fromARGB(255, 34, 120, 154)),
            buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked.toString().substring(0, 10) != selectedDate) {
      setState(() {
        selectedDate = picked.toString().substring(0, 10);
        _task.date = picked.toString().substring(0, 10);
        print(_task.date);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    Widget DatePicker() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: [
              Text(
                "    Date: ",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              IconButton(
                onPressed: () {
                  _selectDate(context);
                },
                icon: Icon(
                  Icons.calendar_today,
                  color: Color.fromARGB(255, 133, 228, 233),
                ),
              ),
            ],
          ),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.grey,
                width: 2,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(selectedDate.toString().substring(0, 10)),
            ),
          ),
        ],
      );
    }

    Widget CustomDropdownState({
      required String value,
      required void Function(String?) onChanged,
      required Function(String) onSaved,
    }) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(17, 0, 0, 5),
            child: Text(
              "State:",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
          ),
          DropdownButtonFormField<String>(
            value: value,
            onChanged: (newValue) {
              onChanged(newValue);
              onSaved(newValue!); // Assign selected value to _task.state
            },
            items: [
              DropdownMenuItem(
                value: 'To Do',
                child: Text('To Do'),
              ),
              DropdownMenuItem(
                value: 'In Progress',
                child: Text('In Progress'),
              ),
              DropdownMenuItem(
                value: 'Done',
                child: Text('Done'),
              ),
            ],
            style: TextStyle(
              color: Color.fromARGB(255, 111, 111, 111),
              fontWeight: FontWeight.bold,
            ),
            icon: Icon(Icons.arrow_drop_down), // Dropdown icon
            iconSize: 24,
            elevation: 16,
            isExpanded: true, // To make the dropdown wider
            dropdownColor: Colors.white, // Dropdown background color
            focusColor: const Color.fromARGB(
                255, 34, 120, 154), // Color of the focused item
            hint: Text('Select'), // Hint text
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(horizontal: 10),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey, width: 2.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    color: Color.fromARGB(255, 133, 228, 233), width: 2.0),
              ),
              errorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.red, width: 2.0),
              ),
            ),
          ),
        ],
      );
    }

    Widget CustomDropdownPriority({
      required String value,
      required void Function(String?) onChanged,
      required Function(String) onSaved,
    }) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(17, 0, 0, 5),
            child: Text(
              "Priority:",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
          ),
          DropdownButtonFormField<String>(
            value: value,
            onChanged: (newValue) {
              onChanged(newValue);
              onSaved(newValue!);
            },
            items: [
              DropdownMenuItem(
                value: 'Low',
                child: Text('Low'),
              ),
              DropdownMenuItem(
                value: 'Medium',
                child: Text('Medium'),
              ),
              DropdownMenuItem(
                value: 'High',
                child: Text('High'),
              ),
            ],
            style: TextStyle(
              color: Color.fromARGB(255, 111, 111, 111),
              fontWeight: FontWeight.bold,
            ),
            icon: Icon(Icons.arrow_drop_down), // Dropdown icon
            iconSize: 24,
            elevation: 16,
            isExpanded: true, // To make the dropdown wider
            dropdownColor: Colors.white, // Dropdown background color
            focusColor: const Color.fromARGB(
                255, 34, 120, 154), // Color of the focused item
            hint: Text('Select'), // Hint text
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(horizontal: 10),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey, width: 2.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    color: Color.fromARGB(255, 133, 228, 233), width: 2.0),
              ),
              errorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.red, width: 2.0),
              ),
            ),
          ),
        ],
      );
    }

    Widget InputField({label, hint, required bool obscur, field}) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(17, 0, 0, 5),
            child: Text(
              label,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
          ),
          TextFormField(
              decoration: InputDecoration(
                contentPadding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                hintText: hint,
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey, width: 2.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: Color.fromARGB(255, 133, 228, 233), width: 2.0),
                ),
                errorBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red, width: 2.0),
                ),
              ),
              keyboardType: TextInputType.text,
              maxLines: null,
              obscureText: obscur,
              onChanged: field),
          SizedBox(
            height: 10,
          )
        ],
      );
    }

    Widget UPDATEBTN() => ElevatedButton(
          child: Text(
            "Update the task",
            style: TextStyle(
                color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromARGB(255, 34, 120, 154),
            padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
          ),
          onPressed: () async {
            if (_formKey.currentState!.validate()) {
              _formKey.currentState!.save();
              await Provider.of<TaskProvider>(context, listen: false)
                  .updateTask(_task);
              // Show success dialog
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    contentPadding: EdgeInsets.zero,
                    content: Container(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.check_circle_outline,
                            color: const Color.fromARGB(255, 76, 175, 165),
                            size: 48,
                          ),
                          SizedBox(height: 16),
                          Text(
                            "Task updated successfully!",
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          "OK",
                          style: TextStyle(
                              color: const Color.fromARGB(255, 34, 120, 154)),
                        ),
                      ),
                    ],
                  );
                },
              );

              print("Task updated successfully");
              print(_task.toMap());
            }
          },
        );
    Widget DELBTN() => ElevatedButton(
          child: Text(
            "Delete the task",
            style: TextStyle(
                color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Color.fromARGB(255, 232, 76, 82),
            padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
          ),
          onPressed: () async {
            if (_formKey.currentState!.validate()) {
              _formKey.currentState!.save();
              await Provider.of<TaskProvider>(context, listen: false)
                  .deleteTask(_task.id);
              // Show success dialog
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    contentPadding: EdgeInsets.zero,
                    content: Container(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.check_circle_outline,
                            color: Color.fromARGB(255, 226, 113, 132),
                            size: 48,
                          ),
                          SizedBox(height: 16),
                          Text(
                            "Task deleted successfully!",
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          "OK",
                          style: TextStyle(
                              color: const Color.fromARGB(255, 34, 120, 154)),
                        ),
                      ),
                    ],
                  );
                },
              );

              print("Task deleted successfully");
            }
          },
        );
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Edit task",
          style: TextStyle(
            color: Colors.black,
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 50,
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 35, vertical: 2),
                  child: Column(
                    children: <Widget>[
                      InputField(
                          label: 'Name:',
                          hint: _name,
                          obscur: false,
                          field: (val1) {
                            setState(() {
                              if (val1 != null) _task.name = val1;
                            });
                          }),
                      InputField(
                          label: 'Description:',
                          hint: _description,
                          obscur: false,
                          field: (val2) {
                            setState(() {
                              if (val2 != null) _task.description = val2;
                            });
                          }),
                      CustomDropdownState(
                        value: dropdownValue,
                        onChanged: (newValue) {
                          setState(() {
                            dropdownValue = newValue!;
                          });
                        },
                        onSaved: (newValue) {
                          setState(() {
                            _task.state =
                                newValue; // Assign selected value to _task.state
                          });
                        },
                      ),
                      CustomDropdownPriority(
                        value: dropdownValue1,
                        onChanged: (newValue) {
                          setState(() {
                            dropdownValue1 = newValue!;
                          });
                        },
                        onSaved: (newValue) {
                          setState(() {
                            _task.state = newValue;
                          });
                        },
                      ),
                      TimePicker(),
                      DatePicker(),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                SizedBox(
                  height: 20,
                ),
                UPDATEBTN(),
                SizedBox(
                  height: 20,
                ),
                DELBTN(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
