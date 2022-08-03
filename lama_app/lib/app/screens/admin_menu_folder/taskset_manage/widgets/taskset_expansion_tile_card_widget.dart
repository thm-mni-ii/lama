import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lama_app/app/bloc/create_taskset_bloc.dart';
import 'package:lama_app/app/bloc/taskset_options_bloc.dart';
import 'package:lama_app/app/event/taskset_options_event.dart';
import 'package:lama_app/app/repository/taskset_repository.dart';
import 'package:lama_app/app/screens/admin_menu_folder/taskset_creation_screen.dart';
import 'package:lama_app/app/screens/admin_menu_folder/taskset_manage/bloc/taskset_manage_bloc.dart';
import 'package:lama_app/app/screens/admin_menu_folder/taskset_manage/bloc/taskset_manage_event.dart';
import 'package:lama_app/app/screens/admin_menu_folder/taskset_manage/bloc/taskset_manage_state.dart';
import 'package:lama_app/app/task-system/taskset_model.dart';
import 'package:lama_app/util/LamaColors.dart';

/// Author: Tim Steinmüller
/// latest Changes: 09.06.2022

class TasksetExpansionTileCardWidget extends StatelessWidget {
  final Taskset taskset;
  const TasksetExpansionTileCardWidget({
    Key? key,
    required this.taskset,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TasksetManageBloc tasksetManageBloc =
        BlocProvider.of<TasksetManageBloc>(context);

    return Card(
      margin: const EdgeInsets.all(8.0),
      color: LamaColors.findSubjectColor(taskset.subject!),
      child: BlocBuilder<TasksetManageBloc, TasksetManageState>(
        bloc: tasksetManageBloc,
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Text(
                  taskset.name!,
                  style: TextStyle(color: Colors.white),
                ),
                Spacer(),
                IconButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BlocProvider(
                        create: (context) =>
                            CreateTasksetBloc(taskset: taskset),
                        child: TasksetCreationScreen(),
                      ),
                    ),
                  ),
                  icon: Icon(Icons.edit),
                  color: Colors.white,
                ),
                IconButton(
                  onPressed: () async {
                    /*                 BlocProvider.of<TasksetOptionsBloc>(context).add(
                                TasksetOptionsDelete(taskset.taskurl!),
                              );
               */
                    try {
                      //print(taskset.name.toString());
                      //print("TASTSET: " + taskset.toJson().toString());
                      // aus listen löschen
                      tasksetManageBloc.add(DeleteTaskset(taskset, context));
                    } catch (error) {
                      //error widget
                      throw error;
                    }
                  },
                  icon: Icon(Icons.delete),
                  color: Colors.white,
                ),
                IconButton(
                  onPressed: () => taskset.taskurl!.id == null
                      ? null
                      : taskset.isInPool
                          ? tasksetManageBloc.add(RemoveTasksetPool(
                              context: context, taskset: taskset))
                          : tasksetManageBloc.add(AddTasksetPool(
                              context: context, taskset: taskset)),
                  icon: taskset.isInPool
                      ? Icon(Icons.remove_circle_outline_rounded)
                      : Icon(Icons.add),
                  color: Colors.white,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
