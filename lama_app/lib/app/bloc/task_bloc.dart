import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lama_app/app/event/task_events.dart';
import 'package:lama_app/app/repository/user_repository.dart';
import 'package:lama_app/app/state/task_state.dart';
import 'package:lama_app/app/task-system/task.dart';
import 'package:collection/collection.dart';
import 'package:lama_app/db/database_provider.dart';

/// [Bloc] for the [TaskScreen]
///
/// This Bloc handles everything related to tasks from
/// deciding which one to display to if the chosen answer is correct
///
/// * see also
///     [TaskScreen]
///     [TaskEvent]
///     [TaskState]
///
/// Author: K.Binder
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
      } else if (t is TaskEquation) {
        if (fullequals(event.fullAnswer, event.providedanswerWords)) {
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

  /// Returns a [DisplayTaskState] containing the next task.
  ///
  /// This method also handles the lookup and the injection of the left_to_solve
  /// parameter into the next task.
  Future<TaskState> displayNextTask(String subject, Task task) async {
    //lookup task for current user and inject the current leftToSolve value
    //if not found => insert standard value
    int leftToSolve = await DatabaseProvider.db
        .getLeftToSolve(task.toString(), userRepository.authenticatedUser);
    //Its -1 if the user just solves the task during this "run",
    //its -2 when the task has not given coins once
    //(important for summary screen as it needs to show the right amount one last time)
    // and -3 if the task is not found in the db
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

  /// Handles everything that should happen when a task is solved correctly.
  ///
  /// This entails adding the answer to the list for the summary screen,
  /// awarding lama coins and updating the left_to_solve value in the database
  /// for the passed Task [t].
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

  /// Handles everything that should happen when a task is solved wrongly.
  ///
  /// For now this only adds the result to the list for the summary screen.
  void wrongAnswerCallback(Task t) {
    answerResults.add(false);
  }

  /// Checks if two String lists ([list1] and [list2]) contain exactly the same elements.
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

  //TODO: Franz komentier die bitte die hast du geschrieben iirc und ich will nix falsches sagen
  bool fullequals(List<String> list1, List<String> list2) {
    int remove1, remove2;
    bool twoToRemove = false;

    if (!(list1 is List<String> && list2 is List<String>) ||
        list1.length != list2.length) {
      return false;
    }
    if ((list2.length == 5 && (list2[0] == "0" || list2[2] == "0")) ||
        (list2.length == 7 &&
            (list2[0] == "0" || list2[2] == "0" || list2[4] == "0"))) {
      if (list2[0] == "0") {
        if (list2[1] == "*" &&
            (list2[2] != "+" &&
                list2[2] != "-" &&
                list2[2] != "*" &&
                list2[2] != "/")) {
          remove1 = 2;
          if (list2[3] == "*" &&
              (list2[4] != "+" &&
                  list2[4] != "-" &&
                  list2[4] != "*" &&
                  list2[4] != "/")) {
            remove2 = 3;
            twoToRemove = true;
          }
          list1.removeAt(remove1);
          list2.removeAt(remove1);
          if (twoToRemove) {
            list1.removeAt(remove2);
            list2.removeAt(remove2);
          }
        }
      } else if (list2[2] == "0") {
        if (list2[1] == "*" &&
            (list2[0] != "+" &&
                list2[0] != "-" &&
                list2[0] != "*" &&
                list2[0] != "/")) {
          remove1 = 0;
          if (list2[3] == "*" &&
              (list2[4] != "+" &&
                  list2[4] != "-" &&
                  list2[4] != "*" &&
                  list2[4] != "/")) {
            remove2 = 3;
            twoToRemove = true;
          }
          list1.removeAt(remove1);
          list2.removeAt(remove1);
          if (twoToRemove) {
            list1.removeAt(remove2);
            list2.removeAt(remove2);
          }
        } else if (list2[3] == "*" &&
            (list2[4] != "+" &&
                list2[4] != "-" &&
                list2[4] != "*" &&
                list2[4] != "/")) {
          remove1 = 4;
          list1.removeAt(remove1);
          list2.removeAt(remove1);
        }
      } else if (list2[4] == "0") {
        if (list2[3] == "*" &&
            (list2[2] != "+" &&
                list2[2] != "-" &&
                list2[2] != "*" &&
                list2[2] != "/")) {
          remove1 = 2; // 7 *  * 0 = 0
          if (list2[1] == "*" &&
              (list2[0] != "+" &&
                  list2[0] != "-" &&
                  list2[0] != "*" &&
                  list2[0] != "/")) {
            remove2 = 0;
            twoToRemove = true;
          }
          list1.removeAt(remove1);
          list2.removeAt(remove1);
          if (twoToRemove) {
            list1.removeAt(remove2);
            list2.removeAt(remove2);
          }
        }
      }
    }
    for (int i = 0; i < list1.length; i++) {
      if (list1[i] != list2[i]) {
        return false;
      }
    }
    return true;
  }
}
