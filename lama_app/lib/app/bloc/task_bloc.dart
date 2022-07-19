import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lama_app/app/event/task_events.dart';
import 'package:lama_app/app/repository/user_repository.dart';
import 'package:lama_app/app/state/task_state.dart';
import 'package:lama_app/app/task-system/task.dart';
import 'package:collection/collection.dart';
import 'package:lama_app/db/database_provider.dart';
import 'package:lama_app/util/OperantsEnum.dart';

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
  String? tasksetSubject;
  List<Task>? tasks;
  int curIndex = 0;
  int timer = 15;
  List<bool> answerResults = [];

  UserRepository? userRepository;
  TaskBloc(this.tasksetSubject, this.tasks, this.userRepository)
      : super(TaskScreenEmptyState()) {
    on<ShowNextTaskEvent>((event, emit) async {
      emit(await displayNextTask(tasksetSubject, tasks![curIndex++]));
    });
    on<AnswerTaskEvent>((event, emit) async {
      Task t = tasks![curIndex - 1];
      if (t is Task4Cards) {
        if (event.providedAnswer == t.rightAnswer) {
          rightAnswerCallback(t);
          emit(TaskAnswerResultState(true));
        } else {
          wrongAnswerCallback(t);
          emit(TaskAnswerResultState(false));
        }
      } else if (t is TaskMarkWords) {
        if (equals(t.rightWords, event.providedanswerWords)) {
          rightAnswerCallback(t);
          emit(TaskAnswerResultState(true));
        } else {
          wrongAnswerCallback(t);
          emit(TaskAnswerResultState(false));
        }
      } else if (t is TaskZerlegung) {
        //print("Zelegung validation"); // To remove after
        if (event.providedAnswerBool!) {
          rightAnswerCallback(t);
          emit(TaskAnswerResultState(true));
        } else {
          wrongAnswerCallback(t);
          emit(TaskAnswerResultState(false));
        }
      } else if (t is TaskNumberLine) {
        if (event.providedAnswerBool!) {
          rightAnswerCallback(t);
          emit(TaskAnswerResultState(true));
        } else {
          wrongAnswerCallback(t);
          emit(TaskAnswerResultState(false));
        }
      } else if (t is TaskBuchstabieren) {
        if (event.providedAnswerBool!) {
          rightAnswerCallback(t);
          emit(TaskAnswerResultState(true));
        } else {
          wrongAnswerCallback(t);
          emit(TaskAnswerResultState(false));
        }
      } else if (t is TaskClozeTest) {
        if (event.providedAnswer == t.rightAnswer) {
          rightAnswerCallback(t);
          emit(TaskAnswerResultState(true));
        } else {
          wrongAnswerCallback(t);
          emit(TaskAnswerResultState(false));
        }
      } else if (t is ClockTest) {
        if (event.providedAnswer == t.rightAnswer) {
          rightAnswerCallback(t);
          emit(TaskAnswerResultState(true));
        } else if (event.providedAnswerBool == true) {
          rightAnswerCallback(t);
          emit(TaskAnswerResultState(true));
        } else {
          wrongAnswerCallback(t);
          emit(TaskAnswerResultState(false));
        }
      } else if (t is TaskClozeTest) {
        if (event.providedAnswer == t.rightAnswer) {
          rightAnswerCallback(t);
          emit(TaskAnswerResultState(true));
        } else {
          wrongAnswerCallback(t);
          emit(TaskAnswerResultState(false));
        }
      } else if (t is TaskMatchCategory) {
        if (event.providedanswerStates!.contains(false)) {
          wrongAnswerCallback(t);
          emit(TaskAnswerResultState(false));
        } else {
          rightAnswerCallback(t);
          emit(TaskAnswerResultState(true));
        }
      } else if (t is TaskGridSelect) {
        if (!DeepCollectionEquality.unordered()
            .equals(event.rightPositions, event.markedPositions)) {
          wrongAnswerCallback(t);
          emit(TaskAnswerResultState(false));
        } else {
          rightAnswerCallback(t);
          emit(TaskAnswerResultState(true));
        }
      } else if (t is TaskMoney) {
        if (event.providedAnswerBool!) {
          rightAnswerCallback(t);
          emit(TaskAnswerResultState(true));
        } else {
          wrongAnswerCallback(t);
          emit(TaskAnswerResultState(false));
        }
      } else if (t is TaskVocableTest) {
        if (event.providedanswerStates!.contains(false)) {
          wrongAnswerCallback(t);
          emit(TaskAnswerResultState(false,
              subTaskResult: event.providedanswerStates));
        } else {
          rightAnswerCallback(t);
          emit(TaskAnswerResultState(true,
              subTaskResult: event.providedanswerStates));
        }
      } else if (t is TaskConnect) {
        if (event.providedAnswerBool!) {
          rightAnswerCallback(t);
          emit(TaskAnswerResultState(true));
        } else {
          wrongAnswerCallback(t);
          emit(TaskAnswerResultState(false));
        }
      } else if (t is TaskEquation) {
        if (evaluateExpression(event.fullAnswer)) {
          rightAnswerCallback(t);
          emit(TaskAnswerResultState(true));
        } else {
          wrongAnswerCallback(t);
          emit(TaskAnswerResultState(false));
        }
      }
      await Future.delayed(Duration(seconds: 1));
      if (curIndex >= tasks!.length)
        emit(AllTasksCompletedState(tasks, answerResults));
      else
        emit(await displayNextTask(tasksetSubject, tasks![curIndex++]));
    });
  }

  /// Returns a [DisplayTaskState] containing the next task.
  ///
  /// This method also handles the lookup and the injection of the left_to_solve
  /// parameter into the next task.
  Future<TaskState> displayNextTask(String? subject, Task task) async {
    //lookup task for current user and inject the current leftToSolve value
    //if not found => insert standard value
    int? leftToSolve = await DatabaseProvider.db
        .getLeftToSolve(task.toString(), userRepository!.authenticatedUser!);
    //Its -1 if the user just solves the task during this "run",
    //its -2 when the task has not given coins once
    //(important for summary screen as it needs to show the right amount one last time)
    // and -3 if the task is not found in the db
    if (leftToSolve == -3) {
      print("Not found - inserting");
      await DatabaseProvider.db.insertLeftToSolve(task.toString(),
          task.originalLeftToSolve, userRepository!.authenticatedUser!);
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
    if (t.leftToSolve! > 0) {
      answerResults.add(true);
      userRepository!.addLamaCoins(t.reward);
    } else
      answerResults.add(true);
    int? updatedRows = await DatabaseProvider.db
        .decrementLeftToSolve(t, userRepository!.authenticatedUser!);
    print("Updated " + updatedRows.toString() + "rows");
    t.leftToSolve = await DatabaseProvider.db
        .getLeftToSolve(t.toString(), userRepository!.authenticatedUser!);
  }

  /// Handles everything that should happen when a task is solved wrongly.
  ///
  /// For now this only adds the result to the list for the summary screen.
  void wrongAnswerCallback(Task t) => answerResults.add(false);

  /// parses and evaluates a mathematical expression.
  ///
  /// Note that the pinpointing only works while using 1-2 operants.
  /// Since it is not planed to support more operants,
  /// which is of course limitied by the screen size of a smartphone,
  /// this will do for now.
  ///
  /// If the equation contains a * or / AND a + or -, the equation is reconstructed to begin with
  /// the * or / operator to preserve precedence of division and multiplication
  /// NOTE: if the leading operator is a - and the equation gets reconstructed, the result needs to be inverted
  /// by passing invertResult to evalLeftToRight() to get the correct result
  ///
  /// Example: 24 - 6/2 = 21 would look like this after reconstruction 6/2 - 24 = -21
  /// Therefore the result needs to be inverted to be correct. This inly happens during calculation
  /// and has no influence on the UI
  bool evaluateExpression(List<String> equation) {
    if (equation.contains("?")) return false;
    if (equation.contains("*") || equation.contains("/")) {
      //pinpoint * and / (if no other sign is present goto evalLeftToRight)
      if (!(equation.contains("+") || equation.contains("-"))) {
        return evalLeftToRight(equation);
      } else {
        late int position;
        Operants? lastOperant;
        for (int i = 0; i < equation.length; i++) {
          Operants op = evalOperant(equation[i]);
          if (op == Operants.NUMBER && lastOperant == Operants.NUMBER)
            return false;
          if (op != Operants.NUMBER && lastOperant != Operants.NUMBER)
            return false;
          lastOperant = op;
          if (op == Operants.DIV || op == Operants.MUL) {
            position = i;
          }
        }
        List<String> newEquation = [];
        bool invertResult = false;
        newEquation.add(equation[position - 1]);
        newEquation.add(equation[position]);
        newEquation.add(equation[position + 1]);
        for (int i = 0; i < equation.length; i++) {
          if (i < position - 1) {
            if (evalOperant(equation[i]) != Operants.NUMBER) {
              if (evalOperant(equation[i]) == Operants.SUB) invertResult = true;
              newEquation.add(equation[i]);
              newEquation.add(equation[i - 1]);
            }
          } else if (i > position + 1) newEquation.add(equation[i]);
        }
        return evalLeftToRight(newEquation, invertResult: invertResult);
      }
    } else {
      return evalLeftToRight(equation);
    }
  }

  ///evaluates a expression from left to right
  ///
  ///invertResult must be passed if the equation contains a * or / as a second operant and a - as a first
  ///because of how the evaluation is handled
  ///
  ///see *evaluateExpression()
  bool evalLeftToRight(List<String> equation, {bool invertResult = false}) {
    int value = 0;
    Operants? lastOperant;
    for (int i = 0; i < equation.length; i++) {
      String char = equation[i];
      switch (evalOperant(char)) {
        case Operants.ADD:
          if (lastOperant != Operants.NUMBER) return false;
          lastOperant = Operants.ADD;
          break;
        case Operants.SUB:
          if (lastOperant != Operants.NUMBER) return false;
          lastOperant = Operants.SUB;
          break;
        case Operants.MUL:
          if (lastOperant != Operants.NUMBER) return false;
          lastOperant = Operants.MUL;
          break;
        case Operants.DIV:
          if (lastOperant != Operants.NUMBER) return false;
          lastOperant = Operants.DIV;
          break;
        case Operants.EQUALS:
          if (lastOperant != Operants.NUMBER) return false;
          lastOperant = Operants.EQUALS;
          break;
        case Operants.NUMBER:
          if (lastOperant == Operants.NUMBER)
            return false;
          else if (lastOperant == null)
            value = int.parse(char);
          else if (lastOperant == Operants.DIV && int.parse(char) == 0)
            return false;
          else if (lastOperant == Operants.EQUALS) {
            if (invertResult)
              return (value * -1) == int.parse(char);
            else
              return value == int.parse(char);
          } else
            value = doOperation(value, int.parse(char), lastOperant);
          lastOperant = Operants.NUMBER;
          break;
      }
    }
    return false;
  }

  /// executes a simple calculation based on the passed operator
  int doOperation(int value, int number, Operants operant) {
    switch (operant) {
      case Operants.ADD:
        return value + number;
      case Operants.SUB:
        return value - number;
      case Operants.MUL:
        return value * number;
      case Operants.DIV:
        return (value ~/ number);
      //The following two CAN NEVER happen
      case Operants.EQUALS:
      case Operants.NUMBER:
        return 0;
    }
  }

  /// returns the corresponding operant of the passed string
  Operants evalOperant(String char) {
    switch (char) {
      case "+":
        return Operants.ADD;
      case "-":
        return Operants.SUB;
      case "*":
        return Operants.MUL;
      case "/":
        return Operants.DIV;
      case "=":
        return Operants.EQUALS;
    }
    return Operants.NUMBER;
  }

  /// Checks if two String lists ([list1] and [list2]) contain exactly the same elements.
  bool equals(List<String> list1, List<String>? list2) {
    if (!(list2 is List<String>) || list1.length != list2.length) return false;
    //return list1.every((element) => list2.contains(element));
    list1.sort();
    list2.sort();
    for (int i = 0; i < list1.length; i++) {
      if (list1[i] != list2[i]) return false;
    }
    return true;
  }
}
