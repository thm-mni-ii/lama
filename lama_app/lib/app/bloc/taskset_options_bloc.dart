import 'dart:convert';
import 'dart:io';

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
    if (event is TasksetOptionsPush) {
      yield await _tasksetOptionsPush(event.context);
      yield await _tasksetOptionsPush();
      event.tasksetRepository.reloadTasksetLoader();
    }
    if (event is TasksetOptionsDelete) {
      event.tasksetRepository.reloadTasksetLoader();
      yield TasksetOptionsWaiting();
      yield await _tasksetOptionsPush();
    }
    if (event is TasksetOptionsChangeURL) _tasksetUrl = event.tasksetUrl;
    if (event is TasksetOptionsReload) {
      yield await _reload();
    }
    if (event is TasksetOptionsSelectUrl)
      yield TasksetOptionsUrlSelected(event.url.url);
    if (event is TasksetOptionsReaddUrl) {
      yield TasksetOptionsWaiting();
      yield await _tasksetOptionsReaddUrl(event.url);
    }
  }

  void _return(BuildContext context) {
    Navigator.pop(context);
  }

  Future<TasksetOptionsState> _tasksetOptionsPush() async {
    return await _insertUrl(TaskUrl(url: _tasksetUrl));
  }

  Future<TasksetOptionsPushSuccess> _tasksetOptionsReaddUrl(TaskUrl url) async {
    TasksetOptionsState retValue = await _insertUrl(url);
    if (retValue is TasksetOptionsPushSuccess) deletedUrls.remove(url);
    return retValue;
  }

  Future<TasksetOptionsState> _insertUrl(TaskUrl url) async {
    //Check if URL can be parsed
    if (!Uri.tryParse(url.url).hasAbsolutePath)
      return TasksetOptionsPushFailed(failedUrl: _tasksetUrl);
    try {
      final response = await http.get(Uri.parse(url.url));
      //Check if URL is reachable
      if (response.statusCode == 200) {
        //Check if URL contains valid json code
        try {
          jsonDecode(response.body);
        } on FormatException {
          return TasksetOptionsPushFailed(
              error: 'Der Inhalt der URL ist kein "json"!',
              failedUrl: _tasksetUrl);
        }
        //Reload Tasksets
        //RepositoryProvider.of<TasksetRepository>(context).reloadTasksetLoader();

        //Insert URL to Database
        await DatabaseProvider.db.insertTaskUrl(url);
        return TasksetOptionsPushSuccess();
      } else {
        return TasksetOptionsPushFailed(
            error: 'URL nicht erreichbar!', failedUrl: _tasksetUrl);
      }
    } on SocketException {
      return TasksetOptionsPushFailed(
          error: 'Da ist etwas gewaltig schiefgelaufen!',
          failedUrl: _tasksetUrl);
    }
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
