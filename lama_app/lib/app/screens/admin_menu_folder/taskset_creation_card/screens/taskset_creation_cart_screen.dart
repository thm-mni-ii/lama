import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lama_app/app/event/create_taskset_event.dart';
import 'package:lama_app/app/model/taskUrl_model.dart';
import 'package:lama_app/app/repository/taskset_repository.dart';
import 'package:lama_app/app/screens/admin_menu_folder/bloc/taskset_create_tasklist_bloc.dart';
import 'package:lama_app/app/screens/admin_menu_folder/taskset_choose_task/screens/taskset_choose_task_screen.dart';
import 'package:lama_app/app/screens/admin_menu_folder/taskset_creation_card/widgets/taskset_creation_cart_widget.dart';
import 'package:lama_app/app/screens/admin_menu_folder/taskset_manage/bloc/taskset_manage_bloc.dart';
import 'package:lama_app/app/screens/admin_menu_folder/widgets/custom_appbar.dart';
import 'package:lama_app/app/task-system/subject_grade_relation.dart';
import 'package:lama_app/app/task-system/task.dart';
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
    Size screenSize = MediaQuery.of(context).size;
    Taskset taskset = BlocProvider.of<CreateTasksetBloc>(context).taskset!;
    TasksetCreateTasklistBloc tasksetListBloc =
        BlocProvider.of<TasksetCreateTasklistBloc>(context);
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
                          BlocProvider.value(
                            value: BlocProvider.of<CreateTasksetBloc>(context),
                          ),
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
                    if (taskset.taskurl != null) {
                      // name gleich also bleibt die url gleich ?
                      //ja -> inhalte vergleichen wenn alles gleich nichts machen ansonsten anpassen
                      //nein -> alte url aus db löschen und file vom server (nicht in der reihnfolge)
                      // --> neue file mit neuer url anlegen

                      //m1: neu fetchen an der url oder 2-tes taskset in bloc was dem editierten entspricht wenn null dann wird neues gebaut

                      // is in pool muss verändert werden zu irgend einem Zeitpunkt!!

                    } else {
                      // erstmal neu nachdenken was passieren muss
                      // taskurl muss gesetzt werden
                      /* String createdTaskUrl = "$url/${taskset.subject}/${taskset.name}";
                      DatabaseProvider.db
                          .insertTaskUrl(TaskUrl(url: createdTaskUrl));
                      List<TaskUrl> taskUrl =
                          await DatabaseProvider.db.getTaskUrl();
                      BlocProvider.of<CreateTasksetBloc>(context).add(
                        AddUrlToTaskset(
                          taskUrl.firstWhere(
                            (element) => element.url == createdTaskUrl,
                          ),
                        ),
                      ); */

                      // tasklist muss gesetzt werden
                      BlocProvider.of<CreateTasksetBloc>(context).add(
                        AddTaskListToTaskset(tasksetListBloc.taskList),
                      );
                      // taskset muss auf server gepushed und in lokale liste geschrieben werden
                      print(taskset.toJson());
                      RepositoryProvider.of<TasksetRepository>(context)
                          .writeToServer(taskset);
                      // lokale liste hinzufügen
                      /* RepositoryProvider.of<TasksetRepository>(context)
                          .tasksetLoader
                          .loadedTasksets
                          .addAll({
                        SubjectGradeRelation(taskset.subject, taskset.grade): [
                          taskset
                        ],
                      }); */
                      BlocProvider.of<TasksetManageBloc>(context)
                          .allTaskset
                          .add(taskset);

                      /* Navigator.popUntil(
                      context,
                      ModalRoute.withName(
                        TasksetManageScreen.routeName,
                      ),
                    );*/
                    }
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
