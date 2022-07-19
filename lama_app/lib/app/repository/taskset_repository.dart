import 'package:lama_app/app/task-system/task.dart';
import 'package:lama_app/app/task-system/taskset_loader.dart';
import 'package:lama_app/app/task-system/taskset_model.dart';

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

  ///Reloads the [TasksetLoader] and loads all tasksets.
  ///
  ///Under the hood this method is identical to [initialize()] except it doesnt return a Future.
  ///This is because it is used to reload the tasks during runtime, while [initialize()] is called during initialization.
  ///Therefore this method exists to provide a more intuitively named method.
  void reloadTasksetLoader() async {
    tasksetLoader = TasksetLoader();
    await tasksetLoader.loadAllTasksets();
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
