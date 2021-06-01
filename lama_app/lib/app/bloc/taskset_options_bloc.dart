import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:lama_app/app/event/taskset_options_event.dart';
import 'package:lama_app/app/model/taskUrl_model.dart';
import 'package:lama_app/app/state/taskset_options_state.dart';
import 'package:lama_app/db/database_provider.dart';

class TasksetOprionsBloc
    extends Bloc<TasksetOptionsEvent, TasksetOptionsState> {
  TasksetOprionsBloc({TasksetOptionsState initialState}) : super(initialState);

  String _tasksetUrl;

  @override
  Stream<TasksetOptionsState> mapEventToState(
      TasksetOptionsEvent event) async* {
    if (event is TasksetOptionsAbort) _return(event.context);
    if (event is TasksetOptionsPush) yield await _tasksetOptionsPush();
    if (event is TasksetOptionsChangeURL) _tasksetUrl = event.tasksetUrl;
    if (event is TasksetOptionsReload) yield await _reload();
    print(_tasksetUrl);
  }

  void _return(BuildContext context) {
    Navigator.pop(context);
  }

  Future<TasksetOptionsPushSuccess> _tasksetOptionsPush() async {
    await DatabaseProvider.db.insertTaskUrl(TaskUrl(url: _tasksetUrl));
    return TasksetOptionsPushSuccess();
  }

  Future<TasksetOptionsDefault> _reload() async {
    List<TaskUrl> urls = await DatabaseProvider.db.getTaskUrl();
    return TasksetOptionsDefault(urls);
  }
}
