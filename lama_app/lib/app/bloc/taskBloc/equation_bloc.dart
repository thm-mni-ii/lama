import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lama_app/app/task-system/task.dart';

class EquationBloc extends Bloc<EquationEvent, EquationState> {
  final List<String> operatorList = ["+", "-", "*", "/"];

  List<String> currentEquation = [];

  final TaskEquation task;

  List<String> answerList = [];

  EquationBloc(this.task) : super(EmptyEquationState());

  @override
  Stream<EquationState> mapEventToState(EquationEvent event) async* {
    //NonRandom and Random only called at the beginning
    if (event is NonRandomEquationEvent) {
      currentEquation.addAll(task.equation);
      answerList.addAll(task.options);
      answerList.shuffle();
      yield BuiltEquationState(currentEquation, answerList);
    }
    if (event is RandomEquationEvent) {}
    if (event is UpdateEquationEvent) {
      currentEquation[event.index] = event.item;
      print(currentEquation[event.index]);
      print(task.equation[event.index]);
      yield BuiltEquationState(currentEquation, answerList);
    }
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
