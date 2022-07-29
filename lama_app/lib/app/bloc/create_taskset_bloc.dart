import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lama_app/app/state/create_taskset_state.dart';
import 'package:external_path/external_path.dart';

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
      //taskset!.tasks!.addAll(event.taskList);
      taskset!.tasks = event.taskList;
    });
    on<CreateTasksetGenerate>((event, emit) => _generate());
    on<AddUrlToTaskset>((event, emit) => taskset!.taskurl = event.taskUrl);
  }

  /// private method to abort the current creation process
  /// pops the screen and return null
  void _abort(BuildContext context) {
    Navigator.pop(context, null);
  }

  Future<void> _generate() async {
    var path = await ExternalPath.getExternalStoragePublicDirectory(
        ExternalPath.DIRECTORY_DOCUMENTS);
    File file = File(path + '/LAMA/' + taskset!.name! + '.json');
    String json = jsonEncode(taskset);
    file.createSync(recursive: true);
    file.writeAsStringSync(json);
  }
}
