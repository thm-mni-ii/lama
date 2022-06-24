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
    on<CreateTasksetAddTask>(
      (event, emit) {
        taskset!.tasks!.add(event.task);
        emit(ChangedTasksListState());
      },
    );
    on<CreateTasksetGenerate>((event, emit) => taskset!.toJson());
    on<RemoveTask>((event, emit) {
      taskset!.tasks!.removeAt(event.index);
      emit(ChangedTasksListState());
    });
  }

  /// private method to abort the current creation process
  /// pops the screen and return null
  void _abort(BuildContext context) {
    Navigator.pop(context, null);
  }
}
