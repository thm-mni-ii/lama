import 'dart:convert';
import 'dart:io';

import 'package:lama_app/app/task-system/subject_grade_relation.dart';
import 'package:lama_app/app/task-system/task.dart';
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
    //****************TESTFILE-CODE*****************************

    File f = File(dir.path + "/testFile.json");
    File f2 = File(dir.path + "/testFile2.json");

    f.writeAsString(
        '{"taskset_name":"Test", "taskset_subject":"Mathe", "taskset_grade":3, "tasks": [{"task_type":"4Cards", "task_reward":2, "question":"4 + 3", "lama_text":"Tippe die richtige Antwort an du Kind du!","right_answer":"This the answer", "wrong_answers":["4", "3", "1"]}]}');
    f2.writeAsString(
        '{"taskset_name":"Test 2", "taskset_subject":"Mathe", "taskset_grade":3, "tasks": [{"task_type":"4Cards", "task_reward":2, "question":"Whats the answer?","lama_text":"Tippe die richtige Antwort an!","right_answer":"This the answer", "wrong_answers":["4", "3", "1"]}]}');
    //******************************************

    //TODO: Add Standard-Tasksets
    //TODO: Download JSON-Tasksets from Server

    //get all files in the taskset directory
    List<FileSystemEntity> tasksets = dir.listSync();
    for (File f in tasksets) print(f.path);

    for (File file in tasksets) {
      String tasksetContent = await file.readAsString();
      Taskset taskset = Taskset.fromJson(jsonDecode(tasksetContent));

      //LOGCODE
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
      //

      SubjectGradeRelation sgr =
          SubjectGradeRelation(taskset.subject, taskset.grade);
      if (loadedTasksets.containsKey(sgr))
        loadedTasksets[sgr].add(taskset);
      else
        loadedTasksets[sgr] = <Taskset>[taskset];
    }
  }

  //Gets all Tasksets that match a specific subject-grade combination (for example Math and Second Grade)
  List<Taskset> getLoadedTasksetsForSubjectAndGrade(String subject, int grade) {
    SubjectGradeRelation sgr = SubjectGradeRelation(subject, grade);
    if (loadedTasksets.containsKey(sgr))
      return loadedTasksets[sgr];
    else
      return <Taskset>[];
  }
}
