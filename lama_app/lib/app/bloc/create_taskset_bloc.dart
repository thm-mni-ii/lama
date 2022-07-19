import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lama_app/app/state/create_taskset_state.dart';

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
  Taskset? taskset;
  CreateTasksetBloc({this.taskset}) : super(InitialState()) {
    on<CreateTasksetAbort>((event, emit) => _abort(event.context));
    on<EditTaskset>((event, emit) => taskset = event.taskset);
    on<AddTaskListToTaskset>((event, emit) {
      taskset!.tasks!.addAll(event.taskList);
    });
    on<CreateTasksetGenerate>((event, emit) => taskset!.toJson());
    on<AddUrlToTaskset>((event, emit) => taskset!.taskurl = event.taskUrl);
  }

  /// private method to abort the current creation process
  /// pops the screen and return null
  void _abort(BuildContext context) {
    Navigator.pop(context, null);
  }
}
