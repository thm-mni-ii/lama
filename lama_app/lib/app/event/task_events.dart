abstract class TaskEvent {}

class ShowNextTaskEvent extends TaskEvent {}

class AnswerTaskEvent extends TaskEvent {
  String providedAnswer;
  List<String> providedanswerWords;
  List<bool> providedanswerStates;
  AnswerTaskEvent(this.providedAnswer);
  AnswerTaskEvent.initMarkWords(List<String> providedanswerWords) {
    this.providedanswerWords = providedanswerWords;
  }
  AnswerTaskEvent.initMatchCategory(List<bool> providedanswerStates){
    this.providedanswerStates = providedanswerStates;
  }
}