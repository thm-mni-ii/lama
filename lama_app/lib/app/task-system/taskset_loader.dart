import 'dart:convert';
import 'dart:io';

import 'package:lama_app/app/task-system/subject_grade_relation.dart';
import 'package:lama_app/app/task-system/taskset_model.dart';
import 'package:path_provider/path_provider.dart';

class TasksetLoader {
  Map<SubjectGradeRelation, List<Taskset>> loadedTasksets = {};

  void loadAllTasksets() async {
    //get path for the taskset directory (only accessible by this app)
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String tasksetPath = appDocDir.path + "/tasksets";
    //create the directory if it doesent exist yet
    Directory(tasksetPath).create();
    //get a reference to the taskset directory
    Directory dir = Directory(tasksetPath);
    //deleting all tasksets from the directory in case it already existet
    dir.listSync().forEach((element) {
      element.delete();
    });
    //get all files in the taskset directory
    List<FileSystemEntity> tasksets = dir.listSync();

    for (File file in tasksets) {
      String tasksetContent = await file.readAsString();
      Taskset taskset = Taskset.fromJson(jsonDecode(tasksetContent));
      SubjectGradeRelation sgr =
          SubjectGradeRelation(taskset.subject, taskset.grade);
      if (loadedTasksets.containsKey(sgr))
        loadedTasksets[sgr].add(taskset);
      else
        loadedTasksets[sgr] = <Taskset>[taskset];
    }
  }

  List<Taskset> getLoadedTasksetsForSubjectAndGrade(String subject, int grade) {
    SubjectGradeRelation sgr = SubjectGradeRelation(subject, grade);
    if (loadedTasksets.containsKey(sgr))
      return loadedTasksets[sgr];
    else
      return <Taskset>[];
  }
}
