/// BaseEvent for the [ChooseTasksetBloc]
///
/// Author: K.Binder
abstract class ChooseTasksetEvent {}

/// Subclass of [ChooseTasksetEvent]
///
/// This event contains the [subject] and the [grade] of the
/// tasksets, that should be loaded.
///
/// Author: K.Binder
class LoadAllTasksetsEvent extends ChooseTasksetEvent {
  String subject;
  int grade;
  LoadAllTasksetsEvent(this.subject, this.grade);
}
