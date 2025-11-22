import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:taskapp/model/task.dart';

final tasksProvider = FutureProvider<List<Task>?>(
  (ref) async {
    final taskSharedPref = TaskSharedPreferences();

    return await taskSharedPref.getTasks();
  },
);

final addTaskProvider = FutureProvider.family(
  (ref, Task task) async {
    final taskSharedPref = TaskSharedPreferences();
    await taskSharedPref.setTask(task);
  },
);

final removeTaskProvider = FutureProvider.family(
  (ref, Task task) async {
    final taskSharedPref = TaskSharedPreferences();
    await taskSharedPref.deleteTask(task);
  },
);

final changeTaskStatusProvider = FutureProvider.family(
  (ref, Task task) async {
    final taskSharedPref = TaskSharedPreferences();
    await taskSharedPref.changeTaskStatus(task);
  },
);

class TaskSharedPreferences {
  Future<void> setTask(Task task) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    List<Task> tasks = [];
    String? tasksJson = prefs.getString('tasks');

    if (tasksJson != null) {
      try {
        List decoded = jsonDecode(tasksJson);
        tasks = decoded.map((data) => Task.fromJson(data)).toList();
      } catch (e) {
        print('Exception at parcing json: $e');
      }
    }

    tasks.add(task);

    String jsonString = jsonEncode(tasks.map((data) => data.toJson()).toList());
    await prefs.setString('tasks', jsonString);
  }

  Future<void> deleteTask(Task taskForDelete) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? tasksJson = prefs.getString('tasks');

    if (tasksJson != null) {
      List decoded = jsonDecode(tasksJson);
      List<Task> tasks = decoded.map((data) => Task.fromJson(data)).toList();

      tasks.removeWhere((task) => task.id == taskForDelete.id);

      String encoded = jsonEncode(tasks.map((task) => task.toJson()).toList());
      prefs.setString('tasks', encoded);
    }
  }

  Future<void> changeTaskStatus(
    Task selectedTask,
  ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? tasksJson = prefs.getString('tasks');

    if (tasksJson != null) {
      List decoded = jsonDecode(tasksJson);
      List<Task> tasks = decoded.map((data) => Task.fromJson(data)).toList();

      final task = tasks.firstWhere((task) => task.id == selectedTask.id);

      if (task.status == TaskStatus.inprocess) {
        task.status = TaskStatus.completed;
      } else {
        task.status = TaskStatus.inprocess;
      }

      String encoded = jsonEncode(tasks.map((task) => task.toJson()).toList());
      prefs.setString('tasks', encoded);
    }
  }

  Future<List<Task>?> getTasks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? tasksJson = prefs.getString('tasks');
    if (tasksJson != null) {
      List decoded = jsonDecode(tasksJson);
      List<Task> tasks = decoded.map((data) => Task.fromJson(data)).toList();

      return tasks;
    }

    return [];
  }
}
