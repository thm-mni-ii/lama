import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lama_app/app/task-system/task.dart';
import 'package:lama_app/util/pair.dart';

class EquationBloc extends Bloc<EquationEvent, EquationState> {
  final List<String> operatorList = ["+", "-", "*", "/"];

  List<String> currentEquation = [];

  final TaskEquation task;

  List<String> answerList = [];

  List<Pair<int, String>> providedAnswers = [];

  EquationBloc(this.task) : super(EmptyEquationState());

  @override
  Stream<EquationState> mapEventToState(EquationEvent event) async* {
    //NonRandom and Random only called at the beginning
    if (event is NonRandomEquationEvent) {
      currentEquation.addAll(task.equation);
      answerList = _buildAnswerList(task.wrongAnswers, task.missingElements);
      yield BuiltEquationState(currentEquation, answerList);
    }
    if (event is RandomEquationEvent) {}
    if (event is UpdateEquationEvent) {
      currentEquation[event.index] = event.item;
      print(currentEquation[event.index]);
      print(task.equation[event.index]);
      providedAnswers.add(Pair<int, String>(event.index, event.item));
      print(providedAnswers);
      yield BuiltEquationState(currentEquation, answerList);
    }
  }

  void reset() {
    currentEquation = [];
    answerList = [];
    providedAnswers = [];
  }

  List<String> _buildAnswerList(
      List<String> wrongAnswers, List<String> rightAnswers) {
    List<String> answers = [];
    answers.addAll(wrongAnswers);
    rightAnswers.forEach((element) {
      if (!operatorList.contains(element)) answers.add(element);
    });
    answers.shuffle();
    return answers;
  }
}

class EquationEvent {}

class RandomEquationEvent extends EquationEvent {}

class NonRandomEquationEvent extends EquationEvent {}

class UpdateEquationEvent extends EquationEvent {
  String item;
  int index;

  UpdateEquationEvent(this.item, this.index);
}

class EquationState {}

class EmptyEquationState extends EquationState {}

class BuiltEquationState extends EquationState {
  List<String> equationItems = [];
  List<String> answers = [];
  BuiltEquationState(this.equationItems, this.answers);
}
