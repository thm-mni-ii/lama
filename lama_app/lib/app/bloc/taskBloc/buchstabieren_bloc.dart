import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:lama_app/app/task-system/task.dart';
import 'package:meta/meta.dart';

import '../../screens/task_type_screens/buchstabieren_task_helper.dart';

class BuchstabierenBloc extends Bloc<BuchstabierenEvent, BuchstabierenState> {
  final TaskBuchstabieren task;
  int points;
  BuchstabierenBloc(this.task) : super(BuchstabierenInitial(task)) {
    points = task.multiplePoints;
    on<BuchstabierenClickedLetter>((event, emit) {
      print("I juts clicked a letter!");
    });
    on<BuchstabierenGaveAnswer>((event, emit) {
      if (points > 0) {
        print("I just answered a question");
        points--;
        var index = erstelleEineRandomNummer(task);
        //TO-DO: benutze messeLaengeVomWort(
        //holeEinWortAusJSON(randomNummer, woerterKeys, woerterURLs));
        //wie in der initState() funktion um neue werte festzusetzen
        //dann build die app neu mit BlocBuilder()
        emit(BuchstabierenAnsweredState());
      } else {
        print("I just finished all questions");
        emit(BuchstabierenFinishedState());
      }
    });
  }
}

//events
@immutable
abstract class BuchstabierenEvent {}

//init the task
class BuchstabierenInitEvent extends BuchstabierenEvent {
  BuchstabierenInitEvent();

  @override
  List<Object> get props => [];
}

//clicked a letter
class BuchstabierenClickedLetter extends BuchstabierenEvent {
  BuchstabierenClickedLetter();

  @override
  List<Object> get props => [];
}

//clicked a letter to finish task???
class BuchstabierenGaveAnswer extends BuchstabierenEvent {
  bool _isCorrect;
  BuchstabierenGaveAnswer(this._isCorrect);

  @override
  List<Object> get props => [_isCorrect];
}

//states
class BuchstabierenState {
  MaterialColor _color = Colors.grey;
  MaterialColor getColor() {
    return _color;
  }
}

//very first state
class BuchstabierenInitial extends BuchstabierenState {
  BuchstabierenInitial(TaskBuchstabieren task) {
    //create map with all needed points with "no_answer"to later
    //replace with given answers
    var gotAnswered = new Map();
    for (int i = 0; i < task.multiplePoints; i++) {
      gotAnswered["task_$i"] = "no_answer";
    }
  }
}

//state when answered and need more answers
class BuchstabierenAnsweredState extends BuchstabierenState {
  BuchstabierenAnsweredState() {}
  @override
  List<Object> get props => [];
}

//state for finishing the whole task and going to the next
class BuchstabierenFinishedState extends BuchstabierenState {
  BuchstabierenFinishedState();

  @override
  List<Object> get props => [];
}
