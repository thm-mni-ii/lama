abstract class TaskEvent {}

class ShowNextTaskEvent extends TaskEvent {}

class AnswerTaskEvent extends TaskEvent {
  String providedAnswer;
  AnswerTaskEvent(this.providedAnswer);
}
