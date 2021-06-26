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

class ConnectTaskScreen extends StatefulWidget {
  final TaskConnect task;
  final BoxConstraints constraints;

  ConnectTaskScreen(this.task, this.constraints);

  @override
  State<StatefulWidget> createState() {
    return ConnectState(task, constraints);
  }
}

class ConnectState extends State<ConnectTaskScreen> {
  final TaskConnect task;
  final BoxConstraints constraints;
  List<Item> leftWords = [];
  List<Item> rightWords = [];
  List<Item> choosenWords = [];
  List<String> givenAnswers = [];

  ConnectState(this.task, this.constraints) {
    task.pair1.shuffle();
    task.pair2.shuffle();
    task.pair1.forEach((element) {
      leftWords.add(Item(false, element.toString(), true));
    });
    task.pair2.forEach((element) {
      rightWords.add(Item(false, element.toString(), false));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        //Creating lama + lamaspeechbubble
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
              )
            ],
          ),
        ),
        // positioning answers on the screen
        Row(
          children: [
            //left words
            Container(
                padding: EdgeInsets.only(top: 20, left: 10),
                width: (constraints.maxWidth / 100) * 37.5,
                height: (constraints.maxHeight / 100) * 60,
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 1,
                    childAspectRatio: 3 / 1,
                    mainAxisSpacing: 40,
                  ),
                  itemCount: leftWords.length,
                  itemBuilder: (context, index) =>
                      _buildPair(context, index, leftWords),
                )),
            //Space between both containers
            Container(
              width: (constraints.maxWidth / 100) * 25,
              height: (constraints.maxHeight / 100) * 60,
            ),
            // Right words
            Container(
                padding: EdgeInsets.only(top: 20, right: 10),
                width: (constraints.maxWidth / 100) * 37.5,
                height: (constraints.maxHeight / 100) * 60,
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 1,
                    childAspectRatio: 3 / 1,
                    mainAxisSpacing: 40,
                  ),
                  itemCount: rightWords.length,
                  itemBuilder: (context, index) =>
                      _buildPair(context, index, rightWords),
                )),
          ],
        ),
        //space to "fertig" button
        SizedBox(
          height: (constraints.maxHeight / 100) * 5,
        ),
        // "fertig" button
        Container(
          width: (constraints.maxWidth / 100) * 50,
          height: (constraints.maxHeight / 100) * 15,
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
            onTap: () => BlocProvider.of<TaskBloc>(context)
                .add(AnswerTaskEvent.initMarkWords(givenAnswers)),
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
          height: (constraints.maxHeight / 100) * 5,
        )
      ],
    );
  }

  // Method to build posible answers
  Widget _buildPair(context, index, List<Item> itemList) {
    return InkWell(
      child: Container(
          height: 7,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(5)),
              color: itemList[index].touched
                  ? LamaColors.redPrimary
                  : LamaColors.white,
              border: Border.all(color: LamaColors.black)),
          child: Center(
            child: Text(itemList[index].content,
                textAlign: TextAlign.center,
                style: LamaTextTheme.getStyle(
                    fontSize: 15, color: LamaColors.black)),
          )),
      onTap: () {
        choosenWords.add(itemList[index]);
        touch(index, itemList);
      },
    );
  }

  void touch(int index, List<Item> itemlist) {
    choosenWords.forEach((element) {
      print(element.content);
      print('\n');
    });

    if (itemlist[index].touched) {
      itemlist[index].touched = false;
      choosenWords.removeLast();
    } else if (!itemlist[index].touched) {
      itemlist[index].touched = true;
    }

    if (choosenWords.length >= 2) {
      if (choosenWords[0].left == itemlist[1].left) {
        choosenWords.forEach((element) {
          element.touched = false;
        });
        choosenWords.clear();
      }
    }
    setState(() {});
  }
}

class Item {
  bool touched;
  String content;
  bool left;

  Item(bool touched, String content, bool left) {
    this.touched = touched;
    this.content = content;
    this.left = left;
  }
}
