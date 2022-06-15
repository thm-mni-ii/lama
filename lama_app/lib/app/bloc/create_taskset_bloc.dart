import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:lama_app/app/state/create_taskset_state.dart';
import 'package:lama_app/util/LamaColors.dart';

import '../event/create_taskset_event.dart';
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
  Taskset taskset;
  CreateTasksetBloc({this.taskset}) : super(CreateTasksetState());

  @override
  Stream<CreateTasksetState> mapEventToState(CreateTasksetEvent event) async* {
    if (event is CreateTasksetChangeName) taskset.name = event.name;
    if (event is CreateTasksetChangeSubject) {
      taskset.subject = event.subject;
      state.color = LamaColors.findSubjectColor(taskset);
    }
    ;
    if (event is CreateTasksetChangeGrade) taskset.grade = event.grade;
    if (event is CreateTasksetAbort) _abort(event.context);
    if (event is EditTaskset) taskset = event.taskset;
    if (event is InitialTaskset) taskset = null;
    if (event is SetMissingAttributes) {
      taskset.tasks = [];
      // TODO default values + url from db?
      /* taskset.randomTaskAmount = ; 
      taskset.randomizeOrder = ; 
      taskset.taskurl = ;  */
    }
    ;
    //TODO: Delete this after implementation
    if (taskset != null)
      print(
          "Name: ${taskset.name}, Subject: ${taskset.subject}, Grade: ${taskset.grade}\n");
  }

  /// private method to abort the current creation process
  /// pops the screen and return null
  void _abort(BuildContext context) {
    Navigator.pop(context, null);
  }
}
