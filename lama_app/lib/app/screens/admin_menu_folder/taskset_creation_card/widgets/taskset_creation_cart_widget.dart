import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lama_app/app/bloc/create_taskset_bloc.dart';
import 'package:lama_app/app/event/create_taskset_event.dart';
import 'package:lama_app/app/task-system/taskset_model.dart';

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
  final int index;
  const TasksetCreationCartWidget({Key? key, required this.index})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Taskset taskset = BlocProvider.of<CreateTasksetBloc>(context).taskset!;
    return Card(
      elevation: 5,
      child: Dismissible(
        key: Key("$index"),
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
          BlocProvider.of<CreateTasksetBloc>(context).add(RemoveTask(index));
        },
        child: ListTile(
          title: Text(
            taskset.tasks![index].type.toString().toUpperCase().substring(9),
          ),
          subtitle: Text(taskset.tasks![index].lamaText),
          trailing: SizedBox(
            width: MediaQuery.of(context).size.width * 0.3,
            child: Row(
              children: [
                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.edit),
                  color: Colors.black,
                ),
                IconButton(
                  onPressed: () => BlocProvider.of<CreateTasksetBloc>(context)
                      .add(RemoveTask(index)),
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
