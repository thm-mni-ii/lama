import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lama_app/app/task-system/task.dart';

///[Bloc] for the [VocableTestTaskScreen]
///
/// * see also
///     [VocableTestTaskScreen]
///     [VocableTestTaskEvent]
///     [VocableTestTaskState]
///
/// Author: K.Binder
class VocableTestTaskBloc
    extends Bloc<VocableTestTaskEvent, VocableTestTaskState> {
  final TaskVocableTest task;
  //List with all subTask results
  List<bool?>? resultList;
  //Index of the current subTask
  int curWordPair = 0;
  //Which "side" is shown word->translation, translation->word
  int sideUsed = 0;
  int vocab_amount = 3;
  VocableTestTaskBloc(this.task) : super(VocableTestTaskInitState()) {
    // resultList =
    //     List.generate(task.vocablePairs.length, (_) => null, growable: false);
    resultList = List.generate(vocab_amount, (_) => null, growable: false);
    task.vocablePairs.shuffle();
    on<VocableTestTaskGetWordEvent>((event, emit) async {
      if (task.randomizeSide) {
        var rng = Random();
        int side = rng.nextInt(2);
        if (side == 0) {
          emit(VocableTestTaskTranslationState(task.vocablePairs[curWordPair].a,
              resultList, task.questionLanguage));
          sideUsed = 0;
        } else {
          emit(VocableTestTaskTranslationState(
              task.vocablePairs[curWordPair].b, resultList, "Deutsch"));
          sideUsed = 1;
        }
      } else {
        emit(VocableTestTaskTranslationState(
            task.vocablePairs[curWordPair].a, resultList, "Deutsch"));
      }
    });
    on<VocableTestTaskAnswerEvent>((event, emit) async {
      if (task.randomizeSide) {
        if (sideUsed == 0) {
          if (event.answer == task.vocablePairs[curWordPair].b) {
            resultList![curWordPair] = true;
          } else {
            resultList![curWordPair] = false;
          }
        } else {
          if (event.answer == task.vocablePairs[curWordPair].a) {
            resultList![curWordPair] = true;
          } else {
            resultList![curWordPair] = false;
          }
        }
      } else {
        if (event.answer == task.vocablePairs[curWordPair].b) {
          resultList![curWordPair] = true;
        } else {
          resultList![curWordPair] = false;
        }
      }
      curWordPair++;
      if (curWordPair < vocab_amount) {
        if (task.randomizeSide) {
          var rng = Random();
          int side = rng.nextInt(2);
          if (side == 0) {
            emit(VocableTestTaskTranslationState(
                task.vocablePairs[curWordPair].a,
                resultList,
                task.questionLanguage));
            sideUsed = 0;
          } else {
            emit(VocableTestTaskTranslationState(
                task.vocablePairs[curWordPair].b, resultList, "Deutsch"));
            sideUsed = 1;
          }
        } else {
          emit(VocableTestTaskTranslationState(
              task.vocablePairs[curWordPair].a, resultList, "Deutsch"));
        }
      } else
        emit(VocableTestFinishedTaskState(resultList));
    });
  }
}

///BaseEvent for [VocableTestTaskBloc]
///
/// Author: K.Binder
class VocableTestTaskEvent {}

///Subclass of [VocableTestTaskEvent] for [VocableTestTaskBloc]
///
/// Author: K.Binder
class VocableTestTaskGetWordEvent extends VocableTestTaskEvent {}

///Subclass of [VocableTestTaskEvent] for [VocableTestTaskBloc]
///
/// Author: K.Binder
class VocableTestTaskAnswerEvent extends VocableTestTaskEvent {
  final String answer;
  VocableTestTaskAnswerEvent(this.answer);
}

///BaseState of [VocableTestTaskState]
///
/// Author: K.Binder
class VocableTestTaskState {}

///Subclass of [VocableTestTaskState] for [VocableTestTaskBloc]
///
/// This state is emitted by the [VocableTestTaskBloc] on initialization
///
/// Author: K.Binder
class VocableTestTaskInitState extends VocableTestTaskState {}

///Subclass of [VocableTestTaskState] for [VocableTestTaskBloc]
///
/// This state is emmited by the [VocableTestTaskBloc] when a word pair to
/// translate gets displayed and cointains the word and the list of all results
/// up till now
///
/// Author: K.Binder
class VocableTestTaskTranslationState extends VocableTestTaskState {
  List<bool?>? resultList;
  String? wordToTranslate;
  String? lang;

  VocableTestTaskTranslationState(
      this.wordToTranslate, this.resultList, this.lang);
}

///Subclass of [VocableTestTaskState] for [VocableTestTaskBloc]
///
/// This state is emmitted by the [VocableTestTaskBloc] once all words
/// have been translated.
///
/// Author: K.Binder
class VocableTestFinishedTaskState extends VocableTestTaskState {
  List<bool?>? resultList;
  VocableTestFinishedTaskState(this.resultList);
}
