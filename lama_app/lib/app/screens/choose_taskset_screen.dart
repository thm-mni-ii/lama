import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lama_app/app/bloc/choose_taskset_bloc.dart';
import 'package:lama_app/app/bloc/task_bloc.dart';
import 'package:lama_app/app/event/choose_taskset_events.dart';
import 'package:lama_app/app/screens/task_screen.dart';
import 'package:lama_app/app/state/choose_taskset_state.dart';
import 'package:lama_app/app/task-system/taskset_model.dart';

class ChooseTasksetScreen extends StatefulWidget {
  final String chosenSubject;

  ChooseTasksetScreen(this.chosenSubject) {
    //TasksetProvider: get all TasksetNames for Subject and class
  }

  @override
  State<StatefulWidget> createState() {
    return ChooseTasksetScreenState(chosenSubject);
  }
}

class ChooseTasksetScreenState extends State<ChooseTasksetScreen> {
  String chosenSubject;
  ChooseTasksetScreenState(this.chosenSubject);

  @override
  void initState() {
    super.initState();
    BlocProvider.of<ChooseTasksetBloc>(context)
        .add(LoadAllTasksetsEvent(chosenSubject));
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
      backgroundColor: Color.fromARGB(255, 253, 74, 111),
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              color: Colors.white,
              child: Container(
                margin: EdgeInsets.only(top: 50),
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
                height: 50,
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 253, 74, 111),
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
                child: Center(
                  child: Text(
                    "Aufgaben-Set auswählen",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
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
      child: ListView.builder(
          padding: EdgeInsets.only(top: 15, left: 15, right: 15),
          itemCount: state.tasksets.length,
          itemBuilder: (context, index) {
            if (index > 0)
              return Container(
                child: Column(
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    _buildTasksetListItem(context, state.tasksets[index])
                  ],
                ),
              );
            else
              return _buildTasksetListItem(context, state.tasksets[index]);
          }),
    );
  }

  Widget _buildTasksetListItem(context, Taskset taskset) {
    Size screenSize = MediaQuery.of(context).size;
    return Container(
        padding: EdgeInsets.all(10),
        width: screenSize.width,
        height: screenSize.height / 8,
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [Colors.orange, Colors.pink]),
          borderRadius: BorderRadius.all(Radius.circular(15)),
          boxShadow: [
            BoxShadow(
                color: Colors.blueGrey, offset: Offset(0, 1), blurRadius: 1)
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BlocProvider<TaskBloc>(
                  create: (context) => TaskBloc(taskset.subject, taskset.tasks),
                  child: TaskScreen(),
                ),
              ),
            ),
            child: Column(
              children: [
                Text(
                  taskset.name,
                  style: TextStyle(color: Colors.white, fontSize: 30, shadows: [
                    Shadow(
                        color: Colors.blueGrey,
                        offset: Offset(0, 1),
                        blurRadius: 2),
                  ]),
                ),
                SizedBox(height: 10),
                Text(
                  "Aufgaben: " + taskset.tasks.length.toString(),
                  style: TextStyle(color: Colors.white, fontSize: 15, shadows: [
                    Shadow(
                        color: Colors.blueGrey,
                        offset: Offset(0, 1),
                        blurRadius: 1),
                  ]),
                )
              ],
              crossAxisAlignment: CrossAxisAlignment.start,
            ),
          ),
        ));
  }
}
