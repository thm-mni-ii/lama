import 'package:lama_app/app/task-system/taskset_model.dart';

abstract class ChooseTasksetState {}

class LoadingAllTasksetsState extends ChooseTasksetState {}

class LoadedAllTasksetsState extends ChooseTasksetState {
  List<Taskset> tasksets;
  LoadedAllTasksetsState(this.tasksets);
}
