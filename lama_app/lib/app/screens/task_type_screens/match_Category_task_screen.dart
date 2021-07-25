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

bool firstStart = true;
bool firstShuffel = true;
List<Item> items =[];


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
  List <Item> deletinons = [];

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
            ],
          ),
        ),
        // refreshButton
        Container(
            height: (constraints.maxHeight / 100) * 10,
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
                        items.add(deletinons.last);
                        deletinons.removeLast();
                      }
                      else if(deletinons.isEmpty){
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content:
                            Container(
                                height: (constraints.maxHeight / 100) * 4,
                                alignment: Alignment.bottomCenter,
                                child: Center(
                                  child: FittedBox(
                                    fit: BoxFit.fitWidth,
                                  child: Text("Kein Item zum zurücksetzen gefunden",
                                    style: LamaTextTheme.getStyle(),
                                    textAlign: TextAlign.center,
                                  ),
                                ))),
                            backgroundColor: LamaColors.mainPink,
                          ),
                        );
                      }
                    });
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
      [(constraints.maxHeight / 100) * 45, (constraints.maxWidth / 100) * 7],
      [(constraints.maxHeight / 100) * 32, (constraints.maxWidth / 100) * 5],
      [(constraints.maxHeight / 100) * 38, (constraints.maxWidth / 100) * 50],
      [(constraints.maxHeight / 100) * 25, (constraints.maxWidth / 100) * 53],
      [(constraints.maxHeight / 100) * 3, (constraints.maxWidth / 100) * 56],
      [(constraints.maxHeight / 100) * 15, (constraints.maxWidth / 100) * 30,],
      [(constraints.maxHeight / 100) * 5, (constraints.maxWidth / 100) * 9]
    ];


    if(firstStart) {
      positions.shuffle();
      firstStart = false;
      double bottom;
      double left;
      for(int x = 0; x < categorySum.length; x++){
        for(int y = 0; y < 2; y++){
          if(y == 0){bottom = positions[x][y];}
          if(y == 1){left = positions[x][y];}
        }
        items.add(Item(bottom, left, categorySum[x]));
      }
      print(items.length);
    }

    List<Widget> output = [];
    for(int i = 0; i < items.length; i++){
      output.add(
        Positioned(
            bottom: items[i].bottom,
            left: items[i].left,
            child: Draggable<Item>(
              //data: task.categoryOne.contains(categorySum[i]) ? categoryType.catOne : categoryType.catTwo,
              data: items[i],
              child: Container(
                  height: (constraints.maxHeight / 100) * 8,
                  width: (constraints.maxWidth / 100) * 38,
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
                        items[i].item,
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
                        items[i].item,
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
                        items[i].item,
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
    return DragTarget<Item>(
      builder: (context, candidate, rejectedData) =>
          Container(
            height: (constraints.maxHeight / 100) * 45,
            width: (constraints.maxWidth / 100) * 45,
            decoration:
            BoxDecoration(color: color, boxShadow: [
              BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 1,
                  blurRadius: 7,
                  offset: Offset(0, 3)),
            ],
              borderRadius: BorderRadius.all(Radius.circular(5)),),
            child: Padding(
                padding: EdgeInsets.all(10),
            child: FittedBox(
              fit: BoxFit.fitWidth,
            child: Center(
              child: Text(
                taskCategory,
                style: LamaTextTheme.getStyle(
                  color: LamaColors.white,
                  fontSize: 30,
                ),
              ),
            ),
          ))),
      onWillAccept: (data)=> true,
      onAccept: (data){

        categoryList.contains(data.item) ?  results.add(true) :  results.add(false);
        setState(() {
          deletinons.add(data);

          items.removeWhere((element) {
            print(element.item);
            print(data.item);
            return element.item == data.item;
          });
          if(items.isEmpty){
            firstStart = true;
            firstShuffel = true;
            BlocProvider.of<TaskBloc>(context).add(AnswerTaskEvent.initMatchCategory(results));
          }
        });
      },
    );
  }
}
class Item{
  double bottom;
  double left;
  String item;
  Item(double bottom, left, String item){
    this.bottom =bottom;
    this.left = left;
    this.item = item;
  }
}
