import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:lama_app/app/state/create_taskset_state.dart';
import 'package:lama_app/util/LamaColors.dart';

import '../event/create_taskset_event.dart';
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
class CreateTasksetBloc extends Bloc<CreateTasksetEvent, CreateTasksetState> {

  CreateTasksetBloc({CreateTasksetState initialState}) : super(CreateTasksetState(taskset: Taskset("", "", 1)));

  @override
  Stream<CreateTasksetState> mapEventToState(CreateTasksetEvent event) async* {
    if(event is CreateTasksetChangeName) state.taskset.name = event.name;
    if(event is CreateTasksetChangeSubject) {state.taskset.subject= event.subject; state.color = LamaColors.findSubjectColor(state.taskset);};
    if(event is CreateTasksetChangeGrade) state.taskset.grade = event.grade;
    if(event is CreateTasksetAbort) _abort(event.context);
    //TODO: Delete this after implementation
    print("Name: ${state.taskset.name}, Subject: ${state.taskset.subject}, Grade: ${state.taskset.grade}\n");
  }

  /// private method to abort the current creation process
  /// pops the screen and return null
  void _abort(BuildContext context) {
    Navigator.pop(context, null);
  }

}
