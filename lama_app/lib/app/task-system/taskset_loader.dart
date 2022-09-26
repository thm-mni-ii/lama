import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:lama_app/app/repository/server_repository.dart';
import 'package:lama_app/app/repository/taskset_repository.dart';
import 'package:lama_app/app/screens/admin_menu_folder/admin_menu_screen.dart';
import 'package:lama_app/util/input_validation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lama_app/app/model/taskUrl_model.dart';
import 'package:lama_app/app/task-system/subject_grade_relation.dart';
import 'package:lama_app/app/task-system/taskset_model.dart';
import 'package:lama_app/app/task-system/taskset_validator.dart';
import 'package:lama_app/db/database_provider.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:http/http.dart' as http;
import 'dart:convert' show utf8;

import 'dart:convert';
import 'dart:io';

///Class responsible for loading the standard tasks and tasks from a provided url.
///
///Author: K.Binder
class TasksetLoader {
  Map<SubjectGradeRelation, List<Taskset>> loadedTasksets = {};
  Map<SubjectGradeRelation, List<Taskset>> tasksetPool = {};

  void _loadTasksetPool() {
    loadedTasksets.forEach((key, value) {
      value.forEach((element) {
        if (element.isInPool) {
          if (tasksetPool[key] == null) tasksetPool[key] = [];
          tasksetPool[key]!.add(element);
        }
      });
    });
  }

  //Change this constant if you want to support more grades than 1-6.
  //Keep in mind youll have to add standard taskset for each subject for the new grade otherwise the app will crash on startup.
  static const int GRADES_SUPPORTED = 6;

  ///Loads all Tasksets.
  ///
  ///This includes all standard tasksets if they are not disabled in the admin menu.
  Future<void> loadAllTasksets(ServerRepository serverRepository) async {
    /* ONLY NEEDED WHEN A LOCAL COPY SHOUL EXIST AND POSSIBLY PERSIST
    //get path for the taskset directory (only accessible by this app)
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String tasksetPath = appDocDir.path + "/tasksets";
    //create the directory if it doesent exist yet
    await Directory(tasksetPath).create();
    //get a reference to the taskset directory
    Directory dir = Directory(tasksetPath);
    //deleting all tasksets from the directory in case it already existet
    await dir.list().forEach((element) {
      element.delete();
    });
    */

    //load all standard-tasksets for each subject and grade
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? enableDefaultTasksetPref =
        prefs.getBool(AdminUtils.enableDefaultTasksetsPref);
    if (enableDefaultTasksetPref == null || enableDefaultTasksetPref) {
      //load all standardtasks

      try {
        final result = await InternetAddress.lookup('example.com');
        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
          print('connected');
          for (int i = 1; i <= GRADES_SUPPORTED; i++) {
            //load all standardtasks from url
            List<TaskUrl> standardTaskUrls = [
              TaskUrl(
                  url:
                      "https://raw.githubusercontent.com/thm-mni-ii/lama/master/lama_app/assets/standardTasksets/mathe/mathe$i.json"),
              TaskUrl(
                  url:
                      "https://raw.githubusercontent.com/thm-mni-ii/lama/master/lama_app/assets/standardTasksets/deutsch/deutsch$i.json"),
              TaskUrl(
                  url:
                      "https://raw.githubusercontent.com/thm-mni-ii/lama/master/lama_app/assets/standardTasksets/englisch/englisch$i.json"),
              TaskUrl(
                  url:
                      "https://raw.githubusercontent.com/thm-mni-ii/lama/master/lama_app/assets/standardTasksets/sachkunde/sachkunde$i.json"),
            ];
            await loadTasksFromUrls(standardTaskUrls);
          }
          List<Taskset> tmp = await TasksetRepository()
              .downloadTasksetDirectory(serverRepository);
          for (var element in tmp) {
            if (loadedTasksets[
                    SubjectGradeRelation(element.subject, element.grade)] ==
                null) {
              loadedTasksets[
                  SubjectGradeRelation(element.subject, element.grade)] = [];
            }
            loadedTasksets[
                    SubjectGradeRelation(element.subject, element.grade)]!
                .add(element);
            print(element.taskurl);
            print("test" + element.toJson().toString());
          }

          //_loadTasksetPool();
        }
      } on SocketException catch (_) {
        print('not connected');
        for (int i = 1; i <= GRADES_SUPPORTED; i++) {
          //load all standardtasks from local assets folder. needed in case
          //the app user has no internet connection
          String tasksetMathe = await rootBundle
              .loadString('assets/standardTasksets/mathe/mathe' +
                  i.toString() +
                  '.json')
              .catchError((err) => Future.value(""));
          if (tasksetMathe != "") await buildTasksetFromJson(tasksetMathe);

          String tasksetDeutsch = await rootBundle
              .loadString('assets/standardTasksets/deutsch/deutsch' +
                  i.toString() +
                  '.json')
              .catchError((err) => Future.value(""));
          if (tasksetDeutsch != "") await buildTasksetFromJson(tasksetDeutsch);
          String tasksetEnglisch = await rootBundle
              .loadString('assets/standardTasksets/englisch/englisch' +
                  i.toString() +
                  '.json')
              .catchError((err) => Future.value(""));
          if (tasksetEnglisch != "")
            await buildTasksetFromJson(tasksetEnglisch);
          String tasksetSachkunde = await rootBundle
              .loadString('assets/standardTasksets/sachkunde/sachkunde' +
                  i.toString() +
                  '.json')
              .catchError((err) => Future.value(""));
          if (tasksetSachkunde != "")
            await buildTasksetFromJson(tasksetSachkunde);
        }
        //_loadTasksetPool();
      }

      // for (int i = 1; i <= GRADES_SUPPORTED; i++) {
      //   //load all standardtasks from local assets folder. needed in case
      //   //the app user has no internet connection
      //   String tasksetMathe = await rootBundle
      //       .loadString(
      //           'assets/standardTasksets/mathe/mathe' + i.toString() + '.json')
      //       .catchError((err) => Future.value(""));
      //   if (tasksetMathe != "") await buildTasksetFromJson(tasksetMathe);

      //   String tasksetDeutsch = await rootBundle
      //       .loadString('assets/standardTasksets/deutsch/deutsch' +
      //           i.toString() +
      //           '.json')
      //       .catchError((err) => Future.value(""));
      //   if (tasksetDeutsch != "") await buildTasksetFromJson(tasksetDeutsch);
      //   String tasksetEnglisch = await rootBundle
      //       .loadString('assets/standardTasksets/englisch/englisch' +
      //           i.toString() +
      //           '.json')
      //       .catchError((err) => Future.value(""));
      //   if (tasksetEnglisch != "") await buildTasksetFromJson(tasksetEnglisch);
      //   String tasksetSachkunde = await rootBundle
      //       .loadString('assets/standardTasksets/sachkunde/sachkunde' +
      //           i.toString() +
      //           '.json')
      //       .catchError((err) => Future.value(""));
      //   if (tasksetSachkunde != "")
      //     await buildTasksetFromJson(tasksetSachkunde);
      //load all standardtasks from url
      // List<TaskUrl> standardTaskUrls = [
      //   TaskUrl(
      //       url:
      //           "https://raw.githubusercontent.com/thm-mni-ii/lama/master/lama_app/assets/standardTasksets/mathe/mathe$i.json"),
      //   TaskUrl(
      //       url:
      //           "https://raw.githubusercontent.com/thm-mni-ii/lama/master/lama_app/assets/standardTasksets/deutsch/deutsch$i.json"),
      //   TaskUrl(
      //       url:
      //           "https://raw.githubusercontent.com/thm-mni-ii/lama/master/lama_app/assets/standardTasksets/englisch/englisch$i.json"),
      //   TaskUrl(
      //       url:
      //           "https://raw.githubusercontent.com/thm-mni-ii/lama/master/lama_app/assets/standardTasksets/sachkunde/sachkunde$i.json"),
      // ];
      // await loadTasksFromUrls(standardTaskUrls);
      //}
    }

    //load all tasksets from url
    List<TaskUrl> taskUrls = await DatabaseProvider.db.getTaskUrl();
    await loadTasksFromUrls(taskUrls);

    /* ONLY NEEDED WHEN A LOCAL COPY SHOUL EXIST AND POSSIBLY PERSIST
    //get all files in the taskset directory
    List<FileSystemEntity> tasksets = dir.listSync();
    //for (File f in tasksets) print(f.path);

    for (File file in tasksets) {
      String tasksetContent = await file.readAsString();
      buildTasksetFromJson(tasksetContent);
    }*/

    //Remove all leftToSolveEntries for deleted Tasksets
    print("Removed: " +
        (await DatabaseProvider.db.removeAllNonExistent()).toString() +
        "Entries");
    print("Reset: " +
        (await DatabaseProvider.db.resetAllStillExistFlags()).toString() +
        "Entries");
    _loadTasksetPool();
  }

  ///Builds a Taskset from a json string and puts it into [loadedTasksets()].
  ///
  ///Also checks if the Taskset is valid via the [TasksetValidator] and skips it if its not.
  Future<void> buildTasksetFromJson(tasksetContent) async {
    String? isTasksetValid =
        TasksetValidator.isValidTaskset(jsonDecode(tasksetContent));
    print('Is Taskset valid: $isTasksetValid');
    if (isTasksetValid == null) {
      Taskset taskset = Taskset.fromJson(jsonDecode(tasksetContent));

      /* DEBUG LOGCODE
    print("taskset_name: " + taskset.name);
    print("taskset_subject: " + taskset.subject);
    print("taskset_grade: " + taskset.grade.toString());
    for (Task t in taskset.tasks) {
      print("task_question: " + t.question);
      print("task_type: " + t.type);
      print("task_reward: " + t.reward.toString());
      if (t is Task4Cards) {
        print("task_right_answer: " + t.rightAnswer);
        for (String s in t.wrongAnswers) print("task_wrong_answer: " + s);
      }
    }
    */

      SubjectGradeRelation sgr =
          SubjectGradeRelation(taskset.subject, taskset.grade);
      if (loadedTasksets.containsKey(sgr))
        loadedTasksets[sgr]!.add(taskset);
      else
        loadedTasksets[sgr] = <Taskset>[taskset];
      print("Loaded Taskset: " +
          taskset.name! +
          " for grade " +
          taskset.grade.toString() +
          " for subject " +
          taskset.subject!);
    }
  }

  ///Gets all Tasksets that match a specific subject-grade combination (e.g. math and second grade)
  List<Taskset>? getLoadedTasksetsForSubjectAndGrade(
      String subject, int? grade) {
    SubjectGradeRelation sgr = SubjectGradeRelation(subject, grade);
    if (loadedTasksets.containsKey(sgr)) return loadedTasksets[sgr];
    return [];
  }

  ///Gets all Tasksets that match a specific subject-grade combination (e.g. math and second grade)
  /// returns the List that is used by the children
  List<Taskset>? getTasksetPoolForSubjectAndGrade(String subject, int? grade) {
    SubjectGradeRelation sgr = SubjectGradeRelation(subject, grade);
    if (tasksetPool.containsKey(sgr)) return tasksetPool[sgr];
    return [];
  }

  ///Loads tasks from a list of [TaskUrl]'s and builds them, making them useable
  ///for the user
  Future<void> loadTasksFromUrls(List<TaskUrl> taskUrls) async {
    for (int i = 0; i < taskUrls.length; i++) {
      String? result =
          await InputValidation.inputUrlWithJsonValidation(taskUrls[i].url);

      print("counter: $i");

      var response = await http.get(
        Uri.parse(taskUrls[i].url!),
        headers: {'Content-type': 'application/json'},
      );
      if (result == null) {
        await buildTasksetFromJson(utf8.decode(response.bodyBytes));
      }
    }
  }
}
