import 'dart:convert';
import 'dart:io';
import 'package:external_path/external_path.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lama_app/app/screens/admin_menu_folder/taskset_manage/bloc/taskset_manage_event.dart';
import 'package:lama_app/app/state/create_taskset_state.dart';
import 'package:path_provider/path_provider.dart';

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
    on<AddTask>(
      (event, emit) {
        taskset!.tasks!.add(event.task);
        emit(ChangedTasksListState());
        print(event.task.toString());
      },
    );
    on<CreateTasksetGenerate>((event, emit) => _generate());
    on<EditTask>((event, emit) {
      int pos = taskset!.tasks!.indexWhere(
        (element) => element.id == event.task.id,
      );
      taskset!.tasks!.removeWhere((element) => element.id == event.task.id);
      taskset!.tasks!.insert(pos, event.task);
    });
    on<RemoveTask>((event, emit) {
      taskset!.tasks!.removeWhere((element) => element.id == event.id);
      emit(ChangedTasksListState());
    });
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
