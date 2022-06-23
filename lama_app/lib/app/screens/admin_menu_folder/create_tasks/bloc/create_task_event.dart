part of 'create_task_bloc.dart';

@immutable
abstract class CreateTaskEvent {}

class EditTask extends CreateTaskEvent {
  final Task task;
  EditTask({required this.task});
}
