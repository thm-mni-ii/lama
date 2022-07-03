import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lama_app/app/bloc/create_taskset_bloc.dart';
import 'package:lama_app/app/event/create_taskset_event.dart';
import 'package:lama_app/app/screens/admin_menu_folder/bloc/taskset_create_tasklist_bloc.dart';
import 'package:lama_app/app/screens/admin_menu_folder/create_tasks/create_clock_task/create_clock_task.dart';
import 'package:lama_app/app/screens/admin_menu_folder/create_tasks/create_moneytask/create_moneytask_screen.dart';
import 'package:lama_app/app/screens/admin_menu_folder/create_tasks/create_task_number_line/create_task_number_line.dart';
import 'package:lama_app/app/screens/admin_menu_folder/create_tasks/four_cards/create_four_cards_screen.dart';
import 'package:lama_app/app/task-system/task.dart';

///This file creates the Taskset Creation Cart Widget
///This Widget provides a Card for a Task
///
///
///
/// * see also
///    [TasksetCreationCartBloc]
///    [TasksetCreationCartEvent]
///    [TasksetCreationState]
///
/// Author: Tim Steinmüller
/// latest Changes: 09.06.2022
class TasksetCreationCartWidget extends StatelessWidget {
  final Task task;
  final int index;
  const TasksetCreationCartWidget({
    Key? key,
    required this.task,
    required this.index,
  }) : super(key: key);

  Widget screenDependingOnTaskType(TaskType taskType) {
    switch (taskType) {
      case TaskType.moneyTask:
        return MoneyEinstellenScreen(index: index, task: task as TaskMoney);
      case TaskType.fourCards:
        return CreateFourCardsScreen();
      case TaskType.numberLine:
        return CreateTaskNumberLine(index: index, task: task as TaskNumberLine);
      case TaskType.clock:
        return CreateClockTask(index: index, task: task as ClockTest);
      default:
        return Placeholder();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: Dismissible(
        key: Key(task.id),
        background: Container(
          color: Colors.red,
          alignment: Alignment.centerRight,
          child: Padding(
            padding: const EdgeInsets.only(right: 20),
            child: Icon(Icons.delete, color: Colors.white),
          ),
        ),
        direction: DismissDirection.endToStart,
        onDismissed: (DismissDirection dismissDirection) {
          BlocProvider.of<TasksetCreateTasklistBloc>(context)
              .add(RemoveFromTaskList(task.id));
        },
        child: ListTile(
          title: Text(
            task.type.toString().toUpperCase().substring(9),
          ),
          subtitle: Text(task.lamaText),
          trailing: SizedBox(
            width: MediaQuery.of(context).size.width * 0.3,
            child: Row(
              children: [
                IconButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => MultiBlocProvider(
                        providers: [
                          BlocProvider.value(
                            value: BlocProvider.of<CreateTasksetBloc>(context),
                          ),
                          BlocProvider.value(
                            value: BlocProvider.of<TasksetCreateTasklistBloc>(
                                context),
                          ),
                        ],
                        child: screenDependingOnTaskType(task.type),
                      ),
                    ),
                  ),
                  icon: Icon(Icons.edit),
                  color: Colors.black,
                ),
                IconButton(
                  onPressed: () =>
                      BlocProvider.of<TasksetCreateTasklistBloc>(context)
                          .add(RemoveFromTaskList(task.id)),
                  icon: Icon(Icons.delete),
                  color: Colors.black,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
