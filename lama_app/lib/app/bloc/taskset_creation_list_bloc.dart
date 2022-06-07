import 'package:bloc/bloc.dart';
import 'package:lama_app/app/screens/admin_menu_folder/taskset_creation_list_screen.dart';

import '../event/taskset_creation_list_event.dart';
import '../state/taskset_creation_list_state.dart';

///[Bloc] for the [TasksetCreationListScreen]
///
/// * see also
///    [TasksetManageScreen]
///    [TasksetManageScreenEvent]
///    [TasksetManageScreenState]
///    [Bloc]
///
/// Author: N. Soethe
/// latest Changes: 01.06.2022
class TasksetCreationListBloc extends Bloc<TasksetCreationListEvent, TasksetCreationListState> {

  TasksetCreationListBloc({TasksetCreationListState initialState}) : super(initialState);

  @override
  Stream<TasksetCreationListState> mapEventToState(TasksetCreationListEvent event) async* {

  }
}