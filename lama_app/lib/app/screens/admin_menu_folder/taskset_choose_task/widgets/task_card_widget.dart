import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lama_app/app/bloc/create_taskset_bloc.dart';
import 'package:lama_app/app/repository/taskset_repository.dart';
import 'package:lama_app/app/screens/admin_menu_folder/create_tasks/bloc/create_task_bloc.dart';
import 'package:lama_app/app/screens/admin_menu_folder/create_tasks/create_moneytask/create_moneytask_screen.dart';
import 'package:lama_app/app/task-system/task.dart';
import 'package:lama_app/app/task-system/taskset_model.dart';

class TaskCardWidget extends StatelessWidget {
  final int index;
  const TaskCardWidget({Key? key, required this.index}) : super(key: key);

  Widget screenDependingOnTaskType(BuildContext context, Task task) {
    switch (task.type) {
      case TaskType.moneyTask:
        return MoneyEinstellenScreen();
      default:
        return Placeholder();
    }
  }

  @override
  Widget build(BuildContext context) {
    Taskset taskset = BlocProvider.of<CreateTasksetBloc>(context).taskset!;
    List<TaskType> list = TasksetRepository.giveEnumBySubject(taskset.subject!);
    return Card(
      child: ListTile(
        title: Text(list[index].toString().substring(9).toUpperCase()),
        trailing: SizedBox(
          child: IconButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MultiBlocProvider(
                  providers: [
                    BlocProvider(
                      create: (context) => CreateTaskBloc(null),
                    ),
                    BlocProvider.value(
                      value: BlocProvider.of<CreateTasksetBloc>(context),
                    ),
                  ],
                  child:
                      screenDependingOnTaskType(context, taskset.tasks![index]),
                ),
              ),
            ),
            icon: Icon(Icons.keyboard_arrow_right),
          ),
        ),
      ),
    );
  }
}
