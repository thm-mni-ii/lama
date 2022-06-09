import 'package:bloc/bloc.dart';
import 'package:lama_app/app/repository/taskset_repository.dart';
import 'package:lama_app/app/screens/admin_menu_folder/taskset_manage/bloc/taskset_manage_event.dart';
import 'package:lama_app/app/screens/admin_menu_folder/taskset_manage/bloc/taskset_manage_state.dart';
import 'package:lama_app/app/screens/admin_menu_folder/taskset_manage/screens/taskset_manage_screen.dart';

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
  TasksetManageBloc() : super(TasksetManageInitial()) {
    on<TasksetManageExpansion>((event, emit) {});
  }
}
