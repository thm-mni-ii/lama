import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lama_app/app/bloc/task_bloc.dart';
import 'package:lama_app/app/event/task_events.dart';
import 'package:lama_app/app/screens/task_type_screens/four_card_task_screen.dart';
import 'package:lama_app/app/state/task_state.dart';
import 'package:lama_app/app/task-system/task.dart';
import 'package:lama_app/util/LamaColors.dart';

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
    LinearGradient lg;
    return BlocBuilder<TaskBloc, TaskState>(
      builder: (context, state) {
        if (state is DisplayTaskState) {
          switch (state.subject) {
            case "Mathe":
              lg = LinearGradient(
                  colors: [LamaColors.blueAccent, LamaColors.bluePrimary]);
              break;
            case "Englisch":
              lg = LinearGradient(
                  colors: [LamaColors.orangeAccent, LamaColors.orangePrimary]);
              break;
            case "Deutsch":
              lg = LinearGradient(
                  colors: [LamaColors.redAccent, LamaColors.redPrimary]);
              break;
          }
          return Scaffold(
            body: Container(
              decoration: BoxDecoration(gradient: lg),
              child: SafeArea(
                child: Container(
                  color: Colors.white,
                  child: LayoutBuilder(
                    builder:
                        (BuildContext context, BoxConstraints constraints) {
                      return Column(children: [
                        Container(
                          height: (constraints.maxHeight / 100) * 7.5,
                          decoration: BoxDecoration(
                            gradient: lg,
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(25),
                              bottomRight: Radius.circular(25),
                            ),
                          ),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: IconButton(
                                  padding: EdgeInsets.all(0),
                                  icon: Icon(
                                    Icons.arrow_back,
                                    size: 40,
                                    color: Colors.white,
                                  ),
                                  onPressed: () => Navigator.of(context).pop(),
                                ),
                              ),
                              Text(state.subject,
                                  style: TextStyle(
                                      fontSize: 30, color: Colors.white)),
                            ],
                          ),
                        ),
                        Container(
                            height: (constraints.maxHeight / 100) * 92.5,
                            child: LayoutBuilder(builder: (BuildContext context,
                                BoxConstraints constraints) {
                              return getScreenForTaskWithConstraints(
                                  state.task, constraints);
                            }))
                      ]);
                    },
                  ),
                ),
              ),
            ),
          );
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
        }
        return Text("No task passed");
      },
    );
  }

  //Task is the loaded Task and the constraints constrain the space
  // which the taskscreen can use to display its stuff
  Widget getScreenForTaskWithConstraints(
      Task task, BoxConstraints constraints) {
    switch (task.type) {
      case "4Cards":
        return FourCardTaskScreen(task, constraints);
      default:
        return Container();
    }
  }
}
