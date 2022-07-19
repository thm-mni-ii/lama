import 'package:bloc/bloc.dart';
import 'package:lama_app/app/screens/admin_menu_folder/taskset_manage/bloc/taskset_manage_event.dart';
import 'package:lama_app/app/screens/admin_menu_folder/taskset_manage/bloc/taskset_manage_state.dart';
import 'package:lama_app/app/screens/admin_menu_folder/taskset_manage/screens/taskset_manage_screen.dart';
import 'package:lama_app/app/task-system/taskset_model.dart';

///[Bloc] for the [TasksetManageScreen]
///
/// * see also
///    [TasksetManageScreen]
///    [TasksetManageScreenEvent]
///    [TasksetManageScreenState]
///    [Bloc]
///
/// Author: N. Soethe
/// latest Changes: 28.05.2022
class TasksetManageBloc extends Bloc<TasksetManageEvent, TasksetManageState> {
  List<Taskset> tasksetPool = [];
  List<Taskset> allTaskset = [];

  TasksetManageBloc() : super(TasksetManageInitial()) {
    on<AddTasksetPool>((event, emit) {
      tasksetPool.add(event.taskset);
      allTaskset
          .removeWhere((element) => element.taskurl == event.taskset.taskurl);
    });
    on<RemoveTasksetPool>((event, emit) {
      allTaskset.add(event.taskset);
      tasksetPool
          .removeWhere((element) => element.taskurl == event.taskset.taskurl);
    });
  }
}
