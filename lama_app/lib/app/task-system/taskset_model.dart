import 'package:lama_app/app/task-system/task.dart';
import 'package:lama_app/db/database_provider.dart';

class Taskset {
  String name;
  String subject;
  int grade;
  bool randomizeOrder;
  int randomTaskAmount;
  List<Task> tasks;

  //This method creates a Taskset from the passed json
  Taskset.fromJson(Map<String, dynamic> json) {
    name = json['taskset_name'];
    subject = json['taskset_subject'];
    grade = json['taskset_grade'];
    var tasksetTasks = json['tasks'] as List;
    List<Task> tasksetTasksList =
        tasksetTasks.map((e) => Task.fromJson(e)).toList();
    for (int i = 0; i < tasksetTasksList.length; i++) {
      DatabaseProvider.db.setDoesStillExist(tasksetTasksList[i]);
    }
    tasks = tasksetTasksList;
    if (!json.containsKey('taskset_choose_amount')) {
      randomTaskAmount = tasks.length;
      if (json.containsKey('taskset_randomize_order')) {
        randomizeOrder = json["taskset_randomize_order"];
      } else
        randomizeOrder = false;
    } else {
      randomTaskAmount = json['taskset_choose_amount'];
    }
  }
}
