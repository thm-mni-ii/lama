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
import 'package:lama_app/util/GlobalKeyExtension.dart';

List<Pair> pairList = [];

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
    pairList.clear();
    task.pair1.shuffle();
    task.pair2.shuffle();
    task.pair1.forEach((element) {
      leftWords.add(Item(false, element.toString(), true, GlobalKey()));
    });
    task.pair2.forEach((element) {
      rightWords.add(Item(false, element.toString(), false, GlobalKey()));
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

        CustomPaint(
          painter: CurvePainter(),
          child: Container(
            //color: LamaColors.redPrimary,
            // positioning answers on the screen
            child: Row(
              children: [
                //left words

                Container(
                    color: LamaColors.redPrimary,
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
                  //color: LamaColors.redPrimary,
                  width: (constraints.maxWidth / 100) * 25,
                  height: (constraints.maxHeight / 100) * 60,
                  /*
              child: CustomPaint(
                painter: CurvePainter(),
              ),*/
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
          ),
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
          key: itemList[index].key,
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
        RenderBox box = itemList[index].key.currentContext.findRenderObject();
        Offset position = box.localToGlobal(Offset.zero);
        itemList[index].xValue = itemList[index].key.globalPaintBounds.right;
        itemList[index].yValue = itemList[index].key.globalPaintBounds.bottom;

        if (!choosenWords.contains(itemList[index])) {
          choosenWords.add(itemList[index]);
        }
        touch(index, itemList);
      },
    );
  }

  void touch(int index, List<Item> itemlist) {
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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            duration: Duration(seconds: 2),
            content: Container(
                height: (constraints.maxHeight / 100) * 6,
                alignment: Alignment.bottomCenter,
                child: Center(
                    child: FittedBox(
                  fit: BoxFit.fitWidth,
                  child: Text(
                    "Zwei Wörter der gleichen Seite \n können nicht verbunden werden !",
                    style: LamaTextTheme.getStyle(),
                    textAlign: TextAlign.center,
                  ),
                ))),
            backgroundColor: LamaColors.mainPink,
          ),
        );
      } else {
        givenAnswers
            .add(choosenWords[0].content + ":" + choosenWords[1].content);
        pairList.add(Pair(choosenWords[0], choosenWords[1]));
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
  double xValue;
  double yValue;
  GlobalKey key;

  Item(bool touched, String content, bool left, GlobalKey key) {
    this.touched = touched;
    this.content = content;
    this.left = left;
    this.key = key;
  }
}

class Pair {
  Item itemOne;
  Item itemTwo;

  Pair(this.itemOne, this.itemTwo);
}

class CurvePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    if (pairList.isEmpty) {
      return;
    }
    var paint = Paint();
    paint.color = Colors.black;
    paint.strokeWidth = 5;
    print(pairList[0].itemOne.yValue);
    print(pairList[0].itemOne.xValue);
    pairList.forEach((element) {
      canvas.drawLine(
          Offset(element.itemOne.xValue, element.itemOne.yValue),
          Offset(element.itemTwo.xValue, element.itemTwo.yValue),
          //Offset(10, 0),
          //Offset(500, 500),
          paint);
    });
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
