import 'package:lama_app/app/task-system/task.dart';

///BaseState for the [TaskBloc].
///
///Author: K.Binder
abstract class TaskState {}

///Subclass of [TaskState].
///
///Initial state of the [TaskBloc].
///
///Author: K.Binder
class TaskScreenEmptyState extends TaskState {}

///Subclass of [TaskState].
///
///Emitted when a task should be displayed on the [TaskScreen].
///
///Author: K.Binder
class DisplayTaskState extends TaskState {
  String subject;
  Task task;
  DisplayTaskState(this.subject, this.task);
}

///Subclass of [TaskState]
///
///Emitted when a task has been answered, evaluated by the [TaskBloc]
///and the result needs to be passed to the [TaskScreen].
///
///Author: K.Binder
class TaskAnswerResultState extends TaskState {
  List<bool> subTaskResult;
  bool correct;
  TaskAnswerResultState(this.correct, {this.subTaskResult});
}

///Subclass of [TaskState]
///
///Emitted when ALL task have been completed and the summary needs to
///be shown on the [TaskScreen].
///
///Author: K.Binder
class AllTasksCompletedState extends TaskState {
  List<Task> tasks;
  List<bool> answerResults;
  AllTasksCompletedState(this.tasks, this.answerResults);
}
