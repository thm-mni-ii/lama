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
/// This class can be overhauled to be more generic which would
/// allow for better and more intuitive naming of the fields.
///
/// Author: K.Binder
class AnswerTaskEvent extends TaskEvent {
  List<String> fullAnswer;
  String providedAnswer;
  double providedAnswerDouble;
  bool providedAnswerBool;
  List<String> providedanswerWords;
  List<bool> providedanswerStates;
  List<int> answerParts;
  List<Pair> rightPositions;
  List<Pair> markedPositions;

  //Constructor used for simple String answers. (e.g. [Task4Cards])
  AnswerTaskEvent(this.providedAnswer);
  //Constructor used for [TaskMarkWords]
  AnswerTaskEvent.initMarkWords(List<String> providedanswerWords) {
    this.providedanswerWords = providedanswerWords;
  }
  //Constructor used for [TaskMatchCategory]
  AnswerTaskEvent.initMatchCategory(List<bool> providedanswerStates) {
    this.providedanswerStates = providedanswerStates;
  }
  //Constructor used for [TaskGridSelect]
  AnswerTaskEvent.initGridSelect(this.rightPositions, this.markedPositions);
  //Constructor used for [TaskMoney]
  AnswerTaskEvent.initMoneyTask(bool providedAnswerBool) {
    this.providedAnswerBool = providedAnswerBool;
  }
  //Constructor used for [NumberLine]
  AnswerTaskEvent.initNumberLine(bool providedAnswerBool) {
    this.providedAnswerBool = providedAnswerBool;
  }
  //Constructor used for [TaskVocableTest]
  AnswerTaskEvent.initVocableTest(this.providedanswerStates);
  //Constructor used for [TaskConnect]
  AnswerTaskEvent.initConnect(bool providedanswer) {
    this.providedAnswerBool = providedanswer;
  }
  //Constructor used for [TaskEquation]
  AnswerTaskEvent.initEquation(
      List<String> fullAnswer, List<String> providedanswerWords) {
    this.fullAnswer = fullAnswer;
    this.providedanswerWords = providedanswerWords;
  }
  AnswerTaskEvent.initEquationNew(List<String> fullAnswer) {
    this.fullAnswer = fullAnswer;
  }
  AnswerTaskEvent.initBuchstabieren(bool fullAnswer) {
    this.providedAnswerBool = fullAnswer;
  }
  AnswerTaskEvent.initZerlegung(bool providedAnswerBool) {
    this.providedAnswerBool = providedAnswerBool;
  }
  AnswerTaskEvent.initClockTask(bool providedAnswerBool) {
    this.providedAnswerBool = providedAnswerBool;
    this.providedAnswer = providedAnswer;
  }
}
