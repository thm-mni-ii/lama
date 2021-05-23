import 'package:bubble/bubble.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lama_app/app/task-system/task.dart';
import 'package:lama_app/util/LamaColors.dart';
import 'package:lama_app/util/LamaTextTheme.dart';

class MatchCategoryTaskScreen extends StatelessWidget{
  final TaskMatchCategory task;
  final List<String> categorySum = [];
  final BoxConstraints constraints;

  MatchCategoryTaskScreen(this.task, this.constraints){
    categorySum.addAll(task.categoryOne);
    categorySum.addAll(task.categoryTwo);
    categorySum.shuffle();
  }

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

      Container(
        height: (constraints.maxHeight / 100) * 60,
        color: LamaColors.greenAccent,
        child: Stack(children: [Positioned(
                  bottom:(constraints.maxHeight / 100) * 50,
                  left: (constraints.maxWidth/100)*60,
                  child: Container(
                    height: 50,
                    width: 150,
                    color: LamaColors.orangeAccent,
                  ))],)
      ),

      //Category´s
      Container(
        height: (constraints.maxHeight / 100) * 15,
        //color: LamaColors.blueAccent,
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              height: 60,
              width: 185,
              decoration: BoxDecoration(
                  color: LamaColors.blueAccent,
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 1,
                        blurRadius: 7,
                        offset: Offset(0, 3)),
                  ]),
              child: Center(
                child: Text(
                  task.nameCatOne,
                  style: LamaTextTheme.getStyle(color: LamaColors.white, fontSize: 30,),
                ),
              ),
            ),
            Container(
              height: 60,
              width: 185,
              decoration: BoxDecoration(
                  color: LamaColors.orangeAccent,
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 1,
                        blurRadius: 7,
                        offset: Offset(0, 3)),
                  ]),
              child: Center(
                child: Text(
                  task.nameCatTwo,
                  style: LamaTextTheme.getStyle(color: LamaColors.white, fontSize: 30,),
                ),
              ),
            )
          ],
        ),
      ),
      // Done Button
      Container(
        height: (constraints.maxHeight / 100) * 8,
        alignment: Alignment.bottomCenter,
        padding: EdgeInsets.only(top: 5),
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
                style: LamaTextTheme.getStyle(color: LamaColors.white, fontSize: 30,),
              ),
            ),
          ),
        ),
      )





    ],);
  }
  
}