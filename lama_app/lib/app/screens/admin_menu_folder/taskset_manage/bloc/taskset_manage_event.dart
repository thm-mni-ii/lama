import 'package:flutter/material.dart';
import 'package:lama_app/app/screens/admin_menu_folder/taskset_manage/screens/taskset_manage_screen.dart';
import 'package:lama_app/app/task-system/taskset_model.dart';

/// Events used by [TasksetManageScreen] and [TasksetManageBloc]
///
/// Author: N. Soethe
/// latest Changes: 28.05.2022
abstract class TasksetManageEvent {}

class CreateTaskset extends TasksetManageEvent {}

/// adds a taskset to the pool of used tasksets
class AddTasksetPool extends TasksetManageEvent {
  final BuildContext context;
  final Taskset taskset;

  AddTasksetPool({required this.context, required this.taskset});
}

/// removes a taskset from the pool of used tasksets
class RemoveTasksetPool extends TasksetManageEvent {
  final BuildContext context;
  final Taskset taskset;

  RemoveTasksetPool({required this.context, required this.taskset});
}

class AddListOfTasksetsPool extends TasksetManageEvent {
  final BuildContext context;
  final List<Taskset> tasksetList;

  AddListOfTasksetsPool(this.context, this.tasksetList);
}

class RemoveListOfTasksetsPool extends TasksetManageEvent {
  final BuildContext context;
  final List<Taskset> tasksetList;

  RemoveListOfTasksetsPool(this.context, this.tasksetList);
}

class DeleteTaskset extends TasksetManageEvent {
  final Taskset taskset;
  final BuildContext context;

  DeleteTaskset(this.taskset, this.context);
}

class UploadTaskset extends TasksetManageEvent {
  final Taskset taskset;
  final BuildContext context;

  UploadTaskset(this.taskset, this.context);
}
