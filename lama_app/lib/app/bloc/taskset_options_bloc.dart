import 'package:bloc/bloc.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lama_app/app/event/taskset_options_event.dart';
import 'package:lama_app/app/model/taskUrl_model.dart';
import 'package:lama_app/app/repository/taskset_repository.dart';
import 'package:lama_app/app/state/taskset_options_state.dart';
import 'package:lama_app/db/database_provider.dart';

class TasksetOprionsBloc
    extends Bloc<TasksetOptionsEvent, TasksetOptionsState> {
  TasksetOprionsBloc({TasksetOptionsState initialState}) : super(initialState);

  String _tasksetUrl;
  List<TaskUrl> deletedUrls = [];

  @override
  Stream<TasksetOptionsState> mapEventToState(
      TasksetOptionsEvent event) async* {
    if (event is TasksetOptionsAbort) _return(event.context);
<<<<<<< HEAD
    if (event is TasksetOptionsPush) {
      yield await _tasksetOptionsPush();
      event.tasksetRepository.reloadTasksetLoader();
    }
=======
    if (event is TasksetOptionsPush)
      yield await _tasksetOptionsPush(event.context);
>>>>>>> Testing URL Validation
    if (event is TasksetOptionsChangeURL) _tasksetUrl = event.tasksetUrl;
    if (event is TasksetOptionsReload) yield await _reload();
    if (event is TasksetOptionsDelete) {
      event.tasksetRepository.reloadTasksetLoader();
      yield await _deleteUrl(event.url);
    }
    if (event is TasksetOptionsPushUrl)
      yield await _tasksetOptionsReloadUrl(event.url);
  }

  void _return(BuildContext context) {
    Navigator.pop(context);
  }

  Future<TasksetOptionsState> _tasksetOptionsPush(BuildContext context) async {
    return await _insertUrl(TaskUrl(url: _tasksetUrl));
  }

  Future<TasksetOptionsPushSuccess> _tasksetOptionsReloadUrl(
      TaskUrl url) async {
    TasksetOptionsState retValue = await _insertUrl(url);
    if (retValue is TasksetOptionsPushSuccess) deletedUrls.remove(url);
    return retValue;
  }

  Future<TasksetOptionsState> _insertUrl(TaskUrl url) async {
    //Validation
    if (!Uri.tryParse(url.url).hasAbsolutePath)
      return TasksetOptionsPushFailed(failedUrl: _tasksetUrl);
    final response = await http.head(Uri.parse(url.url));
    if (response.statusCode != 200) {
      return TasksetOptionsPushFailed(
          error: 'URL nicht erreichbar!', failedUrl: _tasksetUrl);
    }

    //Insert URL in Database
    await DatabaseProvider.db.insertTaskUrl(url);
    //Reload Tasksets
    //RepositoryProvider.of<TasksetRepository>(context).reloadTasksetLoader();
    return TasksetOptionsPushSuccess();
  }

  Future<TasksetOptionsDeleteSuccess> _deleteUrl(TaskUrl url) async {
    await DatabaseProvider.db.deleteTaskUrl(url.id);
    deletedUrls.add(url);
    return TasksetOptionsDeleteSuccess();
  }

  Future<TasksetOptionsDefault> _reload() async {
    List<TaskUrl> urls = await DatabaseProvider.db.getTaskUrl();
    return TasksetOptionsDefault(urls, deletedUrls);
  }
}
