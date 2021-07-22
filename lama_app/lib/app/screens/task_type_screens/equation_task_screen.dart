import 'dart:math';
import 'package:bubble/bubble.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lama_app/app/bloc/task_bloc.dart';
import 'package:lama_app/app/event/task_events.dart';
import 'package:lama_app/app/task-system/task.dart';
import 'package:lama_app/util/LamaColors.dart';
import 'package:lama_app/util/LamaTextTheme.dart';

List<String> fullAnswer = [];
List<String> answers = [];
List<String> resetList = [];

class EquationTaskScreen extends StatefulWidget {
  final BoxConstraints constraints;
  final TaskEquation task;

  EquationTaskScreen(this.task, this.constraints);

  @override
  State<StatefulWidget> createState() {
    fullAnswer.clear();
    answers.clear();
    resetList.clear();
    return EquationState(task, constraints);
  }
}

class EquationState extends State<EquationTaskScreen> {
  final BoxConstraints constraints;
  final TaskEquation task;
  final List<String> fullEquation = [];
  final _r = new Random();
  int _missing1;

  EquationState(this.task, this.constraints) {
    if (task.random.isNotEmpty) {
      int number1 = (int.parse(task.random[1]) +
          _r.nextInt(int.parse(task.random[2]) - int.parse(task.random[1])));
      int number2 = (int.parse(task.random[1]) +
          _r.nextInt(int.parse(task.random[2]) - int.parse(task.random[1])));
      int number3 = (int.parse(task.random[1]) +
          _r.nextInt(int.parse(task.random[2]) - int.parse(task.random[1])));
      fullEquation.add(number1.toString());
      fullEquation.add(task.random[0]);
      fullEquation.add(number2.toString());
      answers.add(number1.toString());
      answers.add(number2.toString());
      for (int i = 0; i < 7; i++) {
        answers.add((int.parse(task.random[1]) +
            _r.nextInt(int.parse(task.random[2]) - int.parse(task.random[1])))
            .toString());
      }
        if (task.operator == 2) {
          fullEquation.add(task.random[0]);
          fullEquation.add(number3.toString());
          answers.add(number3.toString());
        }
        fullEquation.add("=");
        if(task.operator == 1)
          number3 = 0;
        fullEquation.add(_randomRes(task.random[0], number1, number2, number3).toString());
        if(task.operator == 1) {
          _missing1 = _r.nextInt(4);
          while(_missing1==3)
            _missing1 = _r.nextInt(4);
        } else {
          _missing1 = _r.nextInt(6);
          while(_missing1==5) {
            _missing1 = _r.nextInt(6);
          }
        }
        fullAnswer.addAll(fullEquation);
        fullAnswer.removeAt(_missing1);
        fullAnswer.insert(_missing1, "?");
        resetList.addAll(fullAnswer);
        // Normaler Ablauf mit gegebener Gleichung
    } else {
      int j = 0;
      for (int i = 0; i < task.equation.length; i++) {
        if (task.equation[i] == "?") {
          fullEquation.add(task.missingElements[j]);
          j++;
        } else {
          fullEquation.add(task.equation[i]);
        }
      }
      answers.addAll(task.wrongAnswers);
      for(int i = 0; i<task.missingElements.length; i++) {
          String s = task.missingElements[i];
          if(s!="+" && s!="-" && s!="*" && s!="/")
            answers.add(s);
      }
      answers.shuffle();
      fullAnswer.addAll(task.equation);
      resetList.addAll(fullAnswer);
    }
  }

  int _randomRes(String s, int number1, int number2, int number3) {
    if(s == "+") {
      return number1 + number2 + number3;
    }
    if(s == "-") {
      return number1 - number2 - number3;
    }
    if(s == "*" && number3 == 0) {
      return number1 * number2;
    } else {
      return number1 * number2 * number3;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          padding: EdgeInsets.only(left: 15, right: 15),
          height: (constraints.maxHeight / 100) * 30,
          width: (constraints.maxWidth),
          child: Stack(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  padding: EdgeInsets.only(left: 75),
                  height: 50,
                  width: MediaQuery
                      .of(context)
                      .size
                      .width,
                  child: Bubble(
                    nip: BubbleNip.leftCenter,
                    child: Center(
                      child: Text(
                        task.lamaText,
                        style: LamaTextTheme.getStyle(
                            fontSize: 15, color: LamaColors.black),
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
        Container(
          width: constraints.maxWidth,
          height: (constraints.maxHeight / 100) * 7,
          child: _buildEquation(fullAnswer),
        ),
        SizedBox(
          height: (constraints.maxHeight / 100) * 10,
        ),
        Container(
          width: constraints.maxWidth,
          height: (constraints.maxHeight / 100) * 7,
          child: _mathOperations(context),
        ),
        SizedBox(
          height: (constraints.maxHeight / 100) * 1,
        ),
        Container(
          width: constraints.maxWidth,
          height: (constraints.maxHeight / 100) * 30,
          child: _buildAnswers(answers),
        ),
        SizedBox(
          height: (constraints.maxHeight / 100) * 1,
        ),
        Container(
          height: (constraints.maxHeight / 100) * 10,
          child: Align(
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  height: (constraints.maxHeight / 100) * 10,
                  width: (constraints.maxWidth / 100) * 35,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    color: LamaColors.redAccent,
                  ),
                  child: InkWell(
                    child: IconButton(
                      padding: EdgeInsets.all(1.0),
                      icon: Icon(
                          Icons.replay_rounded,
                        size: 40,
                      ),
                      color: LamaColors.white,
                      onPressed: () {
                        setState(() {
                          fullAnswer.clear();
                          fullAnswer.addAll(resetList);
                        });
                        }),
                  ),
                ),
                Container(
                  width: (constraints.maxWidth / 100) * 35,
                  height: (constraints.maxHeight / 100) * 10,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      color: LamaColors.greenAccent,
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: Offset(0, 3))
                      ]),
                  child: InkWell(
                    onTap: () =>
                        BlocProvider.of<TaskBloc>(context).add(
                            AnswerTaskEvent.initEquation(fullEquation, fullAnswer)),
                    child: Center(
                      child: Text(
                        "Fertig!",
                        textAlign: TextAlign.center,
                        style: LamaTextTheme.getStyle(),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          height: (constraints.maxHeight / 100) * 1,
        )
      ],
    );
  }

  Widget _buildAnswers(List<String> wrongAnswers) {
    return Center(
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 5,
            childAspectRatio: 0.01 / 0.01,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10),
        itemCount: answers.length,
        itemBuilder: (context, index) {
          return Draggable<String>(
              data: answers[index],
              childWhenDragging: Container(
                width: (constraints.maxWidth / 100) * 12,
                height: (constraints.maxHeight / 100) * 7,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  color: LamaColors.blueAccent,
                ),
                child: Center(
                  child: Text(
                    wrongAnswers[index],
                    textAlign: TextAlign.center,
                    style: LamaTextTheme.getStyle(),
                  ),
                ),
              ),
              child: Container(
                width: (constraints.maxWidth / 100) * 12,
                height: (constraints.maxHeight / 100) * 7,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  color: LamaColors.blueAccent,
                ),
                child: Center(
                  child: Text(
                    wrongAnswers[index],
                    textAlign: TextAlign.center,
                    style: LamaTextTheme.getStyle(),
                  ),
                ),
              ),
              feedback: Material(
                child: Container(
                  width: (constraints.maxWidth / 100) * 12,
                  height: (constraints.maxHeight / 100) * 7,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    color: LamaColors.blueAccent,
                  ),
                  child: Center(
                    child: Text(
                      wrongAnswers[index],
                      textAlign: TextAlign.center,
                      style: LamaTextTheme.getStyle(),
                    ),
                  ),
                ),
              ));
        },
      ),
    );
  }

  Widget _buildEquation(List<String> equation) {
    return Center(
        child: ListView.separated(
            separatorBuilder: (context, index) =>
                SizedBox(
                  width: (constraints.maxWidth / 100) * 2,
                ),
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            itemCount: equation.length,
            itemBuilder: (BuildContext context, index) {
              bool checked = (fullAnswer[index] != "?");
              return checked
                  ? _equationField(context, index)
                  : _equationTarget(context, index);
            }));
  }

  Widget _equationTarget(BuildContext context, int index) {
    return DragTarget(
        builder: (context, candidate, rejectedData) =>
            Container(
              width: (constraints.maxWidth / 100) * 12,
              height: (constraints.maxHeight / 100) * 5,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  color: LamaColors.blueAccent),
              child: Center(
                child: Text(
                  fullAnswer[index],
                  textAlign: TextAlign.center,
                  style: LamaTextTheme.getStyle(fontSize: 15),
                ),
              ),
            ),
        onWillAccept: (data) => true,
        onAccept: (data) {
          setState(() {
            fullAnswer.removeAt(index);
            fullAnswer.insert(index, data.toString());
          });
        }

      //onLeave: fullAnswer.remove(fullAnswer[fullAnswer.indexOf(data)]),
    );
  }

  Widget _equationField(BuildContext context, int index) {
    return Container(
      width: (constraints.maxWidth / 100) * 12,
      height: (constraints.maxHeight / 100) * 5,
      alignment: Alignment.center,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          color: LamaColors.blueAccent),
      child: Center(
        child: Text(
          fullAnswer[index],
          textAlign: TextAlign.center,
          style: LamaTextTheme.getStyle(fontSize: 15),
        ),
      ),
    );
  }

  Widget _mathOperations(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
      Draggable<String>(
          data: "+",
          childWhenDragging: Container(
              width: (constraints.maxWidth / 100) * 12,
              height: (constraints.maxHeight / 100) * 7,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  color: LamaColors.blueAccent),
              child: Center(
                  child: Text(
                    "+",
                    textAlign: TextAlign.center,
                    style: LamaTextTheme.getStyle(fontSize: 15),
                  ))),
          child: Container(
              width: (constraints.maxWidth / 100) * 12,
              height: (constraints.maxHeight / 100) * 7,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  color: LamaColors.blueAccent),
              child: Center(
                  child: Text(
                    "+",
                    textAlign: TextAlign.center,
                    style: LamaTextTheme.getStyle(fontSize: 15),
                  ))),
          feedback: Material(
              child: Container(
                  width: (constraints.maxWidth / 100) * 12,
                  height: (constraints.maxHeight / 100) * 7,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      color: LamaColors.blueAccent),
                  child: Center(
                      child: Text(
                        "+",
                        textAlign: TextAlign.center,
                        style: LamaTextTheme.getStyle(fontSize: 15),
                      ))))),
      Draggable(
          data: "-",
          child: Container(
              width: (constraints.maxWidth / 100) * 12,
              height: (constraints.maxHeight / 100) * 7,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  color: LamaColors.blueAccent),
              child: Center(
                  child: Text(
                    "-",
                    textAlign: TextAlign.center,
                    style: LamaTextTheme.getStyle(fontSize: 15),
                  ))),
          feedback: Material(
              child: Container(
                  width: (constraints.maxWidth / 100) * 12,
                  height: (constraints.maxHeight / 100) * 7,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      color: LamaColors.blueAccent),
                  child: Center(
                      child: Text(
                        "-",
                        textAlign: TextAlign.center,
                        style: LamaTextTheme.getStyle(fontSize: 15),
                      ))))),
      Draggable(
          data: "*",
          child: Container(
              width: (constraints.maxWidth / 100) * 12,
              height: (constraints.maxHeight / 100) * 7,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  color: LamaColors.blueAccent),
              child: Center(
                  child: Text(
                    "*",
                    textAlign: TextAlign.center,
                    style: LamaTextTheme.getStyle(fontSize: 15),
                  ))),
          feedback: Material(
              child: Container(
                  width: (constraints.maxWidth / 100) * 12,
                  height: (constraints.maxHeight / 100) * 7,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      color: LamaColors.blueAccent),
                  child: Center(
                      child: Text(
                        "*",
                        textAlign: TextAlign.center,
                        style: LamaTextTheme.getStyle(fontSize: 15),
                      ))))),
      Draggable(
          data: "/",
          child: Container(
              width: (constraints.maxWidth / 100) * 12,
              height: (constraints.maxHeight / 100) * 7,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  color: LamaColors.blueAccent),
              child: Center(
                  child: Text(
                    "/",
                    textAlign: TextAlign.center,
                    style: LamaTextTheme.getStyle(fontSize: 15),
                  ))),
          feedback: Material(
              child: Container(
                  width: (constraints.maxWidth / 100) * 12,
                  height: (constraints.maxHeight / 100) * 7,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      color: LamaColors.blueAccent),
                  child: Center(
                      child: Text(
                        "/",
                        textAlign: TextAlign.center,
                        style: LamaTextTheme.getStyle(fontSize: 15),
                      ))))),
    ]);
  }
}
