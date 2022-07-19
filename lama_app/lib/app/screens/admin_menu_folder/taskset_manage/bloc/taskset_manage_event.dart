import 'package:lama_app/app/screens/admin_menu_folder/taskset_manage/screens/taskset_manage_screen.dart';
import 'package:lama_app/app/task-system/taskset_model.dart';

/// Events used by [TasksetManageScreen] and [TasksetManageBloc]
///
/// Author: N. Soethe
/// latest Changes: 28.05.2022
abstract class TasksetManageEvent {}

class CreateTaskset extends TasksetManageEvent {}

/// adds a taskset to the pool of used tasksets
class AddTasksetPool extends TasksetManageEvent {
  final Taskset taskset;

  AddTasksetPool(this.taskset);
}
/// removes a taskset from the pool of used tasksets
class RemoveTasksetPool extends TasksetManageEvent {
  final Taskset taskset;

  RemoveTasksetPool(this.taskset);
}
