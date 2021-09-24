import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lama_app/app/event/taskset_options_event.dart';
import 'package:lama_app/app/model/taskUrl_model.dart';
import 'package:lama_app/app/state/taskset_options_state.dart';
import 'package:lama_app/app/task-system/taskset_validator.dart';
import 'package:lama_app/db/database_provider.dart';
import 'package:lama_app/util/input_validation.dart';

///[Bloc] for the [TasksetOptionScreen]
///
/// * see also
///    [TasksetOptionScreen]
///    [TasksetOptionsEvent]
///    [TasksetOptionsState]
///    [Bloc]
///
/// Author: L.Kammerer
/// Latest Changes: 26.06.2021
class TasksetOptionsBloc
    extends Bloc<TasksetOptionsEvent, TasksetOptionsState> {
  TasksetOptionsBloc({TasksetOptionsState initialState}) : super(initialState);

  ///url that should be stored in the database later on
  ///incoming events are used to change the value
  String _tasksetUrl;
  //is used to show all urls which are deleted in the time this screen is used
  List<TaskUrl> deletedUrls = [];

  @override
  Stream<TasksetOptionsState> mapEventToState(
      TasksetOptionsEvent event) async* {
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

  ///(private)
  ///stores the [_tasksetUrl] in the Database using [_insertUrl]
  ///
  ///{@return} an [TasksetOptionsPushSuccess] state or an error state depending on [_insertUrl] result
  Future<TasksetOptionsState> _tasksetOptionsPush() async {
    return await _insertUrl(TaskUrl(url: _tasksetUrl));
  }

  ///(private)
  ///stores an url from [deletedUrls] in to the database using [_insertUrl]
  ///and removes it from [deletedUrls]
  ///
  ///{@params}[TaskUrl] url that should be inserted and removed from [deletedUrls]
  ///
  ///{@return} an [TasksetOptionsPushSuccess] state or an error state depending on [_insertUrl] result
  Future<TasksetOptionsState> _tasksetOptionsReAddUrl(TaskUrl url) async {
    TasksetOptionsState retValue = await _insertUrl(url);
    if (retValue is TasksetOptionsPushSuccess) deletedUrls.remove(url);
    return retValue;
  }

  ///(private)
  ///stores an url in to the database
  ///the url will be validated via [InputValidation.inputUrlWithJsonValidation]
  ///and also double check in this function.
  ///the validation for Taskset done via [TasksetValidator.isValidTaskset]
  ///
  ///{@param}[TaskUrl] url that should be stored in the database
  ///
  ///{@return}[TasksetOptionsPushSuccess] if the url validation is successfull else [TasksetOptionsPushFailed]
  ///with specific error message
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
      String tasksetError =
          TasksetValidator.isValidTaskset(jsonDecode(response.body));
      if (tasksetError != null) {
        return TasksetOptionsPushFailed(error: tasksetError);
      }
    }
    //Insert URL to Database
    await DatabaseProvider.db.insertTaskUrl(url);
    return TasksetOptionsPushSuccess();
  }

  ///(private)
  ///delete an url from the database
  ///
  ///{@param}[TaskUrl] url that should be deleted
  Future<TasksetOptionsDeleteSuccess> _deleteUrl(TaskUrl url) async {
    await DatabaseProvider.db.deleteTaskUrl(url.id);
    deletedUrls.add(url);
    return TasksetOptionsDeleteSuccess();
  }

  ///(private)
  ///load all stored [TaskUrl] from the database and
  ///pack them in [TasksetOptionsDefault] with the [deletedUrls]
  ///
  ///{@return}[TasksetOptionsDefault] with all loaded [TaskUrl] and [deletedUrls]
  Future<TasksetOptionsDefault> _reload() async {
    List<TaskUrl> urls = await DatabaseProvider.db.getTaskUrl();
    return TasksetOptionsDefault(urls, deletedUrls);
  }
}
