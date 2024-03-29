import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lama_app/app/bloc/create_taskset_bloc.dart';
import 'package:lama_app/app/event/create_taskset_event.dart';
import 'package:lama_app/app/model/taskUrl_model.dart';
import 'package:lama_app/app/repository/server_repository.dart';
import 'package:lama_app/app/screens/admin_menu_folder/bloc/taskset_create_tasklist_bloc.dart';
import 'package:lama_app/app/screens/admin_menu_folder/taskset_choose_task/screens/taskset_choose_task_screen.dart';
import 'package:lama_app/app/screens/admin_menu_folder/taskset_creation_card/widgets/taskset_creation_cart_widget.dart';
import 'package:lama_app/app/screens/admin_menu_folder/taskset_manage/bloc/taskset_manage_bloc.dart';
import 'package:lama_app/app/screens/admin_menu_folder/taskset_manage/bloc/taskset_manage_event.dart';
import 'package:lama_app/app/screens/admin_menu_folder/widgets/custom_appbar.dart';
import 'package:lama_app/app/task-system/taskset_model.dart';
import 'package:lama_app/util/LamaColors.dart';
import 'package:lama_app/util/input_validation.dart';
import 'package:lama_app/app/bloc/taskset_options_bloc.dart';

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
  final bool isEdit;
  final Taskset? editedTaskset;
  const TasksetCreationCartScreen(
      {required this.isEdit, required this.editedTaskset})
      : super();

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
                    if (tasksetListBloc.taskList.isNotEmpty) {
                      if (serverRepo.serverSettings != null &&
                          serverRepo.serverSettings!.url.isNotEmpty) {
                        String createdTaskUrl =
                            "${serverRepo.serverSettings?.url}upload/${taskset.grade}/${taskset.name}";
                        if (isEdit) {
                          tasksetManageBloc
                              .add(DeleteTaskset(editedTaskset!, context));
                        }
                        createTasksetBloc.add(
                          AddUrlToTaskset(TaskUrl(url: createdTaskUrl)),
                        );
                        // tasklist muss gesetzt werden
                        createTasksetBloc.add(
                          AddTaskListToTaskset(tasksetListBloc.taskList),
                        );
                        //print("create TaskUrl obj: " + h.toString());
                        //print(taskset.toJson());
                        //print("TaskUrl in bloc: " + taskset.taskurl!.url.toString());
                        tasksetManageBloc.add(UploadTaskset(taskset, context));

                        Navigator.pop(context);
                        Navigator.pop(context);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: LamaColors.redAccent,
                            content: const Text(
                              'Serversettings nicht gesetzt',
                              textAlign: TextAlign.center,
                            ),
                            duration: Duration(seconds: 1),
                          ),
                        );
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: LamaColors.redAccent,
                          content: const Text(
                            'Füge deinem Taskset ein Task hinzu',
                            textAlign: TextAlign.center,
                          ),
                          duration: Duration(seconds: 1),
                        ),
                      );
                    }
                  },
                  child:
                      Text(isEdit ? "Taskset editieren" : "Taskset generieren"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
