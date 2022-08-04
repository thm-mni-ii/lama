import 'package:flutter/cupertino.dart';
import 'package:lama_app/app/bloc/create_taskset_bloc.dart';
import 'package:lama_app/app/model/taskUrl_model.dart';
import 'package:lama_app/app/screens/admin_menu_folder/taskset_creation_screen.dart';
import 'package:lama_app/app/task-system/task.dart';

import '../task-system/taskset_model.dart';

/// Events used by [TasksetCreationScreen] and [CreateTasksetBloc]
///
/// Author: N. Soethe
/// latest Changes: 09.06.2022
abstract class CreateTasksetEvent {}

/// used to change [Taskset]subtitle in Bloc
/// this param isnt used yet, must be implemented later
///
/// {@param}[String] subtitle that should be set
class CreateTasksetChangeSubtitle extends CreateTasksetEvent {
  String subtitle;
  CreateTasksetChangeSubtitle(this.subtitle);
}

/// used to generate a JSON file from the given [Taskset] object
///
/// {@param}[Taskset] taskset that should be generated
class CreateTasksetGenerate extends CreateTasksetEvent {
  Taskset taskset;
  BuildContext context;
  List<Task> taskList;
  CreateTasksetGenerate(this.taskset, this.context, this.taskList);
}

/// used to abort the process
///
/// {@param}[BuildContext] as context
class CreateTasksetAbort extends CreateTasksetEvent {
  BuildContext context;
  CreateTasksetAbort(this.context);
}

/// Provides the editable taskset
class EditTaskset extends CreateTasksetEvent {
  final Taskset taskset;

  EditTaskset(this.taskset);
}

class AddUrlToTaskset extends CreateTasksetEvent {
  final TaskUrl taskUrl;
  AddUrlToTaskset(this.taskUrl);
}

/// writes a Taskset to the db and a json to the server with a specific url
class GenerateTaskset extends CreateTasksetEvent {

  List<Task> taskList;
  BuildContext context;
  GenerateTaskset(this.taskList, this.context);
}

/// used to add a [Task] to the [Taskset] in Bloc
///
/// {@param}[Task] task that should be added to the list
class AddTaskListToTaskset extends CreateTasksetEvent {
  List<Task> taskList;
  AddTaskListToTaskset(this.taskList);
}

/// used to remove a [Task] from the [Taskset] in Bloc
///
/// {@param}[Task] task that should be removed from the list
class CreateTasksetDeleteTask extends CreateTasksetEvent {
  Task task;
  CreateTasksetDeleteTask(this.task);
}