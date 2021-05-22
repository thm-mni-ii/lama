abstract class TaskEvent {}

class ShowNextTaskEvent extends TaskEvent {}

class AnswerTaskEvent extends TaskEvent {
  String providedAnswer;
  List<String> providedanswerWords;
  AnswerTaskEvent(this.providedAnswer);
  AnswerTaskEvent.initMarkWords(List<String> providedanswerWords) {
    this.providedanswerWords = providedanswerWords;
  }
}