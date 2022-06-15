import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lama_app/app/bloc/create_taskset_bloc.dart';
import 'package:lama_app/app/task-system/taskset_model.dart';

class TasksetCreationCartWidget extends StatelessWidget {
  final int index;
  const TasksetCreationCartWidget({Key key, @required this.index})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Taskset taskset = BlocProvider.of<CreateTasksetBloc>(context).taskset;
    return Card(
      child: Text(taskset.tasks[index].lamaText),
    );
  }
}
