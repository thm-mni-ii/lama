import 'package:bloc/bloc.dart';
import 'package:lama_app/app/screens/admin_menu_folder/taskset_manage_screen.dart';

import '../event/taskset_manage_event.dart';
import '../state/taskset_manage_state.dart';

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

  TasksetManageBloc({TasksetManageState initialState}) : super(initialState);

  @override
  Stream<TasksetManageState> mapEventToState(TasksetManageEvent event) async* {

  }
}