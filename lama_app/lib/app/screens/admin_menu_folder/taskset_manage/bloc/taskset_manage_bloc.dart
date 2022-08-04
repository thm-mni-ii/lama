import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lama_app/app/repository/taskset_repository.dart';
import 'package:lama_app/app/screens/admin_menu_folder/taskset_manage/bloc/taskset_manage_event.dart';
import 'package:lama_app/app/screens/admin_menu_folder/taskset_manage/bloc/taskset_manage_state.dart';
import 'package:lama_app/app/screens/admin_menu_folder/taskset_manage/screens/taskset_manage_screen.dart';
import 'package:lama_app/app/task-system/subject_grade_relation.dart';
import 'package:lama_app/app/task-system/taskset_model.dart';

///[Bloc] for the [TasksetManageScreen]
///
/// * see also
///    [TasksetManageScreen]
///    [TasksetManageScreenEvent]
///    [TasksetManageScreenState]
///    [Bloc]
///
/// Author: N. Soethe
/// latest Changes: 28.05.2022
class TasksetManageBloc extends Bloc<TasksetManageEvent, TasksetManageState> {
  List<Taskset> tasksetPool;
  List<Taskset> allTaskset;

  TasksetManageBloc({required this.tasksetPool, required this.allTaskset})
      : super(TasksetManageInitial()) {
    on<AddTasksetPool>((event, emit) {
      addATaskset(event.context, event.taskset);
      emit(ChangeTasksetStatus());
    });
    on<RemoveTasksetPool>((event, emit) async {
      removeATaskset(event.context, event.taskset);
      emit(ChangeTasksetStatus());
    });
    on<AddListOfTasksetsPool>((event, emit) {
      event.tasksetList.forEach((element) {
        if (!element.isInPool && element.taskurl!.id == null) {
          addATaskset(event.context, element);
        }
      });
      emit(ChangeTasksetStatus());
    });
    on<RemoveListOfTasksetsPool>((event, emit) {
      event.tasksetList.forEach((element) {
        if (element.taskurl!.id == null) {
          removeATaskset(event.context, element);
        }
      });
      emit(ChangeTasksetStatus());
    });
    on<DeleteTaskset>((event, emit) async {
      final repo = RepositoryProvider.of<TasksetRepository>(event.context);
      // benutzen
      //DatabaseProvider.db.deleteTaskUrl(event.taskUrl.id);
      //print(allTaskset);
      emit(WaitingTasksetStatus());
      await repo.deleteTasksetFromServer(event.context, event.taskset);
      repo
          .tasksetLoader
          .loadedTasksets[
              SubjectGradeRelation(event.taskset.subject, event.taskset.grade)]!
          .remove(event.taskset);

      allTaskset.remove(event.taskset);
      if (event.taskset.isInPool) {
        tasksetPool.remove(event.taskset);
      }
      //print(allTaskset);
      // vom Server löschen
      //ServerRepository().deleteFile();
      emit(ChangeTasksetStatus());
    });
    on<UploadTaskset>((event, emit) async {
      final repo = RepositoryProvider.of<TasksetRepository>(event.context);
      print("FUCK YOU: " +
          (await repo.fileUpload(event.context, event.taskset)).toString());
      if (repo.tasksetLoader.loadedTasksets[SubjectGradeRelation(
              event.taskset.subject, event.taskset.grade)] ==
          null) {
        repo.tasksetLoader.loadedTasksets[SubjectGradeRelation(
            event.taskset.subject, event.taskset.grade)] = [event.taskset];
      }
      repo
          .tasksetLoader
          .loadedTasksets[
              SubjectGradeRelation(event.taskset.subject, event.taskset.grade)]!
          .add(event.taskset);
      allTaskset.add(event.taskset);
    });
  }

  void updateTaskset(BuildContext context, Taskset taskset) async {
    final repo = RepositoryProvider.of<TasksetRepository>(context);

    await repo.deleteTasksetFromServer(context, taskset);
    await repo.fileUpload(context, taskset);
  }

  void removeATaskset(BuildContext context, Taskset taskset) {
    tasksetPool.remove(taskset);
    taskset.isInPool = false;
    updateTaskset(context, taskset);
  }

  void addATaskset(BuildContext context, Taskset taskset) {
    tasksetPool.add(taskset);
    taskset.isInPool = true;
    updateTaskset(context, taskset);
  }
}
