import 'package:bubble/bubble.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lama_app/app/bloc/task_bloc.dart';
import 'package:lama_app/app/event/task_events.dart';

import '../../../util/LamaColors.dart';
import '../../../util/LamaTextTheme.dart';
import '../../task-system/task.dart';

/// This file creates the Cloze Test task Screen
/// The Cloze Test Task provides a short sentence where some part of the
/// Sentence is keyed out. You can choose from 3 different soloutions to fill in.
/// After pressing on one of the possibilities the answer will be checked
///
/// Author: T.Rentsch
/// latest Changes: 10.07.2021

/// ClozeTestTaskScreen class creates the Cloze Test Task Screen

class BuchstabierenTaskScreen extends StatefulWidget {
  final TaskBuchstabieren task;
  final BoxConstraints constraints;

  BuchstabierenTaskScreen(this.task, this.constraints);

  @override
  State<StatefulWidget> createState() {
    return BuchstabierenTaskState(task, constraints);
  }
}

class BuchstabierenTaskState extends State<BuchstabierenTaskScreen> {
  // task infos and constraints handed over by tasktypeScreen
  final TaskBuchstabieren task;
  final BoxConstraints constraints;
  // Value which is checked after pressing the "fertig" Button
  int i = 0;
  bool answer;
  // var random = Random();
  //var rnd;

  BuchstabierenTaskState(this.task, this.constraints);

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      // Lama Speechbubble
      Container(
        height: (constraints.maxHeight / 100) * 15,
        padding: EdgeInsets.only(left: 15, right: 15, top: 15),
        // create space between each childs
        child: Stack(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                padding: EdgeInsets.only(left: 75),
                height: 50,
                width: MediaQuery.of(context).size.width,
                child: Bubble(
                  nip: BubbleNip.leftCenter,
                  child: Center(
                    child: Text(
                      task.woerter[0],
                      style: LamaTextTheme.getStyle(
                          color: LamaColors.greenAccent, fontSize: 15),
                    ),
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: SvgPicture.asset(
                "assets/images/svg/lama_head.svg",
                semanticsLabel: "Lama Anna",
                width: 75,
              ),
            ),
          ],
        ),
      ),

      Container(
        decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.fromLTRB(0, 50, 0, 0),
        height: MediaQuery.of(context).size.height / 5,
        width: MediaQuery.of(context).size.width / 2,
        child: SvgPicture.asset('assets/images/svg/Objects/Auto.svg'),
      ),
      Container(
        margin: EdgeInsets.all(10),
        height: 50.0,
        child: ElevatedButton(
          onPressed: () {},
          child: Text("A", style: TextStyle(fontSize: 15)),
        ),
      ),
      Container(
        margin: EdgeInsets.all(10),
        height: 50.0,
        child: ElevatedButton(
          onPressed: () {},
          child: Text("UUU", style: TextStyle(fontSize: 15)),
        ),
      ),
      Container(
        margin: EdgeInsets.all(10),
        height: 50.0,
        child: ElevatedButton(
          onPressed: () {},
          child: Text("T", style: TextStyle(fontSize: 15)),
        ),
      ),
      Container(
        margin: EdgeInsets.all(10),
        height: 50.0,
        child: ElevatedButton(
          onPressed: () {},
          child: Text("O", style: TextStyle(fontSize: 15)),
        ),
      )
    ]);
  }
}
