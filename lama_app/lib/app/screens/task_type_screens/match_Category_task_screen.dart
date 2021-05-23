import 'package:flutter/cupertino.dart';
import 'package:lama_app/app/task-system/task.dart';

class MatchCategoryTaskScreen extends StatelessWidget{
  final TaskMatchCategory task;
  final List<String> categorySum = [];
  final BoxConstraints constraints;

  MatchCategoryTaskScreen(this.task, this.constraints){
    categorySum.addAll(task.categoryOne);
    categorySum.addAll(task.categoryTwo);
    categorySum.shuffle();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
  
}