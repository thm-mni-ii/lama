import 'dart:io';

import 'package:external_path/external_path.dart';
import 'package:ftpconnect/ftpconnect.dart';
import 'package:lama_app/app/repository/server_repository.dart';
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

  /// Uploads a File to a server
  Future<String> fileUpload(Taskset taskset) async {
    final serverRepo = ServerRepository();
    Directory dir = await getLocalDir();
    File fileToUpload = File("$dir/${taskset.name!}");

    // error handling??
    if (serverRepo.serverSettings != null) {
      FTPConnect ftpConnect = FTPConnect(
        serverRepo.serverSettings!.url,
        user: serverRepo.serverSettings!.userName,
        pass: serverRepo.serverSettings!.password,
      );
      if (await ftpConnect.createFolderIfNotExist(taskset.subject!)) {
        if (!(await ftpConnect.changeDirectory(taskset.subject!.toLowerCase())))
          return "Konnte Dir nicht wechseln";
        if (!(await ftpConnect.existFile(taskset.name!))) {
          try {
            await ftpConnect.connect();
            await ftpConnect.uploadFile(fileToUpload);
            await ftpConnect.disconnect();
            // lokal löschen
            fileToUpload.delete();
            return "";
          } catch (e) {
            //error
            throw e;
          }
        }
        return "File name bereits vergeben";
      }
      return "Dir konnte nicht erzeugt werden";
    }
    return "Keine Server Settings gesetzt";
  }

/*   Future<List<Taskset>> downloadTasksetDirectory() async {
    final serverRepo = ServerRepository();
    Directory dir = await getLocalDir();
    File fileToUpload;
    List<Taskset> tasksetList = [];

    if (serverRepo.serverSettings != null) {
      FTPConnect ftpConnect = FTPConnect(
        serverRepo.serverSettings!.url,
        user: serverRepo.serverSettings!.userName,
        pass: serverRepo.serverSettings!.password,
      );
      try {
        await ftpConnect.connect();
        await ftpConnect.downloadDirectory(serverRepo.serverSettings!.url, dir);
        await ftpConnect.disconnect();
      } catch (e) {
        //error
        throw e;
      }
    }
    return tasksetList;
  } */

  /// delets a taskset from the server
  Future<void> deleteTasksetFromServer(String fileName, String subject) async {
    final serverRepo = ServerRepository();
    // error handling??
    if (serverRepo.serverSettings != null) {
      FTPConnect ftpConnect = FTPConnect(
        serverRepo.serverSettings!.url,
        user: serverRepo.serverSettings!.userName,
        pass: serverRepo.serverSettings!.password,
      );
      try {
        if (await ftpConnect.changeDirectory(subject)) {
          await ftpConnect.connect();
          await ftpConnect.deleteFile(fileName);
          await ftpConnect.disconnect();
          return;
        }
      } catch (e) {
        //error
        throw e;
      }
    }
  }

  Future<Directory> getLocalDir() async {
    var path = await ExternalPath.getExternalStoragePublicDirectory(
        ExternalPath.DIRECTORY_DOCUMENTS);
    return Directory(path + '/LAMA');
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
