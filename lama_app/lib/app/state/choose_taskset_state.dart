import 'package:lama_app/app/task-system/taskset_model.dart';

///BaseState for the [ChooseTasksetBloc].
///
///Author: K.Binder
abstract class ChooseTasksetState {}

///Subclass of [ChooseTasksetState].
///
///Emitted while the [ChooseTasksetBloc] is loading all tasksets.
///
///Author: K.Binder
class LoadingAllTasksetsState extends ChooseTasksetState {}

///Subclass of [ChooseTasksetState].
///
///Emitted when all tasksets are loaded. They get passed via [tasksets].
class LoadedAllTasksetsState extends ChooseTasksetState {
  List<Taskset> tasksets;
  LoadedAllTasksetsState(this.tasksets);
}
