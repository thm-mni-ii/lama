import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lama_app/app/bloc/create_taskset_bloc.dart';
import 'package:lama_app/app/bloc/taskset_options_bloc.dart';
import 'package:lama_app/app/event/create_taskset_event.dart';
import 'package:lama_app/app/event/taskset_options_event.dart';
import 'package:lama_app/app/screens/admin_menu_folder/taskset_creation_screen.dart';
import 'package:lama_app/app/state/taskset_options_state.dart';
import 'package:lama_app/app/task-system/taskset_model.dart';
import 'package:lama_app/util/LamaColors.dart';

class TasksetExpansionTileCardWidget extends StatelessWidget {
  final Taskset taskset;
  const TasksetExpansionTileCardWidget({
    Key key,
    @required this.taskset,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TasksetOptionsBloc, TasksetOptionsState>(
      builder: (context, state) {
        if (state is TasksetOptionsWaiting) {
          return Column(
            children: [
              CircularProgressIndicator(),
              Text(state.waitingText),
            ],
          );
        } else {
          return BlocProvider(
            create: (context) => CreateTasksetBloc(),
            child: Card(
              margin: const EdgeInsets.all(8.0),
              color: LamaColors.findSubjectColor(taskset),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Text(
                      taskset.name,
                      style: TextStyle(color: Colors.white),
                    ),
                    Spacer(),
                    IconButton(
                      onPressed: () {
                        BlocProvider.of<CreateTasksetBloc>(context)
                            .add(EditTaskset(taskset));
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TasksetCreationScreen(),
                          ),
                        );
                      },
                      icon: Icon(Icons.edit),
                      color: Colors.white,
                    ),
                    IconButton(
                      onPressed: () =>
                          BlocProvider.of<TasksetOptionsBloc>(context).add(
                        TasksetOptionsDelete(taskset.taskurl),
                      ),
                      icon: Icon(Icons.delete),
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
            ),
          );
        }
      },
    );
  }
}
