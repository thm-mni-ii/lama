import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lama_app/app/event/task_events.dart';
import 'package:lama_app/app/repository/user_repository.dart';
import 'package:lama_app/app/state/task_state.dart';
import 'package:lama_app/app/task-system/task.dart';
import 'package:collection/collection.dart';
<<<<<<< HEAD
import 'package:lama_app/app/task-system/taskset_model.dart';
=======
import 'package:lama_app/db/database_provider.dart';
>>>>>>> 1e9ec22 (Limited Repetition System via base64EncodedString)

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
      yield DisplayTaskState(tasksetSubject, tasks[curIndex++]);
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
      }
      await Future.delayed(Duration(seconds: 1));
      if (curIndex >= tasks.length)
        yield AllTasksCompletedState(tasks, answerResults);
      else
        yield DisplayTaskState(tasksetSubject, tasks[curIndex++]);
    }
  }

  void rightAnswerCallback(Task t) {
    if (t.leftToSolve > 0) {
      answerResults.add(true);
      userRepository.addLamaCoins(t.reward);
    } else
      answerResults.add(true);
    DatabaseProvider.db.decrementLeftToSolve(t);
    t.leftToSolve--;
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
