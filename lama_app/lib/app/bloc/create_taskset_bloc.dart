import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lama_app/app/state/create_taskset_state.dart';
import 'package:lama_app/app/task-system/task.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

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
    on<GenerateTaskset>((event, emit) => _generate(event.taskList, event.context));
  }

  /// private method to abort the current creation process
  /// pops the screen and return null
  void _abort(BuildContext context) {
    Navigator.pop(context, null);
  }

  Future<void> _generate(List<Task> taskList, BuildContext context) async {
    var status = await Permission.storage.status;
    print(status);
    if(await Permission.storage.request().isGranted) {
      taskset!.tasks = taskList;
      Directory? directory = Platform.isAndroid
        ? await getExternalStorageDirectory() //FOR ANDROID
        : await getApplicationDocumentsDirectory(); //FOR iOS
      String path = directory!.path;
      File file = File(path + '/LAMA/' + taskset!.name! + '.json');
      String json = jsonEncode(taskset);
      file.createSync(recursive: true);
      file.writeAsStringSync(json);
      Navigator.pop(context);
      Navigator.pop(context);
    } else {
      openAppSettings();
    }
  }
}
