import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lama_app/app/bloc/create_taskset_bloc.dart';
import 'package:lama_app/app/screens/admin_menu_folder/taskset_manage/widgets/taskset_expansion_tile_card_widget.dart';
import 'package:lama_app/app/task-system/taskset_model.dart';

/// Author: T. Steinmüller
/// latest Changes: 08.06.2022
class TasksetExpansionTileWidget extends StatelessWidget {
  final String classString;
  final List<Taskset> listOfTasksets;
  const TasksetExpansionTileWidget({
    Key key,
    @required this.classString,
    @required this.listOfTasksets,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(classString),
      children: [
        for (Taskset taskset in listOfTasksets)
          TasksetExpansionTileCardWidget(taskset: taskset),
      ],
    );
  }
}
