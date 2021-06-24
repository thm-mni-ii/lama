import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lama_app/app/bloc/choose_taskset_bloc.dart';
import 'package:lama_app/app/bloc/task_bloc.dart';
import 'package:lama_app/app/event/choose_taskset_events.dart';
import 'package:lama_app/app/repository/user_repository.dart';
import 'package:lama_app/app/screens/task_screen.dart';
import 'package:lama_app/app/state/choose_taskset_state.dart';
import 'package:lama_app/app/task-system/task.dart';
import 'package:lama_app/app/task-system/taskset_model.dart';
import 'package:lama_app/util/LamaColors.dart';
import 'package:lama_app/util/LamaTextTheme.dart';

class ChooseTasksetScreen extends StatefulWidget {
  final String chosenSubject;
  final int userGrade;
  final UserRepository userRepository;

  ChooseTasksetScreen(this.chosenSubject, this.userGrade, this.userRepository) {
    //TasksetProvider: get all TasksetNames for Subject and class
  }

  @override
  State<StatefulWidget> createState() {
    return ChooseTasksetScreenState(chosenSubject, userGrade, userRepository);
  }
}

class ChooseTasksetScreenState extends State<ChooseTasksetScreen> {
  String chosenSubject;
  int userGrade;
  UserRepository userRepository;
  ChooseTasksetScreenState(
      this.chosenSubject, this.userGrade, this.userRepository);

  @override
  void initState() {
    super.initState();
    BlocProvider.of<ChooseTasksetBloc>(context)
        .add(LoadAllTasksetsEvent(chosenSubject, userGrade));
  }

  @override
  Widget build(BuildContext context) {
    /*return Container(
      child: BlocBuilder<ChooseTasksetBloc, ChooseTasksetState>(
        builder: (context, state) {
          if (state is LoadingAllTasksetsState)
            return Center(
              child: CircularProgressIndicator(),
            );
          if (state is LoadedAllTasksetsState) {
            print("L:" + state.tasksets.length.toString());
            return Center(
              child: ListView.builder(
                itemCount: state.tasksets.length,
                itemBuilder: (context, index) =>
                    Text(state.tasksets[index].name),
              ),
            );
          } else
            return Text("This should not happen");
        },
      ),
    );*/
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

  Widget _buildTasksetListItem(context, Taskset taskset) {
    Size screenSize = MediaQuery.of(context).size;
    return Container(
        padding: EdgeInsets.all(10),
        width: screenSize.width,
        height: (screenSize.height / 100) * 15,
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
                MaterialPageRoute(
                  builder: (context) => BlocProvider<TaskBloc>(
                    create: (context) => TaskBloc(taskset.subject,
                        generateTaskList(taskset), userRepository),
                    child: TaskScreen(),
                  ),
                ),
              ),
            },
            child: Column(
              children: [
                Text(
                  taskset.name,
                  style: LamaTextTheme.getStyle(fontSize: 20, shadows: [
                    Shadow(
                        color: Colors.blueGrey,
                        offset: Offset(0, 1),
                        blurRadius: 2),
                  ]),
                ),
                SizedBox(height: (screenSize.height / 100) * 1.5),
                Text(
                  "Aufgaben insgesamt: " + taskset.tasks.length.toString(),
                  style: LamaTextTheme.getStyle(fontSize: 15, shadows: [
                    Shadow(
                        color: Colors.blueGrey,
                        offset: Offset(0, 1),
                        blurRadius: 1),
                  ]),
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

  List<Task> generateTaskList(Taskset taskset) {
    List<Task> tasks = [];

    List<Task> tempTasks = [];
    tempTasks.addAll(taskset.tasks);

    var rng = new Random();

    for (int i = taskset.randomTaskAmount; i > 0; i--) {
      int index = rng.nextInt(tempTasks.length);
      tasks.add(tempTasks[index]);
      tempTasks.removeAt(index);
      print(index);
    }
    return tasks;
  }
}
