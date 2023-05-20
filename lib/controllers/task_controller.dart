import 'package:flutter_booktickets_app/db/db_helper.dart';
import 'package:get/get.dart';

import '../models/task.dart';

class TaskController extends GetxController{

  @override
  void onReady() {
    super.onReady();
  }

  var taskList = <Task>[].obs;

  // add Task table the data from widgets
  Future<int> addTask({Task? task}) async {
    return await DBHelper.insert(task);
  }

  // get all the data from table
  void getTasks() async {
    List<Map<String, dynamic>> tasks = await DBHelper.query();
    taskList.assignAll(tasks.map((data) => Task.fromJson(data)).toList());
  }

  void delete(Task task) {
    DBHelper.delete(task);
    getTasks();
  }

  Future<void> markTaskCompleted(int id) async {
    await DBHelper.update(id);
    getTasks();
  }
}