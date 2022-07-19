import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lama_app/app/repository/taskset_repository.dart';
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
    TasksetRepository tasksetRepository =
        RepositoryProvider.of<TasksetRepository>(context);

    List<Taskset> list(int index) {
      // aus block
      if (isAll) return tasksetRepository.getTasksetsForGrade(index);
      return tasksetRepository.getTasksetsForGradeWhichAreInUse(index);
    }

    return ListView.builder(
      itemCount: TasksetLoader.GRADES_SUPPORTED,
      itemBuilder: (context, index) => ExpansionTile(
        title: Text('Klasse ${index + 1}'),
        children: [
          for (Taskset taskset in list(index + 1))
            TasksetExpansionTileCardWidget(taskset: taskset),
        ],
        //trailing: ,
      ),
    );
  }
}
