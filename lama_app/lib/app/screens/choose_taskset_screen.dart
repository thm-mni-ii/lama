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
    return Container(
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
    );
  }
}
