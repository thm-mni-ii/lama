import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lama_app/app/model/taskUrl_model.dart';
import 'package:lama_app/app/repository/taskset_repository.dart';
import 'package:lama_app/app/state/create_taskset_state.dart';
import 'package:lama_app/db/database_provider.dart';
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
/// Author: Nico Soethe
/// latest Changes: 17.06.2022
class CreateTasksetBloc extends Bloc<CreateTasksetEvent, CreateTasksetState> {
  Taskset taskset;
  CreateTasksetBloc({this.taskset}) : super(InitialState());

  @override
  Stream<CreateTasksetState> mapEventToState(CreateTasksetEvent event) async* {
    if (event is FlushTaskset) taskset = null;
    if (event is CreateTasksetAbort) _abort(event.context);
    if (event is EditTaskset) taskset = event.taskset;
    if (event is CreateTasksetAddTask) {
      taskset.tasks.add(event.task);
      yield ChangedTasksListState();
    }
    if (event is RemoveTask) {
      taskset.tasks.removeAt(event.index);
      yield ChangedTasksListState();
    }
    /* if (event is GenerateTaskset) {
      DatabaseProvider.db.insertTaskUrl(TaskUrl(url: ""));
      // TODO write to server
      RepositoryProvider.of<TasksetRepository>(context).writeToServer(taskset);
    } */
  }

  /// private method to abort the current creation process
  /// pops the screen and return null
  void _abort(BuildContext context) {
    Navigator.pop(context, null);
  }

  Color colorizeAppbar(String subject) {
    LamaColors.findSubjectColor(subject);
  }
}
