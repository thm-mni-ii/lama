import 'package:bubble/bubble.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lama_app/app/task-system/task.dart';
import 'package:lama_app/util/LamaColors.dart';
import 'package:lama_app/util/LamaTextTheme.dart';

List<String> fullAnswer = [];

class EquationTaskScreen extends StatefulWidget {
  final BoxConstraints constraints;
  final TaskEquation task;

  EquationTaskScreen(this.task, this.constraints);

  @override
  State<StatefulWidget> createState() {
    return EquationState(task, constraints);
  }
}

class EquationState extends State<EquationTaskScreen> {
  final BoxConstraints constraints;
  final TaskEquation task;
  final List<String> fullEquation = [];

  EquationState(this.task, this.constraints) {
    int j = 0;
    for (int i = 0; i < task.equation.length; i++) {
      if (task.equation[i] == "?") {
        fullEquation.add(task.missingElements[j]);
        j++;
      } else {
        fullEquation.add(task.equation[i]);
      }
    }
    for (int i = 0; i<task.missingElements.length; i++) {
      task.wrongAnswers.add(task.missingElements[i]);
    }
    task.wrongAnswers.shuffle();
    fullAnswer.addAll(task.equation);
    print(fullAnswer);
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
                  width: MediaQuery.of(context).size.width,
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
          child: _buildAnswers(task.wrongAnswers),
        ),
        SizedBox(
          height: (constraints.maxHeight / 100) * 1,
        ),
        Container(
          width: (constraints.maxWidth / 100) * 50,
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
            onTap: () => null,
            child: Center(
              child: Text(
                "Fertig!",
                textAlign: TextAlign.center,
                style: LamaTextTheme.getStyle(),
              ),
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
        itemCount: task.wrongAnswers.length,
        itemBuilder: (context, index) {
          return Draggable<String>(
            data: task.wrongAnswers[index],
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
            separatorBuilder: (context, index) => SizedBox(
                  width: (constraints.maxWidth / 100) * 2,
                ),
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            itemCount: equation.length,
            itemBuilder: (BuildContext context, index) {
              print(index);
              print(fullAnswer);
              bool checked = (task.equation[index] != "?");
              return checked
                  ? _equationField(context, index)
                  : _equationTarget(context, index);
            }));
  }

  Widget _equationTarget(BuildContext context,int index) {
    return DragTarget(
      builder: (context, candidate, rejectedData) => Container(
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
          print(data);
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
          task.equation[index],
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
