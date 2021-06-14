import 'package:lama_app/app/repository/user_repository.dart';
import 'package:lama_app/app/task-system/taskset_loader.dart';
import 'package:lama_app/app/task-system/taskset_model.dart';

class TasksetRepository {
  TasksetLoader tasksetLoader;

  Future<void> initialize(UserRepository repository) async {
    tasksetLoader = TasksetLoader(repository);
    await tasksetLoader.loadAllTasksets();
  }

  List<Taskset> getTasksetsForSubjectAndGrade(String subject, int grade) {
    return tasksetLoader.getLoadedTasksetsForSubjectAndGrade(subject, grade);
  }

  void reloadTasksetLoader(UserRepository repository) async {
    tasksetLoader = TasksetLoader(repository);
    await tasksetLoader.loadAllTasksets();
  }
}
