import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lama_app/app/bloc/task_bloc.dart';
import 'package:lama_app/app/event/task_events.dart';
import 'package:lama_app/app/screens/task_type_screens/four_card_task_screen.dart';
import 'package:lama_app/app/state/task_state.dart';

class TaskScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => TaskScreenState();
}

class TaskScreenState extends State<TaskScreen> {
  void initState() {
    super.initState();
    BlocProvider.of<TaskBloc>(context).add(ShowNextTaskEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TaskBloc, TaskState>(
      builder: (context, state) {
        if (state is DisplayTaskState) {
          switch (state.task.type) {
            case "4Cards":
              return FourCardTaskScreen(state.subject, state.task);
              break;
          }
        } else if (state is TaskAnswerResultState) {
          if (state.correct)
            return Container(
              color: Colors.white,
              child: Center(
                child: Icon(
                  Icons.check,
                  size: 100,
                  color: Colors.green,
                ),
              ),
            );
          else
            return Container(
              color: Colors.white,
              child: Center(
                child: Icon(
                  Icons.close,
                  size: 100,
                  color: Colors.red,
                ),
              ),
            );
        } else if (state is AllTasksCompletedState) {
          Future.microtask(() => Navigator.pop(context));
          return Container(
            color: Colors.white,
          );
        } else {
          return Text("No task passed");
        }
      },
    );
  }
}
