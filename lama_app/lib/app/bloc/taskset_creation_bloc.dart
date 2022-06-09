import 'package:bloc/bloc.dart';
import 'package:lama_app/app/screens/admin_menu_folder/taskset_creation_screen.dart';

import '../event/taskset_creation_event.dart';
import '../state/taskset_creation_state.dart';



///[Bloc] for the [TasksetCreationScreen]
///
/// * see also
///    [TasksetCreationScreen]
///    [TasksetCreationScreenEvent]
///    [TasksetCreationScreenState]
///    [Bloc]
///
/// Author: N. Soethe
/// latest Changes: 01.06.2022
class TasksetCreationBloc extends Bloc<CreateTasksetEvent, TasksetCreationState> {

  TasksetCreationBloc({TasksetCreationState initialState}) : super(initialState);

  @override
  Stream<TasksetCreationState> mapEventToState(CreateTasksetEvent event) async* {

  }
}
