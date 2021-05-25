import 'package:bubble/bubble.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lama_app/app/task-system/task.dart';
import 'package:lama_app/util/LamaColors.dart';
import 'package:lama_app/util/LamaTextTheme.dart';
bool firstStart = true;
bool firstShuffel = true;

class MatchCategoryTaskScreen extends StatefulWidget {
  final TaskMatchCategory task;
  final BoxConstraints constraints;

  MatchCategoryTaskScreen(this.task, this.constraints);

  @override
  State<StatefulWidget> createState() {
    return MatchCategoryState(task, constraints);
  }
}
class MatchCategoryState extends State<MatchCategoryTaskScreen>{
  final BoxConstraints constraints;
  final TaskMatchCategory task;
  final List<String> categorySum = [];
  final List<bool> results = [];

  String latestDeletion = "";
  List <String> deletinons = [];
  MatchCategoryState(this.task, this.constraints) {
    categorySum.addAll(task.categoryOne);
    categorySum.addAll(task.categoryTwo);
    if(firstShuffel) {
      categorySum.shuffle();
      firstShuffel = false;
    }
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
                child: Stack(children: generateItems()

                ))),
        //Category´s
        Container(
          height: (constraints.maxHeight / 100) * 12,
          //color: LamaColors.blueAccent,
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              buildTargets(context, task.categoryOne, task.nameCatOne, LamaColors.blueAccent),
              buildTargets(context, task.categoryTwo, task.nameCatTwo, LamaColors.orangeAccent)
              /*
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
              */
            ],
          ),
        ),
        // refreshButton
        Container(
          height: (constraints.maxHeight / 100) * 9,
          alignment: Alignment.bottomCenter,
           //color: Colors.green,
          child: Material(
          color: Colors.transparent,
           child: Ink(
             decoration: ShapeDecoration(
               color: LamaColors.blueAccent,
               shape: CircleBorder(),
               shadows: [BoxShadow(
                   color: Colors.grey.withOpacity(0.5),
                   spreadRadius: 2,
                   blurRadius: 7,
                   offset: Offset(0, 3)),
               ]
             ),
             padding: EdgeInsets.all(5.0),
           child: IconButton(
             padding: EdgeInsets.all(1.0),
              icon: Icon(
                Icons.refresh,
                size: 40,
              ),
             color: LamaColors.black,
             onPressed: (){
                setState(() {
                  if(deletinons.isNotEmpty){
                  results.removeLast();
                  categorySum.add(deletinons.last);
                  deletinons.removeLast();
                  print(results.toString());
                }});
             },
            ),
           ),
          )
        )
      ],
    );
  }

  List<Widget> generateItems() {
    List positions = [
      //Bottom , left
      [(constraints.maxHeight / 100) * 50, (constraints.maxWidth / 100) * 55],
      [(constraints.maxHeight / 100) * 45, (constraints.maxWidth / 100) * 10],
      [(constraints.maxHeight / 100) * 32, (constraints.maxWidth / 100) * 5],
      [(constraints.maxHeight / 100) * 38, (constraints.maxWidth / 100) * 50],
      [(constraints.maxHeight / 100) * 25, (constraints.maxWidth / 100) * 53],
      [(constraints.maxHeight / 100) * 2, (constraints.maxWidth / 100) * 58],
      [(constraints.maxHeight / 100) * 15, (constraints.maxWidth / 100) * 30,],
      [(constraints.maxHeight / 100) * 5, (constraints.maxWidth / 100) * 9]
    ];
    if(firstStart) {
      positions.shuffle();
      firstStart = false;
    }
    List<Widget> output = [];
    for(int i = 0; i < categorySum.length; i++){
      output.add(
        Positioned(
            bottom: positions[i][0],
            left: positions[i][1],
            child: Draggable(
                //data: task.categoryOne.contains(categorySum[i]) ? categoryType.catOne : categoryType.catTwo,
              data: categorySum[i],
              child: Container(
                height: 50,
                width: 150,
                decoration: BoxDecoration(
                  color: LamaColors.greenAccent,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 1,
                          blurRadius: 7,
                          offset: Offset(0, 3)),
                    ]
                ),
                child: Center(
                  child: Text(
                      categorySum[i],
                      style: LamaTextTheme.getStyle()
                  ),
                )
            ),
                feedback: Material(child: Container(
                    height: 50,
                    width: 150,
                    decoration: BoxDecoration(
                        color: LamaColors.mainPink,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 1,
                              blurRadius: 7,
                              offset: Offset(0, 3)),
                        ]
                    ),
                    child: Center(
                      child: Text(
                          categorySum[i],
                          style: LamaTextTheme.getStyle()
                      ),
                    )
                )),
              childWhenDragging: Container(
                  height: 50,
                  width: 150,
                  decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 1,
                            blurRadius: 7,
                            offset: Offset(0, 3)),
                      ]
                  ),
                  child: Center(
                    child: Text(
                        categorySum[i],
                        style: LamaTextTheme.getStyle()
                    ),
                  )
              ),
            )),
      );
    }
    return output;
  }
  Widget buildTargets(BuildContext context, List<String> categoryList , String taskCategory, Color color){
      return DragTarget(
          builder: (context, candidate, rejectedData) =>
              Container(
                height: 60,
                width: 185,
                decoration:
                BoxDecoration(color: color, boxShadow: [
                  BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 1,
                      blurRadius: 7,
                      offset: Offset(0, 3)),
                ]),
                child: Center(
                  child: Text(
                    taskCategory,
                    style: LamaTextTheme.getStyle(
                      color: LamaColors.white,
                      fontSize: 30,
                    ),
                  ),
                ),
              ),
        onWillAccept: (data)=> true,
        onAccept: (data){
          categoryList.contains(data) ?  results.add(true) :  results.add(false);
            setState(() {
              deletinons.add(data.toString());
              categorySum.removeWhere((element) =>
              element.toString() == data.toString());
              print(results.toString());
            });
      },
      );
  }
}
