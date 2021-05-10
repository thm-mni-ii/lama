import 'package:lama_app/app/task-system/taskset_loader.dart';
import 'package:lama_app/app/task-system/taskset_model.dart';

class TasksetRepository {
  TasksetLoader tasksetLoader;

  void initialize() {
    tasksetLoader = TasksetLoader();
    tasksetLoader.loadAllTasksets();
  }

  List<Taskset> getTasksetsForSubjectAndGrade(String subject, int grade) {
    return tasksetLoader.getLoadedTasksetsForSubjectAndGrade(subject, grade);
  }
}
