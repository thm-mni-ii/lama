import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lama_app/app/bloc/choose_taskset_bloc.dart';
import 'package:lama_app/app/bloc/task_bloc.dart';
import 'package:lama_app/app/bloc/taskbloc/tts_bloc.dart';
import 'package:lama_app/app/event/choose_taskset_events.dart';
import 'package:lama_app/app/repository/user_repository.dart';
import 'package:lama_app/app/screens/task_screen.dart';
import 'package:lama_app/app/state/choose_taskset_state.dart';
import 'package:lama_app/app/task-system/task.dart';
import 'package:lama_app/app/task-system/taskset_model.dart';
import 'package:lama_app/util/LamaColors.dart';
import 'package:lama_app/util/LamaTextTheme.dart';

/// [StatefulWidget] that contains the screen that shows all Tasksets.
///
/// Author: K.Binder
class ChooseTasksetScreen extends StatefulWidget {
  final String chosenSubject;
  final int? userGrade;
  final UserRepository? userRepository;

  ChooseTasksetScreen(this.chosenSubject, this.userGrade, this.userRepository);

  @override
  State<StatefulWidget> createState() {
    return ChooseTasksetScreenState(chosenSubject, userGrade, userRepository);
  }
}

/// [State] that contains the UI side logic for the [ChooseTasksetScreen]
///
/// Author: K.Binder
class ChooseTasksetScreenState extends State<ChooseTasksetScreen> {
  String chosenSubject;
  int? userGrade;
  UserRepository? userRepository;

  ChooseTasksetScreenState(
      this.chosenSubject, this.userGrade, this.userRepository);

  ///Loads all Tasksets for [chosenSubject] with [userGrade] during initialization.
  ///
  ///This is the reason why [ChooseTasksetScreen] is a [StatefulWidget],
  ///because the fetch needs to happen before building the screen and without user interaction.
  @override
  void initState() {
    super.initState();
    BlocProvider.of<ChooseTasksetBloc>(context)
        .add(LoadAllTasksetsEvent(chosenSubject, userGrade));
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: LamaColors.mainPink,
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              color: Colors.white,
              child: Container(
                margin: EdgeInsets.only(top: (screenSize.height / 100) * 7.5),
                child: Center(
                  child: BlocBuilder<ChooseTasksetBloc, ChooseTasksetState>(
                    builder: (context, state) {
                      if (state is LoadingAllTasksetsState)
                        return CircularProgressIndicator();
                      else
                        return _buildTasksetList(context, state);
                    },
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                width: screenSize.width,
                height: (screenSize.height / 100) * 7.5,
                decoration: BoxDecoration(
                  color: LamaColors.mainPink,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(25),
                    bottomRight: Radius.circular(25),
                  ),
                  boxShadow: [
                    BoxShadow(
                        blurRadius: 2,
                        offset: Offset(0, 2),
                        spreadRadius: 1,
                        color: Colors.grey)
                  ],
                ),
                child: Stack(
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
                    Center(
                      child: Text(
                        "Aufgaben-Sets",
                        style: LamaTextTheme.getStyle(fontSize: 22.5),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  ///Returns a centered, seperated ListView containing all loaded Tasksets.
  Widget _buildTasksetList(context, state) {
    return Center(
      child: ListView.separated(
        padding: EdgeInsets.only(top: 15, left: 15, right: 15),
        itemCount: state.tasksets.length,
        itemBuilder: (context, index) {
          return _buildTasksetListItem(context, state.tasksets[index]);
        },
        separatorBuilder: (context, index) => SizedBox(height: 10),
      ),
    );
  }

  ///Returns a Container widget representing a single Taskset.
  ///
  ///Used by [_buildTasksetList()]
  Widget _buildTasksetListItem(context, Taskset taskset) {
    Size screenSize = MediaQuery.of(context).size;
    return Container(
        padding: EdgeInsets.all(10),
        width: screenSize.width,
        height: (screenSize.height / 100) * 17.5,
        decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [LamaColors.orangeAccent, LamaColors.redAccent]),
          borderRadius: BorderRadius.all(Radius.circular(15)),
          boxShadow: [
            BoxShadow(
                color: Colors.blueGrey, offset: Offset(0, 1), blurRadius: 1)
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => {
              Navigator.push(
                context,


                // MaterialPageRoute(
                //   builder: (context) => BlocProvider<TaskBloc>(
                //     create: (context) => TaskBloc(taskset.subject,
                //         generateTaskList(taskset), userRepository),
                //     child: TaskScreen(userGrade),
                //   ),
                // ),
                //

                MaterialPageRoute(
                  // todo doing
                  builder: (context) => MultiBlocProvider(
                    providers: [

                      BlocProvider<TaskBloc>(
                                      create: (context) => TaskBloc(taskset.subject,
                                          generateTaskList(taskset), userRepository),
                  ),
                      BlocProvider<TTSBloc>(
                        create: (context) => TTSBloc(),
                      ),
                    ],
                    child: TaskScreen(userGrade),
                  ),
                ),



              ),
            },
            child: Column(
              children: [
                FittedBox(
                  child: Text(
                    taskset.name!,
                    style: LamaTextTheme.getStyle(fontSize: 20, shadows: [
                      Shadow(
                          color: Colors.blueGrey,
                          offset: Offset(0, 1),
                          blurRadius: 2),
                    ]),
                  ),
                ),
                SizedBox(height: (screenSize.height / 100) * 2),
                FittedBox(
                  child: Text(
                    "Aufgaben insgesamt: " + taskset.tasks!.length.toString(),
                    style: LamaTextTheme.getStyle(fontSize: 15, shadows: [
                      Shadow(
                          color: Colors.blueGrey,
                          offset: Offset(0, 1),
                          blurRadius: 1),
                    ]),
                  ),
                ),
                SizedBox(height: (screenSize.height / 100) * 1.5),
                Text(
                  "Aufgaben pro Durchgang: " +
                      taskset.randomTaskAmount.toString(),
                  style: LamaTextTheme.getStyle(fontSize: 15, shadows: [
                    Shadow(
                        color: Colors.blueGrey,
                        offset: Offset(0, 1),
                        blurRadius: 1),
                  ]),
                ),
              ],
              crossAxisAlignment: CrossAxisAlignment.start,
            ),
          ),
        ));
  }

  ///Returns a list of [Task] that will be passed to the [TaskBloc].
  ///
  ///This list can contain all Tasks of a Taskset (ordered or unordered),
  ///but can also contain only a fraction of the tasks,
  ///based on the Taskset prameters
  List<Task>? generateTaskList(Taskset taskset) {
    if (taskset.randomTaskAmount == taskset.tasks!.length &&
        !taskset.randomizeOrder!) {
      return taskset.tasks;
    }

    List<Task> tasks = [];

    List<Task> tempTasks = [];
    tempTasks.addAll(taskset.tasks!);

    var rng = new Random();

    for (int i = taskset.randomTaskAmount!; i > 0; i--) {
      int index = rng.nextInt(tempTasks.length);
      tasks.add(tempTasks[index]);
      tempTasks.removeAt(index);
    }
    return tasks;
  }
}
