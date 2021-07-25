import 'package:lama_app/util/pair.dart';

/// BaseEvent for the [TaskBloc]
///
/// Author: K.Binder
abstract class TaskEvent {}

/// Subclass of [TaskEvent]
///
/// Author: K.Binder
class ShowNextTaskEvent extends TaskEvent {}

///Subclass of [TaskEvent]
///
/// The AnswerTaskEvent contains the provided answer fo the
/// current task that will be checked by the [TaskBloc].
/// Since these answers are of different types, this class
/// provides constructors for nearly every TaskType.
///
/// Author: K.Binder
class AnswerTaskEvent extends TaskEvent {
  List<String> fullAnswer;
  String providedAnswer;
  double providedAnswerDouble;
  bool providedAnswerBool;
  List<String> providedanswerWords;
  List<bool> providedanswerStates;

  List<Pair> rightPositions;
  List<Pair> markedPositions;
  AnswerTaskEvent(this.providedAnswer);
  AnswerTaskEvent.initMarkWords(List<String> providedanswerWords) {
    this.providedanswerWords = providedanswerWords;
  }
  AnswerTaskEvent.initMatchCategory(List<bool> providedanswerStates) {
    this.providedanswerStates = providedanswerStates;
  }
  AnswerTaskEvent.initGridSelect(this.rightPositions, this.markedPositions);

  AnswerTaskEvent.initMoneyTask(double providedAnswerDouble) {
    this.providedAnswerDouble = providedAnswerDouble;
  }

  AnswerTaskEvent.initVocableTest(this.providedanswerStates);

  AnswerTaskEvent.initConnect(bool providedanswer) {
    this.providedAnswerBool = providedanswer;
  }
  AnswerTaskEvent.initEquation(
      List<String> fullAnswer, List<String> providedanswerWords) {
    this.fullAnswer = fullAnswer;
    this.providedanswerWords = providedanswerWords;
  }
}
