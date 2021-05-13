abstract class ChooseTasksetEvent {}

class LoadAllTasksetsEvent extends ChooseTasksetEvent {
  String subject;
  LoadAllTasksetsEvent(this.subject);
}
