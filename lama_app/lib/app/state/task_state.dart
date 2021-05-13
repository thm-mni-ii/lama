import 'package:lama_app/app/task-system/task.dart';

abstract class TaskState {}

class TaskScreenEmptyState extends TaskState {}

class DisplayTaskState extends TaskState {
  Task task;
  DisplayTaskState(this.task);
}
