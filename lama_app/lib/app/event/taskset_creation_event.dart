import 'package:flutter/cupertino.dart';
import 'package:lama_app/app/bloc/taskset_creation_bloc.dart';
import 'package:lama_app/app/screens/admin_menu_folder/taskset_creation_screen.dart';
import 'package:lama_app/app/task-system/task.dart';

import '../task-system/taskset_model.dart';

/// Events used by [TasksetCreationScreen] and [TasksetCreationBloc]
///
/// Author: N. Soethe
/// latest Changes: 09.06.2022
abstract class CreateTasksetEvent {}

/// used to change [Taskset]name in Bloc
///
/// {@param}[String] name that should be set
class CreateTasksetChangeName extends CreateTasksetEvent {
  String name;
  CreateTasksetChangeName(this.name);
}

/// used to change [Taskset]subtitle in Bloc
/// this param isnt used yet, must be implemented later
///
/// {@param}[String] subtitle that should be set
class CreateTasksetChangeSubtitle extends CreateTasksetEvent {
  String subtitle;
  CreateTasksetChangeSubtitle(this.subtitle);
}

/// used to change [Taskset]grade in Bloc
///
/// {@param}[String] grade that should be set
class CreateTasksetChangeGrade extends CreateTasksetEvent {
  String grade;
  CreateTasksetChangeGrade(this.grade);
}

/// used to change [Taskset]subject in Bloc
///
/// {@param}[String] subject that should be set
class CreateTasksetChangeSubject extends CreateTasksetEvent {
  String subject;
  CreateTasksetChangeSubject(this.subject);
}

/// used to generate a JSON file from the given [Taskset] object
///
/// {@param}[Taskset] taskset that should be generated
class CreateTasksetGenerate extends CreateTasksetEvent {
  Taskset taskset;
  CreateTasksetGenerate(this.taskset);
}

/// used to abort the process
///
/// {@param}[BuildContext] as context
class CreateTasksetAbort extends CreateTasksetEvent {
  BuildContext context;
  CreateTasksetAbort(this.context);
}

/// used to add a [Task] to the [Taskset] in Bloc
///
/// {@param}[Task] task that should be added to the list
class CreateTasksetAddTask extends CreateTasksetEvent {
  Task task;
  CreateTasksetAddTask(this.task);
}

/// used to remove a [Task] from the [Taskset] in Bloc
///
/// {@param}[Task] task that should be removed from the list
class CreateTasksetDeleteTask extends CreateTasksetEvent {
  Task task;
  CreateTasksetDeleteTask(this.task);
}