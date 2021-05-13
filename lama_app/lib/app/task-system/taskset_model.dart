import 'package:lama_app/app/task-system/task.dart';

class Taskset {
  String name;
  String subject;
  int grade;
  List<Task> tasks;

  //This method creates a Taskset from the passed json
  Taskset.fromJson(Map<String, dynamic> json) {
    name = json['taskset_name'];
    subject = json['taskset_subject'];
    grade = json['taskset_grade'];
    var tasksetTasks = json['tasks'] as List;
    List<Task> tasksetTasksList =
        tasksetTasks.map((e) => Task.fromJson(e)).toList();
    tasks = tasksetTasksList;
  }
}