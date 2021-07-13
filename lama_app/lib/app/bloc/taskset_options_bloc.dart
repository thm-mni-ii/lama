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
import 'package:lama_app/app/task-system/taskset_validator.dart';
import 'package:lama_app/db/database_provider.dart';
import 'package:lama_app/util/input_validation.dart';

class TasksetOptionsBloc
    extends Bloc<TasksetOptionsEvent, TasksetOptionsState> {
  TasksetOptionsBloc({TasksetOptionsState initialState}) : super(initialState);

  String _tasksetUrl;
  List<TaskUrl> deletedUrls = [];

  @override
  Stream<TasksetOptionsState> mapEventToState(
      TasksetOptionsEvent event) async* {
    if (event is TasksetOptionsAbort) _return(event.context);
    if (event is TasksetOptionsPush) {
      yield TasksetOptionsWaiting("Aufgaben werden überprüft und geladen...");
      yield await _tasksetOptionsPush();
    }
    if (event is TasksetOptionsDelete) {
      yield TasksetOptionsWaiting("Aufgaben werden gelöscht...");
      yield await _deleteUrl(event.url);
    }
    if (event is TasksetOptionsChangeURL) _tasksetUrl = event.tasksetUrl;
    if (event is TasksetOptionsReload) {
      yield await _reload();
    }
    if (event is TasksetOptionsSelectUrl)
      yield TasksetOptionsUrlSelected(event.url.url);

    if (event is TasksetOptionsReAddUrl) {
      yield TasksetOptionsWaiting("Aufgaben werden überprüft und geladen...");
      yield await _tasksetOptionsReAddUrl(event.url);
    }
  }

  void _return(BuildContext context) {
    Navigator.pop(context);
  }

  Future<TasksetOptionsState> _tasksetOptionsPush() async {
    return await _insertUrl(TaskUrl(url: _tasksetUrl));
  }

  Future<TasksetOptionsState> _tasksetOptionsReAddUrl(TaskUrl url) async {
    TasksetOptionsState retValue = await _insertUrl(url);
    if (retValue is TasksetOptionsPushSuccess) deletedUrls.remove(url);
    return retValue;
  }

  Future<TasksetOptionsState> _insertUrl(TaskUrl url) async {
    //Check if URL is valid
    String error = await InputValidation.inputUrlWithJsonValidation(url.url);
    if (error != null) {
      return TasksetOptionsPushFailed(error: error, failedUrl: _tasksetUrl);
    }
    final response = await http.get(Uri.parse(url.url));
    //Check if URL is reachable
    if (response.statusCode == 200) {
      //Taskset validtion
      if (!TasksetValidator.isValidTaskset(jsonDecode(response.body))) {
        return TasksetOptionsPushFailed(
            error: 'Fehler beim lesen der Aufgaben!');
      }
    }
    //Insert URL to Database
    await DatabaseProvider.db.insertTaskUrl(url);
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
