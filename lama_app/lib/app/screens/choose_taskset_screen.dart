import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lama_app/app/bloc/choose_taskset_bloc.dart';
import 'package:lama_app/app/event/choose_taskset_events.dart';
import 'package:lama_app/app/state/choose_taskset_state.dart';

class ChooseTasksetScreen extends StatefulWidget {
  final String chosenSubject;

  ChooseTasksetScreen(this.chosenSubject) {
    //TasksetProvider: get all TasksetNames for Subject and class
  }

  @override
  State<StatefulWidget> createState() {
    return ChooseTasksetScreenState();
  }
}

class ChooseTasksetScreenState extends State<ChooseTasksetScreen> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<ChooseTasksetBloc>(context).add(LoadAllTasksetsEvent());
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
                    Text(state.tasksets[index].name)
                  ],
                ),
              );
            return Center(child: Text(state.tasksets[index].name));
          }),
    );
  }
}
