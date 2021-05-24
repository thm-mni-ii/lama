import 'package:bubble/bubble.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lama_app/app/task-system/task.dart';
import 'package:lama_app/util/LamaColors.dart';
import 'package:lama_app/util/LamaTextTheme.dart';

class MatchCategoryTaskScreen extends StatelessWidget {
  final TaskMatchCategory task;
  final List<String> categorySum = [];
  final BoxConstraints constraints;

  MatchCategoryTaskScreen(this.task, this.constraints) {
    categorySum.addAll(task.categoryOne);
    categorySum.addAll(task.categoryTwo);
    categorySum.shuffle();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
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
              )
            ],
          ),
        ),
        //Items
        Padding(
            padding: EdgeInsets.all(5),
            child: Container(
                height: (constraints.maxHeight / 100) * 60,
                //color: LamaColors.greenAccent,
                child: Stack(children: generateItems()))),
        //Category´s
        Container(
          height: (constraints.maxHeight / 100) * 12,
          //color: LamaColors.blueAccent,
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                height: 60,
                width: 185,
                decoration:
                    BoxDecoration(color: LamaColors.blueAccent, boxShadow: [
                  BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 1,
                      blurRadius: 7,
                      offset: Offset(0, 3)),
                ]),
                child: Center(
                  child: Text(
                    task.nameCatOne,
                    style: LamaTextTheme.getStyle(
                      color: LamaColors.white,
                      fontSize: 30,
                    ),
                  ),
                ),
              ),
              Container(
                height: 60,
                width: 185,
                decoration:
                    BoxDecoration(color: LamaColors.orangeAccent, boxShadow: [
                  BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 1,
                      blurRadius: 7,
                      offset: Offset(0, 3)),
                ]),
                child: Center(
                  child: Text(
                    task.nameCatTwo,
                    style: LamaTextTheme.getStyle(
                      color: LamaColors.white,
                      fontSize: 30,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
        // Done Button
        Container(
          height: (constraints.maxHeight / 100) * 9,
          alignment: Alignment.bottomCenter,
          //color: LamaColors.greenAccent,
          child: Container(
            height: 45,
            width: 200,
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
              child: Center(
                child: Text(
                  "Fertig",
                  style: LamaTextTheme.getStyle(
                    color: LamaColors.white,
                    fontSize: 30,
                  ),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }

  List<Widget> generateItems() {
    String text = "test";
    List<Widget> output = [];
    List<Widget> positions = [
      Positioned(
          bottom: (constraints.maxHeight / 100) * 50,
          left: (constraints.maxWidth / 100) * 55,
          child: Container(
            height: 50,
            width: 150,
            color: LamaColors.greenAccent,
            child: Center(
            child: Text(
              text,
              style: LamaTextTheme.getStyle()
            ),
          ))),
      Positioned(
          bottom: (constraints.maxHeight / 100) * 45,
          left: (constraints.maxWidth / 100) * 10,
          child: Container(
            height: 50,
            width: 150,
              color: LamaColors.greenAccent,
              child: Center(
                child: Text(
                    '$text',
                    style: LamaTextTheme.getStyle()
                ),
              )
          )),
      Positioned(
          bottom: (constraints.maxHeight / 100) * 32,
          left: (constraints.maxWidth / 100) * 5,
          child: Container(
            height: 50,
            width: 150,
              color: LamaColors.greenAccent,
              child: Center(
                child: Text(
                    text,
                    style: LamaTextTheme.getStyle()
                ),
              )
          )),
      Positioned(
          bottom: (constraints.maxHeight / 100) * 38,
          left: (constraints.maxWidth / 100) * 50,
          child: Container(
            height: 50,
            width: 150,
              color: LamaColors.greenAccent,
              child: Center(
                child: Text(
                    text,
                    style: LamaTextTheme.getStyle()
                ),
              )
          )),
      Positioned(
          bottom: (constraints.maxHeight / 100) * 25,
          left: (constraints.maxWidth / 100) * 53,
          child: Container(
            height: 50,
            width: 150,
              color: LamaColors.greenAccent,
              child: Center(
                child: Text(
                    text,
                    style: LamaTextTheme.getStyle()
                ),
              )
          )),
      Positioned(
          bottom: (constraints.maxHeight / 100) * 2,
          left: (constraints.maxWidth / 100) * 58,
          child: Container(
            height: 50,
            width: 150,
              color: LamaColors.greenAccent,
              child: Center(
                child: Text(
                    text,
                    style: LamaTextTheme.getStyle()
                ),
              )
          )),
      Positioned(
          bottom: (constraints.maxHeight / 100) * 15,
          left: (constraints.maxWidth / 100) * 30,
          child: Container(
            height: 50,
            width: 150,
              color: LamaColors.greenAccent,
              child: Center(
                child: Text(
                    text,
                    style: LamaTextTheme.getStyle()
                ),
              )
          )),
      Positioned(
          bottom: (constraints.maxHeight / 100) * 5,
          left: (constraints.maxWidth / 100) * 9,
          child: Container(
            height: 50,
            width: 150,
              color: LamaColors.greenAccent,
              child: Center(
                child: Text(
                    text,
                    style: LamaTextTheme.getStyle()
                ),
              )
          )),
    ];
    positions.shuffle();
    for(int i = 0; i <= categorySum.length; i++){
      Widget tmp = positions.elementAt(i);
    }

    return positions;
  }
}
