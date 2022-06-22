import 'package:bubble/bubble.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lama_app/app/bloc/task_bloc.dart';
import 'package:lama_app/app/event/task_events.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:lama_app/app/screens/task_type_screens/cloze_test_task_screen.dart';


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

class ClozeTestTaskScreen extends StatefulWidget {
  final TaskClozeTest task;
  final BoxConstraints constraints;
  // List of all possible Answers
  final List<String> answers = [];
  final FlutterTts flutterTts = FlutterTts();


  ClozeTestTaskScreen(this.task, this.constraints) {
    answers.add(task.rightAnswer); //get the right answer
    answers.addAll(task.wrongAnswers); // add the wrong answers
    answers.shuffle(); // randomize in list

    readquestion() async {
      var text = task.question;
      if(task.answerLanguage == "Englisch") {
        await flutterTts.setLanguage("en-En");
      } else {
        await flutterTts.setLanguage("de-De");
      }
      await flutterTts.setVolume(1.0);
      await flutterTts.speak(text);
    }


  }
  @override
  ClozeTest createState() {
    ClozeTestTaskScreen(task, constraints);
    return ClozeTest(task, constraints, answers);

  }
}

class ClozeTest extends State<ClozeTestTaskScreen> {
  final TaskClozeTest task;
  final List<String> answers = [];
  final BoxConstraints constraints;
  final FlutterTts flutterTts = FlutterTts();
  String selectedAnswer = "";

  ClozeTest(this.task, this.constraints, answers) {
    this.answers.add(answers[0]);
    this.answers.add(answers[1]);
    this.answers.add(answers[2]);

  }

  readText(String text) async {
    if(task.answerLanguage == "Englisch") {
      await flutterTts.setLanguage("en-En");
    } else {
      await flutterTts.setLanguage("de-De");
    }
    await flutterTts.setVolume(1.0);
    await flutterTts.speak(text);
  }


  confirmAnswer(String answer, index) {
    if(answer != selectedAnswer) {
      readText(answer);
    } else {
      BlocProvider.of<TaskBloc>(context)
          .add(AnswerTaskEvent(answers[index]));
    }
  }
  @override
  Widget build(BuildContext context) {
    Color color0 = selectedAnswer == answers[0] ? LamaColors.purpleAccent : LamaColors.greenAccent;
    Color color1 = selectedAnswer == answers[1] ? LamaColors.purpleAccent : LamaColors.blueAccent;
    Color color2 = selectedAnswer == answers[2] ? LamaColors.purpleAccent : LamaColors.greenAccent;
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
                    color: color0,
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 1,
                          blurRadius: 7,
                          offset: Offset(0, 3)),
                    ]),
                child: InkWell(
                  onTap: () {
                    setState(() {
                      confirmAnswer(answers[0],0);
                      selectedAnswer = answers[0];
                    });
                  },
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
                    color: color1,
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 1,
                          blurRadius: 7,
                          offset: Offset(0, 3))
                    ]),
                child: InkWell(
                  onTap: () {
                    setState(() {
                      confirmAnswer(answers[1],1);
                      selectedAnswer = answers[1];
                    });
                  },
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
                    color: color2,
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 1,
                          blurRadius: 7,
                          offset: Offset(0, 3))
                    ]),
                child: InkWell(
                  onTap: () {
                    setState(() {
                      confirmAnswer(answers[2],2);
                      selectedAnswer = answers[2];
                    });
                  },
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