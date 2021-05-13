abstract class ChooseTasksetEvent {}

class LoadAllTasksetsEvent extends ChooseTasksetEvent {
  String subject;
  int grade;
  LoadAllTasksetsEvent(this.subject, this.grade);
}
