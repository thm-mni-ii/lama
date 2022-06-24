import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lama_app/app/bloc/create_taskset_bloc.dart';
import 'package:lama_app/app/event/create_taskset_event.dart';
import 'package:lama_app/app/screens/admin_menu_folder/create_tasks/create_moneytask/create_moneytask_screen.dart';
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
  const TasksetCreationCartWidget({
    Key? key,
    required this.task,
  }) : super(key: key);

// auch in anderer datei muss static in utils
  Widget screenDependingOnTaskType(TaskType taskType) {
    switch (taskType) {
      case TaskType.moneyTask:
        return MoneyEinstellenScreen(task: task as TaskMoney);
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
          BlocProvider.of<CreateTasksetBloc>(context).add(RemoveTask(task.id));
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
                      builder: (_) => BlocProvider.value(
                        value: BlocProvider.of<CreateTasksetBloc>(context),
                        child: screenDependingOnTaskType(task.type),
                      ),
                    ),
                  ),
                  icon: Icon(Icons.edit),
                  color: Colors.black,
                ),
                IconButton(
                  onPressed: () => BlocProvider.of<CreateTasksetBloc>(context)
                      .add(RemoveTask(task.id)),
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
