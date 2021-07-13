import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lama_app/app/event/task_events.dart';
import 'package:lama_app/app/repository/user_repository.dart';
import 'package:lama_app/app/state/task_state.dart';
import 'package:lama_app/app/task-system/task.dart';
import 'package:collection/collection.dart';
import 'package:lama_app/db/database_provider.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  String tasksetSubject;
  List<Task> tasks;
  int curIndex = 0;

  List<bool> answerResults = [];

  UserRepository userRepository;
  TaskBloc(this.tasksetSubject, this.tasks, this.userRepository)
      : super(TaskScreenEmptyState());

  @override
  Stream<TaskState> mapEventToState(TaskEvent event) async* {
    if (event is ShowNextTaskEvent) {
      yield await displayNextTask(tasksetSubject, tasks[curIndex++]);
    } else if (event is AnswerTaskEvent) {
      Task t = tasks[curIndex - 1];
      if (t is Task4Cards) {
        if (event.providedAnswer == t.rightAnswer) {
          rightAnswerCallback(t);
          yield TaskAnswerResultState(true);
        } else {
          wrongAnswerCallback(t);
          yield TaskAnswerResultState(false);
        }
      } else if (t is TaskMarkWords) {
        if (equals(t.rightWords, event.providedanswerWords)) {
          rightAnswerCallback(t);
          yield TaskAnswerResultState(true);
        } else {
          wrongAnswerCallback(t);
          yield TaskAnswerResultState(false);
        }
      } else if (t is TaskClozeTest) {
        if (event.providedAnswer == t.rightAnswer) {
          rightAnswerCallback(t);
          yield TaskAnswerResultState(true);
        } else {
          wrongAnswerCallback(t);
          yield TaskAnswerResultState(false);
        }
      } else if (t is TaskMatchCategory) {
        if (event.providedanswerStates.contains(false)) {
          wrongAnswerCallback(t);
          yield TaskAnswerResultState(false);
        } else {
          rightAnswerCallback(t);
          yield TaskAnswerResultState(true);
        }
      } else if (t is TaskGridSelect) {
        if (!DeepCollectionEquality.unordered()
            .equals(event.rightPositions, event.markedPositions)) {
          wrongAnswerCallback(t);
          yield TaskAnswerResultState(false);
        } else {
          rightAnswerCallback(t);
          yield TaskAnswerResultState(true);
        }
      } else if (t is TaskMoney) {
        if (event.providedAnswerDouble.toStringAsFixed(2) ==
            t.moneyAmount.toStringAsFixed(2)) {
          rightAnswerCallback(t);
          yield TaskAnswerResultState(true);
        } else {
          wrongAnswerCallback(t);
          yield TaskAnswerResultState(false);
        }
      } else if (t is TaskVocableTest) {
        if (event.providedanswerStates.contains(false)) {
          wrongAnswerCallback(t);
          yield TaskAnswerResultState(false,
              subTaskResult: event.providedanswerStates);
        } else {
          rightAnswerCallback(t);
          yield TaskAnswerResultState(true,
              subTaskResult: event.providedanswerStates);
        }
      } else if (t is TaskConnect) {
        if (event.providedAnswerBool) {
          rightAnswerCallback(t);
          yield TaskAnswerResultState(true);
        } else {
          wrongAnswerCallback(t);
          yield TaskAnswerResultState(false);
        }
      }
      await Future.delayed(Duration(seconds: 1));
      if (curIndex >= tasks.length)
        yield AllTasksCompletedState(tasks, answerResults);
      else
        yield await displayNextTask(tasksetSubject, tasks[curIndex++]);
    }
  }

  Future<TaskState> displayNextTask(String subject, Task task) async {
    //lookup task for user and inject current leftToSolve
    //wenn nich vorhanden => insert standardValue;
    int leftToSolve = await DatabaseProvider.db
        .getLeftToSolve(task.toString(), userRepository.authenticatedUser);
    //Its -1 if the user just solves the task during this "run", its -2 when the task has not given coins once (important for summary screen) and -3 if the task is not found in the db
    if (leftToSolve == -3) {
      print("Not found - inserting");
      await DatabaseProvider.db.insertLeftToSolve(task.toString(),
          task.originalLeftToSolve, userRepository.authenticatedUser);
    } else {
      print("found - setting to: " + leftToSolve.toString());
      task.leftToSolve = leftToSolve;
    }
    return DisplayTaskState(subject, task);
  }

  void rightAnswerCallback(Task t) async {
    if (t.leftToSolve > 0) {
      answerResults.add(true);
      userRepository.addLamaCoins(t.reward);
    } else
      answerResults.add(true);
    int updatedRows = await DatabaseProvider.db
        .decrementLeftToSolve(t, userRepository.authenticatedUser);
    print("Updated " + updatedRows.toString() + "rows");
    t.leftToSolve = await DatabaseProvider.db
        .getLeftToSolve(t.toString(), userRepository.authenticatedUser);
  }

  void wrongAnswerCallback(Task t) {
    answerResults.add(false);
  }

  bool equals(List<String> list1, List<String> list2) {
    if (!(list1 is List<String> && list2 is List<String>) ||
        list1.length != list2.length) {
      return false;
    }
    list1.sort();
    list2.sort();
    for (int i = 0; i < list1.length; i++) {
      if (list1[i] != list2[i]) {
        return false;
      }
    }
    return true;
  }
}
