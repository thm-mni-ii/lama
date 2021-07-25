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
class ClozeTestTaskScreen extends StatelessWidget {
  // task infos and constraints handed over by tasktypeScreen
  final TaskClozeTest task;
  final BoxConstraints constraints;
  // List of all possible Answers
  final List<String> answers = [];

  ClozeTestTaskScreen(this.task, this.constraints) {
    answers.add(task.rightAnswer); //get the right answer
    answers.addAll(task.wrongAnswers); // add the wrong answers
    answers.shuffle(); // randomize in list
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      // Task Question
      Container(
          height: (constraints.maxHeight / 100) * 30,
          child: Align(
            child: Text(task.question,
                textAlign: TextAlign.center,
                style: LamaTextTheme.getStyle(color: LamaColors.black, fontSize: 30,)),
            //alignment: Alignment.centerLeft,
          )),
      // Lama Speechbubble
      Container(
        height: (constraints.maxHeight / 100) * 15,
        padding: EdgeInsets.only(left: 15, right: 15),
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
                      style:
                          LamaTextTheme.getStyle(color: LamaColors.black, fontSize: 15),
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
            )
          ],
        ),
      ),
      // Task Answers
      Container(
          height: (constraints.maxHeight / 100) * 50,
          alignment: Alignment.bottomCenter,
          padding: EdgeInsets.only(top: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                height: 55,
                width: 250,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    color: LamaColors.greenAccent,
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 1,
                          blurRadius: 7,
                          offset: Offset(0, 3)),
                    ]),
                child: InkWell(
                  onTap: () => BlocProvider.of<TaskBloc>(context)
                      .add(AnswerTaskEvent(answers[0])),
                  child: Center(
                    child: Text(
                      answers[0],
                      style: LamaTextTheme.getStyle(color: LamaColors.white, fontSize: 30,),
                    ),
                  ),
                ),
              ),
              Container(
                height: 55,
                width: 250,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    color: LamaColors.blueAccent,
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 1,
                          blurRadius: 7,
                          offset: Offset(0, 3))
                    ]),
                child: InkWell(
                  onTap: () => BlocProvider.of<TaskBloc>(context)
                      .add(AnswerTaskEvent(answers[1])),
                  child: Center(
                    child: Text(
                      answers[1],
                      style: LamaTextTheme.getStyle(color: LamaColors.white, fontSize: 30,),
                    ),
                  ),
                ),
              ),
              Container(
                height: 55,
                width: 250,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    color: LamaColors.greenAccent,
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 1,
                          blurRadius: 7,
                          offset: Offset(0, 3))
                    ]),
                child: InkWell(
                  onTap: () => BlocProvider.of<TaskBloc>(context)
                      .add(AnswerTaskEvent(answers[2])),
                  child: Center(
                    child: Text(
                      answers[2],
                      style: LamaTextTheme.getStyle(color: LamaColors.white, fontSize: 30,),
                    ),
                  ),
                ),
              )
            ],
          ))
    ]);
  }
}
