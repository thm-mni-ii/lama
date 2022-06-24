import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lama_app/app/bloc/create_taskset_bloc.dart';
import 'package:lama_app/app/repository/taskset_repository.dart';
import 'package:lama_app/app/screens/admin_menu_folder/taskset_choose_task/widgets/task_card_widget.dart';
import 'package:lama_app/app/screens/admin_menu_folder/widgets/custom_appbar.dart';
import 'package:lama_app/app/task-system/task.dart';
import 'package:lama_app/app/task-system/taskset_model.dart';
import 'package:lama_app/util/LamaColors.dart';

class TasksetChooseTaskScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    Taskset taskset = BlocProvider.of<CreateTasksetBloc>(context).taskset!;
    List<TaskType> list = TasksetRepository.giveEnumBySubject(taskset.subject!);
    return Scaffold(
      appBar: CustomAppbar(
        size: screenSize.width / 5,
        titel: taskset.name!,
        color: LamaColors.findSubjectColor(taskset.subject!),
      ),
      body: ListView.builder(
        itemBuilder: (context, index) => TaskCardWidget(taskType: list[index]),
        itemCount: list.length,
      ),
    );
  }
}