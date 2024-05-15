import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:to_do/models/task.dart';

class TaskProvider with ChangeNotifier {
  List<Task> tasks = [];

  Future<void> fetchTasks({required String userId}) async {
    tasks.clear(); // Clear the current list of tasks
    var querySnapshot = await FirebaseFirestore.instance
        .collection("tasks")
        .where("userId", isEqualTo: userId)
        .get();

    for (var doc in querySnapshot.docs) {
      Task task = Task.fromMap(doc.data() as Map<String, dynamic>);
      tasks.add(task);
    }
    notifyListeners();
  }

  // Function to add a new task to Firestore
  Future<void> addTask(Task task) async {
    var docRef =
        await FirebaseFirestore.instance.collection("tasks").add(task.toMap());
    task.id = docRef.id;
    await docRef.set(task.toMap());
    tasks.add(task);
    for (var t in tasks) {
      print(t.toMap());
    }
    print(task.toMap());
    notifyListeners();
  }

  // Function to update an existing task in Firestore
  Future<void> updateTask(Task task) async {
    // First, update the task in Firestore
    await FirebaseFirestore.instance
        .collection("tasks")
        .doc(task.id)
        .update(task.toMap());

    // Then, find the task in the local list and replace it with the updated version
    int index = tasks.indexWhere((t) => t.id == task.id);
    if (index != -1) {
      tasks[index] = task; // Replace the old task with the updated one
    }

    // Notify listeners to refresh the UI
    notifyListeners();
  }

  // Function to delete a task from Firestore
  Future<void> deleteTask(String taskId) async {
    await FirebaseFirestore.instance.collection("tasks").doc(taskId).delete();
    tasks.removeWhere((task) => task.id == taskId);
    notifyListeners();
  }

  // Function to get the list of tasks
  List<Task> getTasks() {
    return tasks;
  }

  // Function to get a task by its index in the list
  Task getTaskByIndex(int index) {
    return tasks[index];
  }

  // Function to get the number of tasks
  int getTaskCount() {
    return tasks.length;
  }
}
