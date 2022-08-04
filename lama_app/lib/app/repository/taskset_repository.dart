import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lama_app/app/repository/server_repository.dart';
import 'package:lama_app/app/task-system/task.dart';
import 'package:lama_app/app/task-system/taskset_loader.dart';
import 'package:lama_app/app/task-system/taskset_model.dart';
import 'package:dartssh2/dartssh2.dart';

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
  Future<void> initialize(ServerRepository serverRepository) async {
    tasksetLoader = TasksetLoader();
    await tasksetLoader.loadAllTasksets(serverRepository);
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
  void reloadTasksetLoader(ServerRepository serverRepository) async {
    tasksetLoader = TasksetLoader();
    await tasksetLoader.loadAllTasksets(serverRepository);
  }

  /// Uploads a File to a server
  Future<String> fileUpload(BuildContext context, Taskset taskset) async {
    final serverRepo = RepositoryProvider.of<ServerRepository>(context);

    // error handling??
    if (serverRepo.serverSettings != null && taskset.taskurl!.id == null) {
      try {
        final client = SSHClient(
          await SSHSocket.connect(
            serverRepo.serverSettings!.url,
            serverRepo.serverSettings!.port,
          ),
          username: serverRepo.serverSettings!.userName,
          onPasswordRequest: () => serverRepo.serverSettings!.password,
        );

        final sftp = await client.sftp();
        final list = await sftp.listdir('./upload');
        List<String> folderList = list.map((e) => e.filename).toList();
        if (!folderList.contains(taskset.grade.toString())) {
          await sftp.mkdir('./upload/${taskset.grade}/');
        }
        final file = await sftp.open(
          './upload/${taskset.grade}/${taskset.name!}',
          mode: SftpFileOpenMode.create | SftpFileOpenMode.write,
        );
        String tmp = json.encode(taskset.toJson());
        var bytes = Utf8Encoder().convert(tmp);
        await file.write(Stream.value(bytes));
        file.close();
        client.close();
        client.done;

        return "";
      } catch (e) {
        throw e; // in ui fangen
      }
    }
    // TODO nutzen um anzuzeigen das was fehlts
    return "Keine Server Settings gesetzt";
  }

  Future<List<Taskset>> downloadTasksetDirectory(
      ServerRepository serverRepo) async {
    List<Taskset> tasksetList = [];

    //try {
    if (serverRepo.serverSettings != null) {
      final client = SSHClient(
        await SSHSocket.connect(
          serverRepo.serverSettings!.url,
          serverRepo.serverSettings!.port,
        ),
        username: serverRepo.serverSettings!.userName,
        onPasswordRequest: () => serverRepo.serverSettings!.password,
      );

      Map<String, List<String>> allFileNames = {};

      final sftp = await client.sftp();
      final list = await sftp.listdir('./upload');

      for (var folderName in list) {
        if (klassenStufe.contains(folderName.filename)) {
          final listOfFileNames =
              await sftp.listdir('./upload/${folderName.filename}');
          final l = listOfFileNames.map((e) => e.filename).toList();
          l.removeWhere((element) => element == '.' || element == "..");
          allFileNames.addAll({'${folderName.filename}': l});
        }
      }
      var listTmp = [];
      allFileNames.forEach((key, value) {
        value.forEach((element) {
          listTmp.add('./upload/$key/$element');
        });
      });

      for (var fullname in listTmp) {
        final tmp = await sftp.open(fullname);
        final content = await tmp.readBytes();
        print(utf8.decode(content));
        tasksetList
            .add(Taskset.fromJson(json.decode(Utf8Decoder().convert(content))));
        //print(latin1.decode(content));
        tmp.close();
      }

      client.close();
      client.done;
    }
    /* } catch (e) {
      //error
      throw e;
    } */
    return tasksetList;
  }

  /// delets a taskset from the server
  Future<String> deleteTasksetFromServer(
      BuildContext context, Taskset taskset) async {
    final serverRepo = RepositoryProvider.of<ServerRepository>(context);
    // error handling??
    if (serverRepo.serverSettings != null && taskset.taskurl!.id == null) {
      try {
        final client = SSHClient(
          await SSHSocket.connect(
            serverRepo.serverSettings!.url,
            serverRepo.serverSettings!.port,
          ),
          username: serverRepo.serverSettings!.userName,
          onPasswordRequest: () => serverRepo.serverSettings!.password,
        );
        print(taskset.toJson().toString());
        final sftp = await client.sftp();
        await sftp.remove('./upload/${taskset.grade}/${taskset.name}');
        client.close();
        client.done;

        return "";
      } catch (e) {
        //error
        throw e;
      }
    }
    return "Keine Server Settings gesetzt";
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
          //TaskType.buchstabieren,
          TaskType.clozeTest
        ];
      case "Englisch":
        return [
          TaskType.fourCards,
          TaskType.markWords,
          TaskType.matchCategory,
          TaskType.gridSelect,
          //TaskType.buchstabieren,
          //TaskType.vocableTest,
          TaskType.clozeTest
        ];
      case "Sachkunde":
        return [
          TaskType.fourCards,
          TaskType.markWords,
          TaskType.matchCategory,
          TaskType.gridSelect,
          TaskType.clozeTest,
          //TaskType.connect,
          //TaskType.buchstabieren,
        ];
      default:
        return [];
    }
  }
}
