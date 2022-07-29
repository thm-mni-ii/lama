import 'dart:io';

import 'package:lama_app/app/task-system/task.dart';
import 'package:lama_app/app/task-system/taskset_loader.dart';
import 'package:lama_app/app/task-system/taskset_model.dart';
import 'package:http/http.dart' as http;

/// Repository that provides access to the loaded tasksets.
///
/// Wraps the TasksetLoader to conform to the Bloc pattern.
///
/// Author: K.Binder
class TasksetRepository {
  late TasksetLoader tasksetLoader;

  List<String> subjectList = ["Mathe", "Deutsch", "Englisch", "Sachkunde"];
  List<String> klassenStufe = ["1", "2", "3", "4", "5", "6"];

  ///Initializes the [TasksetLoader] and loads all tasksets.
  Future<void> initialize() async {
    tasksetLoader = TasksetLoader();
    await tasksetLoader.loadAllTasksets();
  }

  ///Returns a List of all [Taskset] that belong to [subject] and are aimed at [grade]
  List<Taskset>? getTasksetsForSubjectAndGrade(String subject, int? grade) {
    return tasksetLoader.getLoadedTasksetsForSubjectAndGrade(subject, grade);
  }

  ///Returns a List of all [Taskset] that belong to [subject] and are aimed at [grade]
  List<Taskset> getTasksetsForGrade(int grade) {
    List<Taskset> classTaskset = [];
    for (var subject in subjectList) {
      classTaskset.addAll(getTasksetsForSubjectAndGrade(subject, grade)!);
    }

    return classTaskset;
  }

  ///Returns a List of all [Taskset] that belong to [subject] and are aimed at [grade] which are used by the children
  List<Taskset> getTasksetsForGradeWhichAreInUse(int grade) {
    List<Taskset> classTaskset = [];
    for (var subject in subjectList) {
      classTaskset.addAll(
          tasksetLoader.getTasksetPoolForSubjectAndGrade(subject, grade)!);
    }

    return classTaskset;
  }

  ///Reloads the [TasksetLoader] and loads all tasksets.
  ///
  ///Under the hood this method is identical to [initialize()] except it doesnt return a Future.
  ///This is because it is used to reload the tasks during runtime, while [initialize()] is called during initialization.
  ///Therefore this method exists to provide a more intuitively named method.
  void reloadTasksetLoader() async {
    tasksetLoader = TasksetLoader();
    await tasksetLoader.loadAllTasksets();
  }

  // TODO
  /// adds a Taskset to the server
  Future<void> writeToServer(Taskset taskset, String url) async {
    var response = await http.post(
      Uri.parse(url),
      body: taskset.toJson(),
    );
    // response abfangen (error)
    if (response.statusCode >= 400) {
      throw Error();
    }
  }

  Future<String> fileUpload(/* String text,  */ File file, String url) async {
    //create multipart request for POST or PATCH method
    var request = http.MultipartRequest("POST", Uri.parse(url));
    //add text fields
    //request.fields["text_field"] = text;
    //create multipart using filepath, string or bytes
    var pic = await http.MultipartFile.fromPath("file_field", file.path);
    //add multipart to request
    request.files.add(pic);
    var response = await request.send();

    //Get the response from the server
    var responseData = await response.stream.toBytes();
    var responseString = String.fromCharCodes(responseData);
    print(responseString);
    return responseString;
  }

  //TODO
  /// updates the taskset(s) on the server
  Future<void> deleteTasksetFromServer(String url) async {
    var response = await http.delete(Uri.parse(url));
  }

  /// gives a List of TaskType depending on a specific subject
  static List<TaskType> giveEnumBySubject(String subject) {
    switch (subject) {
      case "Mathe":
        return [
          TaskType.fourCards,
          TaskType.moneyTask,
          TaskType.equation,
          TaskType.zerlegung,
          TaskType.numberLine,
          TaskType.clock
        ];
      case "Deutsch":
        return [
          TaskType.fourCards,
          TaskType.markWords,
          TaskType.matchCategory,
          TaskType.gridSelect,
          TaskType.buchstabieren,
          TaskType.clozeTest
        ];
      case "Englisch":
        return [
          TaskType.fourCards,
          TaskType.markWords,
          TaskType.matchCategory,
          TaskType.gridSelect,
          TaskType.buchstabieren,
          TaskType.vocableTest,
          TaskType.clozeTest
        ];
      case "Sachkunde":
        return [
          TaskType.fourCards,
          TaskType.markWords,
          TaskType.matchCategory,
          TaskType.gridSelect,
          TaskType.buchstabieren,
        ];
      default:
        return [];
    }
  }
}
