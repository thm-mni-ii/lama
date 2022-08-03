import 'dart:math';

import 'package:lama_app/app/model/taskUrl_model.dart';
import 'package:lama_app/app/task-system/task.dart';
import 'package:lama_app/db/database_provider.dart';

///Model that represents a single taskset.
///
///Provides a named constructor [Taskset.fromJson()] to build a [Taskset] from JSON.
///
///Author: K.Binder
class Taskset {
  String? name;
  TaskUrl? taskurl;
  String? subject;
  String? description;
  int? grade;
  bool? randomizeOrder;
  int? randomTaskAmount;
  List<Task>? tasks;
  bool isInPool = false;

  Taskset(this.name, this.subject, this.description, this.grade,
      {this.randomizeOrder = true});

  Taskset.fromJson(Map<String, dynamic> json) {
    //Taskset(json['taskset_name'], json['taskset_subject'], json['taskset_description'], json['taskset_grade']);
    name = json['taskset_name'];
    taskurl = TaskUrl.fromMap(json['taskset_url']);
    isInPool = json["is_in_Pool"];
    subject = json['taskset_subject'];
    description = json['taskset_description'];
    grade = json['taskset_grade'];
    var tasksetTasks = json['tasks'] as List;
    List<Task> tasksetTasksList =
        tasksetTasks.map((e) => Task.fromJson(e)).toList();
    for (int i = 0; i < tasksetTasksList.length; i++) {
      DatabaseProvider.db.setDoesStillExist(tasksetTasksList[i]);
    }
    tasks = tasksetTasksList;
    if (!json.containsKey('taskset_choose_amount')) {
      randomTaskAmount = tasks!.length;
      if (json.containsKey('taskset_randomize_order')) {
        randomizeOrder = json["taskset_randomize_order"];
      } else {
        randomizeOrder = false;
      }
    } else {
      randomTaskAmount = min(tasks!.length, json['taskset_choose_amount']);
    }
  }

  Map<String, dynamic> toJson() => {
        "taskset_url": taskurl?.toJson(),
        "taskset_name": name,
        "is_in_Pool": isInPool,
        "taskset_subject": subject,
        "taskset_description": description,
        "taskset_grade": grade,
        "taskset_randomize_order": randomizeOrder,
        "tasks": tasks!.map((task) => task.toJson()).toList(),
      };
}
