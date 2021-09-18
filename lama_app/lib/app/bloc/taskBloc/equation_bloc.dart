import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lama_app/app/task-system/task.dart';

///[Bloc] for the [EquationTaskScreen]
///
/// Author: K.Binder
class EquationBloc extends Bloc<EquationEvent, EquationState> {
  final List<String> operatorList = ["+", "-", "*", "/"];

  List<String> initialEquation = [];
  List<String> currentEquation = [];

  final TaskEquation task;

  List<String> answerList = [];

  EquationBloc(this.task) : super(EmptyEquationState());

  @override
  Stream<EquationState> mapEventToState(EquationEvent event) async* {
    //NonRandom and Random only called at the beginning
    if (event is NonRandomEquationEvent) {
      initialEquation.addAll(task.equation);
      currentEquation.addAll(task.equation);
      answerList.addAll(task.options);
      answerList.shuffle();
      yield BuiltEquationState(currentEquation, answerList);
    }
    if (event is RandomEquationEvent) {
      var rnd = Random();
      List<String> randomEquation = _buildRandomEquation();
      List<int> numbersInEquation = [];
      List<String> answers = [];
      int fieldsToRemove = task.fieldsToReplace;

      List<int> possibleFieldsToReplace = [];
      print(randomEquation);
      print(task.allowReplacingOperators);
      for (int i = 0; i < randomEquation.length; i++) {
        if (i % 2 == 0) numbersInEquation.add(int.parse(randomEquation[i]));
        if (randomEquation[i] == "=") continue;
        //Only remove operators when its enabled for the task
        if (operatorList.contains(randomEquation[i]) &&
            !task.allowReplacingOperators) continue;

        possibleFieldsToReplace.add(i);
      }
      print(possibleFieldsToReplace);
      print(fieldsToRemove);
      //fieldsToRemove is -1 if the parameter fieldsToReplace was ommited in the json file
      //This will cause the replacement of fields to use a different approach by replacing allowed fields randomly
      if (fieldsToRemove == -1) {
        for (int i = 0; i < possibleFieldsToReplace.length; i++) {
          //Whether to remove the current space
          if (rnd.nextBool()) {
            if (int.tryParse(randomEquation[possibleFieldsToReplace[i]]) !=
                null) answers.add(randomEquation[possibleFieldsToReplace[i]]);
            randomEquation[possibleFieldsToReplace[i]] = "?";
          }
        }
        //Fallback => if nothing was replaced - at least remove result
        if (answers.length == 0) {
          answers.add(randomEquation[randomEquation.length - 1]);
          randomEquation[randomEquation.length - 1] = "?";
        }
      } else {
        possibleFieldsToReplace.shuffle();
        for (int i = 0; i < fieldsToRemove; i++) {
          if (i >= possibleFieldsToReplace.length) break;
          if (int.tryParse(randomEquation[possibleFieldsToReplace[i]]) !=
              null) {
            answers.add(randomEquation[possibleFieldsToReplace[i]]);
          }
          randomEquation[possibleFieldsToReplace[i]] = "?";
        }
      }
      initialEquation.addAll(randomEquation);
      currentEquation.addAll(randomEquation);
      for (int i = answers.length; i < 10; i++) {
        int baseAnswer =
            numbersInEquation[rnd.nextInt(numbersInEquation.length)];
        answers.add((baseAnswer - 5 + rnd.nextInt(10)).toString());
      }
      answerList.addAll(answers);
      answerList.shuffle();
      yield BuiltEquationState(currentEquation, answerList);
    }
    if (event is UpdateEquationEvent) {
      currentEquation[event.index] = event.item;
      yield BuiltEquationState(currentEquation, answerList);
    }
    if (event is EquationResetEvent) {
      currentEquation.clear();
      currentEquation.addAll(initialEquation);
      yield BuiltEquationState(currentEquation, answerList);
    }
  }

  ///This method builds a random Equation with the specific parameters passed
  ///
  ///Most of this code is very specific and could not be reused if the app ever starts to support more than two operator.
  ///However this really convoluted and "confusing" method can generate a equation with differen operators and asserts, that they are solveable with integers
  List<String> _buildRandomEquation() {
    List<String> equation = [];

    var rnd = Random();
    //Decide whether to use 1 operant or 2
    bool removeIfNotSet = rnd.nextBool();
    if ((task.operatorAmount == null && removeIfNotSet) ||
        (task.operatorAmount != null && task.operatorAmount == 1)) {
      int op1 = task.operandRange[0] +
          rnd.nextInt(task.operandRange[1] - task.operandRange[0]);
      int op2 = 0;
      int result = 0;
      //1 operands
      String equationOperator = task.randomAllowedOperators[
          rnd.nextInt(task.randomAllowedOperators.length)];
      switch (equationOperator) {
        case "+":
          op2 = task.operandRange[0] +
              rnd.nextInt(task.operandRange[1] - task.operandRange[0]);
          result = op1 + op2;
          break;
        case "-":
          op2 = task.operandRange[0] +
              rnd.nextInt(task.operandRange[1] - task.operandRange[0]);
          result = op1 - op2;
          break;
        case "/":
          List<int> divisors = getDivisors(op1);
          if (divisors.length > 0)
            op2 = divisors[rnd.nextInt(divisors.length)];
          else
            op2 = 1 + rnd.nextInt(task.operandRange[1]);
          if (op1 == 0)
            result = 0;
          else
            result = op1 ~/ op2;
          break;
        case "*":
          op2 = task.operandRange[0] +
              rnd.nextInt(task.operandRange[1] - task.operandRange[0]);
          result = op1 * op2;
          break;
      }
      equation.add(op1.toString());
      equation.add(equationOperator);
      equation.add(op2.toString());
      equation.add("=");
      equation.add(result.toString());
    } else if ((task.operatorAmount == null && !removeIfNotSet) ||
        (task.operatorAmount != null && task.operatorAmount == 2)) {
      //2 Operantor
      String operator1 = task.randomAllowedOperators[
          rnd.nextInt(task.randomAllowedOperators.length)];
      String operator2 = task.randomAllowedOperators[
          rnd.nextInt(task.randomAllowedOperators.length)];
      int op1 = 0;
      int op2 = 0;
      int op3 = 0;
      int result = 0;
      if ((operator1 == "/" || operator1 == "*") &&
          (operator2 == "/" || operator2 == "*")) {
        if (operator1 == "*" && operator2 == "*") {
          op2 = task.operandRange[0] +
              rnd.nextInt(task.operandRange[1] - task.operandRange[0]);
          op3 = task.operandRange[0] +
              rnd.nextInt(task.operandRange[1] - task.operandRange[0]);
          result = op1 * op2 * op3;
        } else if (operator1 == "*" && operator2 == "/") {
          op2 = task.operandRange[0] +
              rnd.nextInt(task.operandRange[1] - task.operandRange[0]);
          result = op1 * op2;
          List<int> divisors = getDivisors(result);
          int divisor = 1;
          if (divisors.length > 0)
            divisor = divisors[rnd.nextInt(divisors.length)];
          op3 = divisor;
          result = result ~/ op3;
        } else if (operator1 == "/" && operator2 == "/") {
          List<int> divisorsForOp1 = getDivisors(op1);
          if (divisorsForOp1.length > 0) {
            op2 = divisorsForOp1[rnd.nextInt(divisorsForOp1.length)];
          } else {
            op2 = 1 + rnd.nextInt(task.operandRange[1]);
          }
          if (op1 == 0)
            result = 0;
          else
            result = op1 ~/ op2;

          List<int> divisorsForOp2Op1 = getDivisors(result);
          if (divisorsForOp2Op1.length > 0) {
            op3 = divisorsForOp2Op1[rnd.nextInt(divisorsForOp2Op1.length)];
          } else {
            op3 = 1 + rnd.nextInt(task.operandRange[1]);
          }
          if (result == 0)
            result = 0;
          else
            result = result ~/ op3;
        } else if (operator1 == "/" && operator2 == "*") {
          op3 = task.operandRange[0] +
              rnd.nextInt(task.operandRange[1] - task.operandRange[0]);
          List<int> divisorsForOp1 = getDivisors(op1);
          if (divisorsForOp1.length > 0) {
            op2 = divisorsForOp1[rnd.nextInt(divisorsForOp1.length)];
          } else {
            op2 = 1 + rnd.nextInt(task.operandRange[1]);
          }
          if (op1 == 0)
            result = 0;
          else
            result = op1 ~/ op2;

          result = result * op3;
        }
      } else if ((operator1 == "+" || operator1 == "-") &&
          (operator2 == "+" || operator2 == "-")) {
        op2 = task.operandRange[0] +
            rnd.nextInt(task.operandRange[1] - task.operandRange[0]);
        op3 = task.operandRange[0] +
            rnd.nextInt(task.operandRange[1] - task.operandRange[0]);
        if (operator1 == "+") {
          if (operator2 == "+") {
            result = op1 + op2 + op3;
          } else if (operator2 == "-") {
            result = op1 + op2 - op3;
          }
        } else if (operator1 == "-") {
          if (operator2 == "+") {
            result = op1 - op2 + op3;
          } else if (operator2 == "-") {
            result = op1 - op2 - op3;
          }
        }
      } else {
        //At least one "+" or "-"
        if (operator1 == "/") {
          op1 = task.operandRange[0] +
              rnd.nextInt(task.operandRange[1] - task.operandRange[0]);
          List<int> divisorsForOp1 = getDivisors(op1);
          if (divisorsForOp1.length > 0) {
            op2 = divisorsForOp1[rnd.nextInt(divisorsForOp1.length)];
          } else {
            op2 = 1 + rnd.nextInt(task.operandRange[1]);
          }
          if (op1 == 0)
            result = 0;
          else
            result = op1 ~/ op2;

          if (operator2 == "+") {
            op3 = task.operandRange[0] +
                rnd.nextInt(task.operandRange[1] - task.operandRange[0]);
            result += op3;
          } else if (operator2 == "-") {
            op3 = task.operandRange[0] +
                rnd.nextInt(task.operandRange[1] - task.operandRange[0]);
            result -= op3;
          }
        } else if (operator1 == "*") {
          op1 = task.operandRange[0] +
              rnd.nextInt(task.operandRange[1] - task.operandRange[0]);
          op2 = task.operandRange[0] +
              rnd.nextInt(task.operandRange[1] - task.operandRange[0]);
          result = op1 * op2;

          if (operator2 == "+") {
            op3 = task.operandRange[0] +
                rnd.nextInt(task.operandRange[1] - task.operandRange[0]);
            result += op3;
          } else if (operator2 == "-") {
            op3 = task.operandRange[0] +
                rnd.nextInt(task.operandRange[1] - task.operandRange[0]);
            result -= op3;
          }
        } else if (operator2 == "/") {
          op2 = task.operandRange[0] +
              rnd.nextInt(task.operandRange[1] - task.operandRange[0]);
          List<int> divisorsForOp2 = getDivisors(op2);
          if (divisorsForOp2.length > 0) {
            op3 = divisorsForOp2[rnd.nextInt(divisorsForOp2.length)];
          } else {
            op3 = 1 + rnd.nextInt(task.operandRange[1]);
          }
          if (op2 == 0)
            result = 0;
          else
            result = op2 ~/ op3;
          if (operator1 == "+") {
            op1 = task.operandRange[0] +
                rnd.nextInt(task.operandRange[1] - task.operandRange[0]);
            result = op1 + result;
          } else if (operator1 == "-") {
            op1 = task.operandRange[0] +
                rnd.nextInt(task.operandRange[1] - task.operandRange[0]);
            result = op1 - result;
          }
        } else if (operator2 == "*") {
          op2 = task.operandRange[0] +
              rnd.nextInt(task.operandRange[1] - task.operandRange[0]);
          op3 = task.operandRange[0] +
              rnd.nextInt(task.operandRange[1] - task.operandRange[0]);
          result = op2 * op3;
          if (operator1 == "+") {
            op1 = task.operandRange[0] +
                rnd.nextInt(task.operandRange[1] - task.operandRange[0]);
            result = op1 + result;
          } else if (operator1 == "-") {
            op1 = task.operandRange[0] +
                rnd.nextInt(task.operandRange[1] - task.operandRange[0]);
            result = op1 - result;
          }
        }
      }
      equation.add(op1.toString());
      equation.add(operator1);
      equation.add(op2.toString());
      equation.add(operator2);
      equation.add(op3.toString());
      equation.add("=");
      equation.add(result.toString());
    }
    return equation;
  }

  ///Small helper method to get all divisors of a number.
  List<int> getDivisors(int number) {
    List<int> divisors = [];
    for (int i = 1; i <= number / 2; i++) {
      if (number % i == 0) divisors.add(i);
    }
    if (number != 0) divisors.add(number);
    return divisors;
  }
}

///BaseEvent of [EquationTestTaskState]
///
/// Author: K.Binder
class EquationEvent {}

///Subclass of [EquationEvent]
///
///Emitted during initialization when a random Equation should be constructed
/// Author: K.Binder
class RandomEquationEvent extends EquationEvent {}

///Subclass of [EquationEvent]
///
///Emitted during initialization when a non random Equation should be constructed
/// Author: K.Binder
class NonRandomEquationEvent extends EquationEvent {}

///Subclass of [EquationEvent]
///
///Emitted when a operator or a operand gets dragged onto a '?' field
/// Author: K.Binder
class UpdateEquationEvent extends EquationEvent {
  String item;
  int index;

  UpdateEquationEvent(this.item, this.index);
}

///Subclass of [EquationEvent]
///
///Emitted when the reset button gets pressed.
/// Author: K.Binder
class EquationResetEvent extends EquationEvent {}

///BaseState of [EquationTestTaskState]
///
///Emitted when the reset button gets pressed.
/// Author: K.Binder
class EquationState {}

///Subclass of [EquationState]
///
///Initial empty State
/// Author: K.Binder
class EmptyEquationState extends EquationState {}

///Subclass of [EquationState]
///
///state that contains the current equation, and all answer options
/// Author: K.Binder
class BuiltEquationState extends EquationState {
  List<String> equationItems = [];
  List<String> answers = [];
  BuiltEquationState(this.equationItems, this.answers);
}
