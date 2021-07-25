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

/// This file creates the Match Category task Screen
/// The Match Category task is a task where you have to sort 8 given
/// words into one of the given Topics with drag and drop.
/// The items will be randomly selected and placed on the Screen. After dropping
/// the last word from the screen into a Topic, the answers will be checked.
///
///
/// Author: T.Rentsch
/// latest Changes: 22.07.2021

/// Global Variables
// Flag to check if the screen is build for the first time
bool firstStart = true;
// Flag to check if the words have been shuffled or not
bool firstShuffel = true;
// List of all created Items

/// MatchCategoryTaskScreen class creates the Match Category Task Screen
class MatchCategoryTaskScreen extends StatefulWidget {
  final TaskMatchCategory task;
  final BoxConstraints constraints;
  MatchCategoryTaskScreen(this.task, this.constraints);

  @override
  State<StatefulWidget> createState() {
    return MatchCategoryState(task, constraints);
  }
}

class MatchCategoryState extends State<MatchCategoryTaskScreen> {
  // task infos and constraints handed over by tasktypeScreen
  final BoxConstraints constraints;
  final TaskMatchCategory task;
  // List of all handed words
  final List<String> categorySum = [];
  // List to save the results of every drag and drop
  final List<bool> results = [];
  // To recreate the latest Item we need to Save which item was deleted
  String latestDeletion = "";
  // This List contains all Items which have already been draged
  List<Item> deletinons = [];

  List<Item> items = [];

  MatchCategoryState(this.task, this.constraints) {
    // Add all given words to categorySum
    /*categorySum.clear();
    categorySum.addAll(task.categoryOne);
    categorySum.addAll(task.categoryTwo);
    // If its the first screen Build we need to Shuffle the list
    if (firstShuffel) {
      categorySum.shuffle();
      firstShuffel = false;
    }*/
  }

  @override
  void initState() {
    super.initState();
    categorySum.clear();
    categorySum.addAll(task.categoryOne);
    categorySum.addAll(task.categoryTwo);
    // If its the first screen Build we need to Shuffle the list
    categorySum.shuffle();
    items.clear();
    firstStart = true;
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
              buildTargets(context, task.categoryOne, task.nameCatOne,
                  LamaColors.blueAccent),
              buildTargets(context, task.categoryTwo, task.nameCatTwo,
                  LamaColors.orangeAccent)
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
                    shadows: [
                      BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 7,
                          offset: Offset(0, 3)),
                    ]),
                padding: EdgeInsets.all(5.0),
                child: IconButton(
                  padding: EdgeInsets.all(1.0),
                  icon: Icon(
                    Icons.refresh,
                    size: 40,
                  ),
                  color: LamaColors.black,
                  onPressed: () {
                    setState(() {
                      if (deletinons.isNotEmpty) {
                        results.removeLast();
                        items.add(deletinons.last);
                        deletinons.removeLast();
                      } else if (deletinons.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Container(
                                height: (constraints.maxHeight / 100) * 4,
                                alignment: Alignment.bottomCenter,
                                child: Center(
                                    child: FittedBox(
                                  fit: BoxFit.fitWidth,
                                  child: Text(
                                    "Kein Item zum zurücksetzen gefunden",
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
            ))
      ],
    );
  }

  /// generateItems is Used to create every draggable Item displayed on the Screen.
  /// Every Item gets a unique position on the screen and is builded.
  /// After this the Item gets added to the output list.
  /// {@return} a List of [Widget]
  List<Widget> generateItems() {
    // Array of every possible position on the Screen [[Bottom, Left], ..]
    // There are only 8 possible position without overflowing, so the the Limit of
    // items displayed is 8
    List positions = [
      [(constraints.maxHeight / 100) * 50, (constraints.maxWidth / 100) * 55],
      [(constraints.maxHeight / 100) * 45, (constraints.maxWidth / 100) * 7],
      [(constraints.maxHeight / 100) * 32, (constraints.maxWidth / 100) * 5],
      [(constraints.maxHeight / 100) * 38, (constraints.maxWidth / 100) * 50],
      [(constraints.maxHeight / 100) * 25, (constraints.maxWidth / 100) * 53],
      [(constraints.maxHeight / 100) * 3, (constraints.maxWidth / 100) * 56],
      [
        (constraints.maxHeight / 100) * 15,
        (constraints.maxWidth / 100) * 30,
      ],
      [(constraints.maxHeight / 100) * 5, (constraints.maxWidth / 100) * 9]
    ];
    // if the Screen is build for the first time
    // all Items become a random position
    if (firstStart) {
      positions.shuffle();
      firstStart = false;
      double bottom;
      double left;
      int length;
      // check if there are more than 8 Items in the list
      if (categorySum.length <= 8) {
        length = categorySum.length;
      } else {
        length = 8;
      }
      // save every Item with its unique position
      for (int x = 0; x < length; x++) {
        for (int y = 0; y < 2; y++) {
          if (y == 0) {
            bottom = positions[x][y];
          }
          if (y == 1) {
            left = positions[x][y];
          }
        }
        items.add(Item(bottom, left, categorySum[x]));
      }
    }
    // List to save the created Widgets
    List<Widget> output = [];
    // Create for every Item a widget
    for (int i = 0; i < items.length; i++) {
      output.add(
        Positioned(
            bottom: items[i].bottom,
            left: items[i].left,
            child: Draggable<Item>(
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
                      ]),
                  child: Center(
                    child: Text(items[i].item, style: LamaTextTheme.getStyle()),
                  )),
              feedback: Material(
                  child: Container(
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
                          ]),
                      child: Center(
                        child: Text(items[i].item,
                            style: LamaTextTheme.getStyle()),
                      ))),
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
                      ]),
                  child: Center(
                    child: Text(items[i].item, style: LamaTextTheme.getStyle()),
                  )),
            )),
      );
    }
    return output;
  }

  /// buildTargets is Used to create the dragtargets for the Items
  /// The method gets called for both Dragtargets.
  /// {@param} BuildContext [context] needed for constraints
  /// {@param} List<String> [categoryList] List of all Items accepted by this Target
  /// {@param} String [taskCategory] name of the Target
  /// {@param} Color [color] color of the Target
  ///
  /// {@return} [Widget] Targetwidget to be displayed on the screen
  Widget buildTargets(BuildContext context, List<String> categoryList,
      String taskCategory, Color color) {
    return DragTarget<Item>(
      builder: (context, candidate, rejectedData) => Container(
          height: (constraints.maxHeight / 100) * 45,
          width: (constraints.maxWidth / 100) * 45,
          decoration: BoxDecoration(
            color: color,
            boxShadow: [
              BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 1,
                  blurRadius: 7,
                  offset: Offset(0, 3)),
            ],
            borderRadius: BorderRadius.all(Radius.circular(5)),
          ),
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
      onWillAccept: (data) => true,
      onAccept: (data) {
        // Check if draged Item is contained in the Items for this Category
        categoryList.contains(data.item)
            ? results.add(true)
            : results.add(false);
        // reload screen
        setState(() {
          // After Draging the Item needs to be removed from the Screen
          deletinons.add(data);
          items.removeWhere((element) {
            return element.item == data.item;
          });
          // If the draged Item was the Last one on the Screen
          // reset all Variables and send the resluts to check
          if (items.isEmpty) {
            firstStart = true;
            BlocProvider.of<TaskBloc>(context)
                .add(AnswerTaskEvent.initMatchCategory(results));
          }
        });
      },
    );
  }
}

/// class Item used to store information of every given word
/// double [bottom] Used for positioning
/// double [left] Used for positioning
/// String [item] Stores item text given by TaskMatchCategory [task]
class Item {
  double bottom;
  double left;
  String item;
  Item(double bottom, left, String item) {
    this.bottom = bottom;
    this.left = left;
    this.item = item;
  }
}
