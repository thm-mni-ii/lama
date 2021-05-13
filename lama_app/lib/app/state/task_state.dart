import 'package:lama_app/app/task-system/task.dart';

abstract class TaskState {}

class TaskScreenEmptyState extends TaskState {}

class DisplayTaskState extends TaskState {
  String subject;
  Task task;
  DisplayTaskState(this.subject, this.task);
}

class TaskAnswerResultState extends TaskState {
  bool correct;
  TaskAnswerResultState(this.correct);
}
