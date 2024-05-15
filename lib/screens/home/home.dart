import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:to_do/TaskProvider.dart';
import 'package:to_do/models/task.dart';
import 'package:to_do/screens/updateTask/updateTask.dart';

class DisplayTasksScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tasks'), // Set the title to "Tasks"
      ),
      body: Consumer<TaskProvider>(
        builder: (context, taskProvider, _) {
          return ActivitiesList(taskProvider: taskProvider);
        },
      ),
    );
  }
}

class ActivitiesList extends StatefulWidget {
  final TaskProvider taskProvider;

  ActivitiesList({required this.taskProvider});

  @override
  _ActivitiesListState createState() => _ActivitiesListState();
}

class _ActivitiesListState extends State<ActivitiesList> {
  late Future<void> _futureFetchTasks;

  @override
  void initState() {
    super.initState();
    _futureFetchTasks = _fetchTasks();
  }

  Future<void> _fetchTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final id = prefs.getString('Id') ?? '';
    await widget.taskProvider.fetchTasks(userId: id);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _futureFetchTasks,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(
              color: Color.fromARGB(255, 82, 201, 231),
            ),
          );
        }

        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        final tasks = widget.taskProvider.getTasks();

        if (tasks.isEmpty) {
          return Center(
            child: Text('No tasks available.'),
          );
        }

        return ListView.builder(
          itemCount: tasks.length,
          itemBuilder: (context, index) {
            Task task = tasks[index];
            return TaskItem(task: task);
          },
        );
      },
    );
  }
}

class TaskItem extends StatelessWidget {
  final Task task;

  TaskItem({required this.task});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigate to the UpdateTask screen and pass the task ID
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => UpdateTask(taskId: task.id),
          ),
        );
      },
      child: Card(
        margin: EdgeInsets.all(8.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 137, 231, 247),
                Color.fromARGB(255, 246, 246, 246)
              ], // Define your gradient colors
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(10.0),
          ),
          padding: EdgeInsets.all(12.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.event,
                size: 40.0,
                color: const Color.fromARGB(255, 255, 255, 255),
              ),
              SizedBox(width: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    task.name, // Use task properties
                    style: TextStyle(
                      fontSize: 15.0,
                      color: Color.fromARGB(255, 27, 131, 156),
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Date: ${task.date}', // Use task properties
                    style: TextStyle(
                      fontSize: 12.0,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'State: ${task.state}', // Use task properties
                    style: TextStyle(
                      fontSize: 12.0,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
              Spacer(),
              Column(
                children: [
                  SizedBox(height: 10),
                  Icon(
                    Icons.arrow_forward_ios,
                    color: Color.fromARGB(255, 137, 210, 247),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
