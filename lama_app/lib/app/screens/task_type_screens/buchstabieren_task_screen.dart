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
class BuchstabierenTaskScreen extends StatelessWidget {
  // task infos and constraints handed over by tasktypeScreen
  final TaskBuchstabieren task;
  final BoxConstraints constraints;
  // List of all possible Answers
  final List<String> answers = [];

  BuchstabierenTaskScreen(this.task, this.constraints) {}

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
                      task.lamaText,
                      style: LamaTextTheme.getStyle(
                          color: LamaColors.black, fontSize: 15),
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
      Text('test'),
    ]); 
    // create space between each childs
  }
}
