import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:lama_app/app/event/taskset_options_event.dart';
import 'package:lama_app/app/state/taskset_options_state.dart';
import 'package:lama_app/db/database_provider.dart';

class TasksetOprionsBloc
    extends Bloc<TasksetOptionsEvent, TasksetOptionsState> {
  TasksetOprionsBloc({TasksetOptionsState initialState}) : super(initialState);

  @override
  Stream<TasksetOptionsState> mapEventToState(
      TasksetOptionsEvent event) async* {
    if (event is TasksetOptionsAbort) _return(event.context);
    if (event is TasksetOptionsPush) yield _tasksetOptionsPush();
  }

  void _return(BuildContext context) {
    Navigator.pop(context);
  }

  TasksetOptionsPushSuccess _tasksetOptionsPush() {
    return TasksetOptionsPushSuccess();
  }
}
