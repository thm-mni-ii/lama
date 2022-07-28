import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lama_app/app/bloc/create_taskset_bloc.dart';
import 'package:lama_app/app/screens/admin_menu_folder/bloc/taskset_create_tasklist_bloc.dart';
import 'package:lama_app/app/screens/admin_menu_folder/create_tasks/create_clock_task/create_clock_task.dart';
import 'package:lama_app/app/screens/admin_menu_folder/create_tasks/create_moneytask/create_moneytask_screen.dart';
import 'package:lama_app/app/screens/admin_menu_folder/create_tasks/create_task_number_line/create_task_number_line.dart';
import 'package:lama_app/app/screens/admin_menu_folder/create_tasks/four_cards/create_four_cards_screen.dart';
import 'package:lama_app/app/task-system/task.dart';

class TaskCardWidget extends StatelessWidget {
  final TaskType taskType;
  const TaskCardWidget({Key? key, required this.taskType}) : super(key: key);

  Widget screenDependingOnTaskType(TaskType taskType) {
    switch (taskType) {
      case TaskType.moneyTask:
        return MoneyEinstellenScreen(index: 0, task: null);
      case TaskType.fourCards:
        return CreateFourCardsScreen();
      case TaskType.numberLine:
        return CreateTaskNumberLine(index: 0,task: null);
      case TaskType.clock:
        return CreateClockTask(index: 0, task: null);
      default:
        return Placeholder();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(taskType.toString().substring(9).toUpperCase()),
        trailing: IconButton(
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => MultiBlocProvider(
                providers: [
                  BlocProvider.value(
                    value: BlocProvider.of<CreateTasksetBloc>(context),
                  ),
                  BlocProvider.value(
                    value: BlocProvider.of<TasksetCreateTasklistBloc>(context),
                  ),
                ],
                child: screenDependingOnTaskType(taskType),
              ),
            ),
          ),
          icon: const Icon(Icons.keyboard_arrow_right),
        ),
      ),
    );
  }
}