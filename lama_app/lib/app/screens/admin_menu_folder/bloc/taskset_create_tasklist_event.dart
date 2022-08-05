part of 'taskset_create_tasklist_bloc.dart';

@immutable
abstract class TasksetCreateTasklistEvent {}

class AddToTaskList extends TasksetCreateTasklistEvent {
  final Task task;

  AddToTaskList(this.task);
}

class RemoveFromTaskList extends TasksetCreateTasklistEvent {
  final String id;

  RemoveFromTaskList(this.id);
}

class EditTaskInTaskList extends TasksetCreateTasklistEvent {
  final int? pos;
  final Task task;

  EditTaskInTaskList(this.pos, this.task);
}
