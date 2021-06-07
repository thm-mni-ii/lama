import 'package:flutter/cupertino.dart';
import 'package:lama_app/app/task-system/task.dart';

class VocableTestTaskScreen extends StatelessWidget {
  final TaskVocableTest task;
  final BoxConstraints constraints;

  VocableTestTaskScreen(this.task, this.constraints);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Text(task.vocablePairs[0].a + " " + task.vocablePairs[0].b));
  }
}
