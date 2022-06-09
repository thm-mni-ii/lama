import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';

import '../event/taskset_creation_event.dart';
import '../state/taskset_creation_state.dart';
import '../task-system/taskset_model.dart';



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

  Taskset _taskset;

  TasksetCreationBloc({TasksetCreationState initialState}) : super(initialState);

  @override
  Stream<TasksetCreationState> mapEventToState(CreateTasksetEvent event) async* {
    if(event is CreateTasksetChangeName) _taskset.name = event.name;
    if(event is CreateTasksetChangeSubject) _taskset.subject = event.subject;
    if(event is CreateTasksetChangeGrade) _taskset.grade = event.grade;
    if(event is CreateTasksetAbort) _abort(event.context);
  }

  /// private method to abort the current creation process
  /// pops the screen and return null
  void _abort(BuildContext context) {
    Navigator.pop(context, null);
  }

}
