import 'package:bloc/bloc.dart';
import 'package:lama_app/app/screens/admin_menu_folder/taskset_creation_cart_screen.dart';

import '../event/taskset_creation_cart_event.dart';
import '../state/taskset_creation_cart_state.dart';

///[Bloc] for the [TasksetCreationCartScreen]
///
/// * see also
///    [TasksetManageScreen]
///    [TasksetManageScreenEvent]
///    [TasksetManageScreenState]
///    [Bloc]
///
/// Author: N. Soethe
/// latest Changes: 01.06.2022
class TasksetCreationCartBloc extends Bloc<TasksetCreationListEvent, TasksetCreationListState> {

  TasksetCreationCartBloc({TasksetCreationListState initialState}) : super(initialState);

  @override
  Stream<TasksetCreationListState> mapEventToState(TasksetCreationListEvent event) async* {

  }
}