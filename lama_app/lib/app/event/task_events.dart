import 'package:lama_app/util/pair.dart';

abstract class TaskEvent {}

class ShowNextTaskEvent extends TaskEvent {}

class AnswerTaskEvent extends TaskEvent {
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

  AnswerTaskEvent.initConnect(bool providedanswer){
    this.providedAnswerBool = providedanswer;
  }
}
