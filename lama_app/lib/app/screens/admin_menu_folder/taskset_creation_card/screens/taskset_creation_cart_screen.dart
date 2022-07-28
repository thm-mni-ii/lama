import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lama_app/app/event/create_taskset_event.dart';
import 'package:lama_app/app/model/taskUrl_model.dart';
import 'package:lama_app/app/repository/server_repository.dart';
import 'package:lama_app/app/repository/taskset_repository.dart';
import 'package:lama_app/app/screens/admin_menu_folder/bloc/taskset_create_tasklist_bloc.dart';
import 'package:lama_app/app/screens/admin_menu_folder/taskset_choose_task/screens/taskset_choose_task_screen.dart';
import 'package:lama_app/app/screens/admin_menu_folder/taskset_creation_card/widgets/taskset_creation_cart_widget.dart';
import 'package:lama_app/app/screens/admin_menu_folder/taskset_manage/bloc/taskset_manage_bloc.dart';
import 'package:lama_app/app/screens/admin_menu_folder/widgets/custom_appbar.dart';
import 'package:lama_app/app/task-system/subject_grade_relation.dart';
import 'package:lama_app/app/task-system/taskset_model.dart';
import 'package:lama_app/db/database_provider.dart';
import 'package:lama_app/util/LamaColors.dart';
import 'package:lama_app/util/input_validation.dart';
import 'package:lama_app/app/bloc/taskset_options_bloc.dart';

import '../../../../bloc/create_taskset_bloc.dart';

///This file creates the Taskset Creation Cart Screen
///This Screen provides an option to add a task to the current taskset
///or to generate a JSON from it.
///
///
///{@important} the url given via input should be validated with the
///[InputValidation] to prevent any Issue with Exceptions. However
///in this screen the [InputValidation] is only used to prevent simple issues.
///The connection erros are handelt through the [TasksetOptionsBloc]
///
/// * see also
///    [TasksetCreationCartBloc]
///    [TasksetCreationCartEvent]
///    [TasksetCreationState]
///
/// Author: Handito Bismo, Nico Soethe, Tim Steinmüller
/// latest Changes: 09.06.2022
class TasksetCreationCartScreen extends StatelessWidget {
  const TasksetCreationCartScreen() : super();

  @override
  Widget build(BuildContext context) {
    ServerRepository serverRepo =
        RepositoryProvider.of<ServerRepository>(context);
    Size screenSize = MediaQuery.of(context).size;
    final createTasksetBloc = BlocProvider.of<CreateTasksetBloc>(context);
    Taskset taskset = createTasksetBloc.taskset!;
    TasksetCreateTasklistBloc tasksetListBloc =
        BlocProvider.of<TasksetCreateTasklistBloc>(context);
    TasksetManageBloc tasksetManageBloc =
        BlocProvider.of<TasksetManageBloc>(context);
    TasksetRepository tasksetRepository =
        RepositoryProvider.of<TasksetRepository>(context);
    return Scaffold(
      appBar: CustomAppbar(
        titel: taskset.name!,
        size: screenSize.width / 5,
        color: LamaColors.findSubjectColor(taskset.subject!),
      ),
      body: Column(
        children: [
          BlocBuilder<TasksetCreateTasklistBloc, TasksetCreateTasklistState>(
            bloc: tasksetListBloc,
            builder: (context, state) => Expanded(
              child: Container(
                margin: EdgeInsets.all(5),
                child: ListView.builder(
                  // möglicher weise nur das im builder ??
                  itemBuilder: (context, index) => TasksetCreationCartWidget(
                    index: index,
                    task: tasksetListBloc.taskList[index],
                  ),
                  itemCount: tasksetListBloc.taskList.length,
                ),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(bottom: 25),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => MultiBlocProvider(
                        providers: [
                          BlocProvider.value(value: createTasksetBloc),
                          BlocProvider.value(value: tasksetListBloc),
                        ],
                        child: TasksetChooseTaskScreen(),
                      ),
                    ),
                  ),
                  child: const Text("Task hinzufügen"),
                ),
                ElevatedButton(
                  onPressed: () async {
                    // editieren und neu hinzufügen
                    String createdTaskUrl =
                        "${serverRepo.serverSettings!.url ?? ""}/${taskset.subject}/${taskset.name}";
                    if (taskset.taskurl != null) {
                      // name gleich also bleibt die url gleich ?
                      //ja -> inhalte vergleichen wenn alles gleich nichts machen ansonsten anpassen
                      //nein -> alte url aus db löschen und file vom server (nicht in der reihnfolge)
                      // --> neue file mit neuer url anlegen

                      //m1: neu fetchen an der url oder 2-tes taskset in bloc was dem editierten entspricht wenn null dann wird neues gebaut

                      // is in pool muss verändert werden zu irgend einem Zeitpunkt!!

                      // überall löschen

                      DatabaseProvider.db.deleteTaskUrl(taskset.taskurl!.id);
                      tasksetRepository.deleteTasksetFromServer(createdTaskUrl);
                      Taskset t = tasksetManageBloc.allTaskset.firstWhere(
                        (element) => element.taskurl == taskset.taskurl,
                      );

                      tasksetRepository.tasksetLoader.loadedTasksets
                          .forEach((key, value) {
                        if (key == SubjectGradeRelation(t.subject, t.grade)) {
                          value.removeWhere(
                            (element) => element.taskurl == t.taskurl,
                          );
                        }
                      });

                      tasksetManageBloc.allTaskset.removeWhere(
                        (element) => element.taskurl == taskset.taskurl,
                      );
                      if (taskset.isInPool) {
                        tasksetManageBloc.tasksetPool.removeWhere(
                          (element) => element.taskurl == taskset.taskurl,
                        );
                      }
                    }
                    // taskurl muss gesetzt werden darf nicht null sein!!
                    DatabaseProvider.db // oder über tasket id lösen
                        .insertTaskUrl(TaskUrl(url: createdTaskUrl));
                    List<TaskUrl> taskUrl =
                        await DatabaseProvider.db.getTaskUrl();
                    createTasksetBloc.add(
                      AddUrlToTaskset(
                        taskUrl.firstWhere(
                          (element) => element.url == createdTaskUrl,
                        ),
                      ),
                    );

                    // tasklist muss gesetzt werden
                    createTasksetBloc.add(
                      AddTaskListToTaskset(tasksetListBloc.taskList),
                    );
                    // taskset muss auf server gepushed und in lokale liste geschrieben werden
                    print(taskset.toJson());
                    //tasksetRepository.fileUpload(taskset, createdTaskUrl);// locales file
                    // lokale liste hinzufügen
                    tasksetRepository.tasksetLoader.loadedTasksets.addAll({
                      SubjectGradeRelation(taskset.subject, taskset.grade): [
                        taskset
                      ],
                    });
                    tasksetManageBloc.allTaskset.add(taskset);

                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                  child: const Text("Taskset generieren"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
