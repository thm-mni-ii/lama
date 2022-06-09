import 'package:flutter/material.dart';
import 'package:lama_app/app/task-system/taskset_model.dart';
import 'package:lama_app/util/LamaColors.dart';

class TasksetExpansionTileCardWidget extends StatelessWidget {
  final Taskset taskset;
  const TasksetExpansionTileCardWidget({
    Key key,
    @required this.taskset,
  }) : super(key: key);

  void deleteTaskset() {
    // delete in localer db
    // remove from list
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      color: LamaColors.findSubjectColor(taskset),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Text(
              taskset.name,
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            Spacer(),
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.share),
              color: Colors.white,
            ),
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.edit),
              color: Colors.white,
            ),
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.delete),
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}
