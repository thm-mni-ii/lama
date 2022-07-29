import 'package:bloc/bloc.dart';
import 'package:lama_app/app/screens/admin_menu_folder/taskset_manage/bloc/taskset_manage_event.dart';
import 'package:lama_app/app/screens/admin_menu_folder/taskset_manage/bloc/taskset_manage_state.dart';
import 'package:lama_app/app/screens/admin_menu_folder/taskset_manage/screens/taskset_manage_screen.dart';
import 'package:lama_app/app/task-system/taskset_model.dart';
import 'package:lama_app/db/database_provider.dart';

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
  List<Taskset> tasksetPool;
  List<Taskset> allTaskset;

  TasksetManageBloc({required this.tasksetPool, required this.allTaskset})
      : super(TasksetManageInitial()) {
    on<AddTasksetPool>((event, emit) {
      tasksetPool.add(event.taskset);
      event.taskset.isInPool = true;
      emit(ChangeTasksetStatus());
    });
    on<RemoveTasksetPool>((event, emit) {
      tasksetPool.remove(event.taskset); // remove where
      event.taskset.isInPool = false;
      emit(ChangeTasksetStatus());
    });
    on<AddListOfTasksetsPool>((event, emit) {
      event.tasksetList.forEach((element) {
        if (!tasksetPool.contains(element)) {
          tasksetPool.add(element);
          element.isInPool = true;
        }
      });
      emit(ChangeTasksetStatus());
    });
    on<RemoveListOfTasksetsPool>((event, emit) {
      event.tasksetList.forEach((element) {
        element.isInPool = false;
        tasksetPool.remove(element); // remove where
      });
      emit(ChangeTasksetStatus());
    });
    on<DeleteTaskset>((event, emit) {// benutzen
      DatabaseProvider.db.deleteTaskUrl(event.taskUrl.id);
      allTaskset.removeWhere((element) => element.taskurl == event.taskUrl);
      // vom Server löschen 
      //ServerRepository().deleteFile();
      emit(ChangeTasksetStatus());
    });
  }
}
