import 'package:bubble/bubble.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../task-system/task.dart';

class ClozeTestTaskScreen extends StatelessWidget{
  final TaskClozeTest task;
  final List<String> answers = [];
  final BoxConstraints constraints;

  ClozeTestTaskScreen(this.task, this.constraints){
    answers.add(task.rightAnswer);  //get the right answer
    answers.addAll(task.wrongAnswers); // add the wrong answers
    answers.shuffle(); // randomize in list
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Container(
        height: (constraints.maxHeight / 100) * 30,
        child: Align(
          child: Text(
            task.question,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            )
          ),
          alignment: Alignment.centerLeft,
        )
      ),
      Container(
        height: (constraints.maxHeight / 100) * 15,
        padding: EdgeInsets.only(left: 15, right: 15), // create space between each childs
        child: Stack(children: [
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
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
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
        ],),
      )
    ]);
  }
}
