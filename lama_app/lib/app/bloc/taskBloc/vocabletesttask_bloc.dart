import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lama_app/app/event/task_events.dart';
import 'package:lama_app/app/task-system/task.dart';
import 'package:lama_app/util/pair.dart';

class VocableTestTaskBloc
    extends Bloc<VocableTestTaskEvent, VocableTestTaskState> {
  final TaskVocableTest task;
  List<bool> resultList;
  int curWordPair = 0;

  int sideUsed = 0;

  VocableTestTaskBloc(this.task) : super(VocableTestTaskInitState()) {
    resultList =
        List.generate(task.vocablePairs.length, (_) => null, growable: false);
  }

  @override
  Stream<VocableTestTaskState> mapEventToState(
      VocableTestTaskEvent event) async* {
    if (event is VocableTestTaskGetWordEvent) {
      if (task.randomizeSide) {
        var rng = Random();
        int side = rng.nextInt(2);
        if (side == 0) {
          yield VocableTestTaskTranslationState(
              task.vocablePairs[curWordPair].a, resultList);
          sideUsed = 0;
        } else {
          yield VocableTestTaskTranslationState(
              task.vocablePairs[curWordPair].b, resultList);
          sideUsed = 1;
        }
      } else {
        yield VocableTestTaskTranslationState(
            task.vocablePairs[curWordPair].a, resultList);
      }
    } else if (event is VocableTestTaskAnswerEvent) {
      if (task.randomizeSide) {
        if (sideUsed == 0) {
          if (event.answer == task.vocablePairs[curWordPair].b) {
            resultList[curWordPair] = true;
          } else {
            resultList[curWordPair] = false;
          }
        } else {
          if (event.answer == task.vocablePairs[curWordPair].a) {
            resultList[curWordPair] = true;
          } else {
            resultList[curWordPair] = false;
          }
        }
      } else {
        if (event.answer == task.vocablePairs[curWordPair].b) {
          resultList[curWordPair] = true;
        } else {
          resultList[curWordPair] = false;
        }
      }
      curWordPair++;
      if (curWordPair < task.vocablePairs.length) {
        if (task.randomizeSide) {
          var rng = Random();
          int side = rng.nextInt(2);
          if (side == 0) {
            yield VocableTestTaskTranslationState(
                task.vocablePairs[curWordPair].a, resultList);
            sideUsed = 0;
          } else {
            yield VocableTestTaskTranslationState(
                task.vocablePairs[curWordPair].b, resultList);
            sideUsed = 1;
          }
        } else {
          yield VocableTestTaskTranslationState(
              task.vocablePairs[curWordPair].a, resultList);
        }
      } else
        yield VocableTestFinishedTaskState(resultList);
    }
  }
}

class VocableTestTaskEvent {}

class VocableTestTaskGetWordEvent extends VocableTestTaskEvent {}

class VocableTestTaskAnswerEvent extends VocableTestTaskEvent {
  final String answer;
  VocableTestTaskAnswerEvent(this.answer);
}

class VocableTestTaskState {}

class VocableTestTaskInitState extends VocableTestTaskState {}

class VocableTestTaskTranslationState extends VocableTestTaskState {
  List<bool> resultList;
  String wordToTranslate;

  VocableTestTaskTranslationState(this.wordToTranslate, this.resultList);
}

class VocableTestFinishedTaskState extends VocableTestTaskState {
  List<bool> resultList;
  VocableTestFinishedTaskState(this.resultList);
}
