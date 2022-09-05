import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lama_app/app/screens/admin_menu_folder/taskset_manage/bloc/taskset_manage_bloc.dart';
import 'package:lama_app/app/screens/admin_menu_folder/taskset_manage/bloc/taskset_manage_event.dart';
import 'package:lama_app/app/screens/admin_menu_folder/taskset_manage/bloc/taskset_manage_state.dart';
import 'package:lama_app/app/screens/admin_menu_folder/taskset_manage/widgets/taskset_expansion_tile_card_widget.dart';
import 'package:lama_app/app/task-system/taskset_loader.dart';
import 'package:lama_app/app/task-system/taskset_model.dart';

/// Author: T. Steinmüller
/// latest Changes: 08.06.2022
class TasksetExpansionTileWidget extends StatelessWidget {
  final bool isAll;
  const TasksetExpansionTileWidget({Key? key, required this.isAll})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // wenn alle geaddet werden sollen button und wenn alle geaddet sind remove button
    final tasksetBloc = BlocProvider.of<TasksetManageBloc>(context);

    bool areTasksetsOfGradeInPool(int grade) {
      return tasksetBloc.allTaskset
          .where((element) => element.grade == grade)
          .every((element) => tasksetBloc.tasksetPool
              .where((e) => e.grade == grade)
              .contains(element));
    }

    List<Taskset> list(int grade) {
      List<Taskset> tasksetList = [];
      if (isAll) {
        tasksetBloc.allTaskset.forEach((element) {
          if (element.grade == grade) tasksetList.add(element);
        });
      } else {
        tasksetBloc.tasksetPool.forEach((element) {
          if (element.grade == grade) tasksetList.add(element);
        });
      }
      return tasksetList;
    }

    return ListView.builder(
      itemCount: TasksetLoader.GRADES_SUPPORTED,
      itemBuilder: (context, index) =>
          BlocBuilder<TasksetManageBloc, TasksetManageState>(
        bloc: BlocProvider.of<TasksetManageBloc>(context),
        builder: (context, state) {
          return ExpansionTile(
            title: Text('Klasse ${index + 1}'),
            children: [
              for (Taskset taskset in list(index + 1))
                TasksetExpansionTileCardWidget(taskset: taskset),
            ],
            trailing: isAll
                ? IconButton(// update server files
                    onPressed: () => areTasksetsOfGradeInPool(index + 1)
                        ? tasksetBloc
                            .add(RemoveListOfTasksetsPool(context, list(index + 1)))
                        : tasksetBloc
                            .add(AddListOfTasksetsPool(context, list(index + 1))),
                    icon: areTasksetsOfGradeInPool(index + 1)
                        ? Icon(Icons.remove_circle_outline)
                        : Icon(Icons.add),
                  )
                : null,
          );
        },
      ),
    );
  }
}
