import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lama_app/app/event/task_events.dart';
import 'package:lama_app/app/state/task_state.dart';
import 'package:lama_app/app/task-system/task.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  String tasksetSubject;
  List<Task> tasks;
  int curIndex = 0;
  TaskBloc(this.tasksetSubject, this.tasks) : super(TaskScreenEmptyState());

  @override
  Stream<TaskState> mapEventToState(TaskEvent event) async* {
    if (event is ShowNextTaskEvent) {
      yield DisplayTaskState(tasksetSubject, tasks[curIndex++]);
    } else if (event is AnswerTaskEvent) {
      Task t = tasks[curIndex - 1];
      if (t is Task4Cards) {
        if (event.providedAnswer == t.rightAnswer) {
          print("right answer");
        } else
          print("Wrong answer");
      }
    }
  }
}
