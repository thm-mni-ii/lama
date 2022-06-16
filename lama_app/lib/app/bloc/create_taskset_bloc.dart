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
    if (event is FlushTaskset) taskset = null;
    if (event is CreateTasksetChangeName) {
      taskset.name = event.name;
    }
    if (event is CreateTasksetChangeSubject) {
      taskset.subject = event.subject;
      state.color = LamaColors.findSubjectColor(taskset.subject);
    }
    if (event is CreateTasksetChangeGrade) taskset.grade = event.grade;
    if (event is CreateTasksetAbort) _abort(event.context);
    if (event is EditTaskset) taskset = event.taskset;
    //TODO: Delete this after implementation
    /* if (taskset != null)
      print(
          "Name: ${taskset.name ?? "testname"}, Subject: ${taskset.subject ?? "testsubject"}, Grade: ${taskset.grade ?? "testgrade"}\n"); */
  }

  /// private method to abort the current creation process
  /// pops the screen and return null
  void _abort(BuildContext context) {
    Navigator.pop(context, null);
  }
}
