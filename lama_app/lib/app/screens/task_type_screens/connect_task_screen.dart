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

///This file creates the Connect task Screen
///The connect task is a task where two list of words gets showen on the screen
///which needs to be connected. The Words on the left side can be selected and
///connected with items on the right side. Connected Items will be showen in the
///same color. If everthing is connected the control of results can be started by pushing
///the "fertig" button.
///
/// Author: T.Rentsch
/// latest Changes: 10.07.2021

/// ConnectTaskScreen class is made to create the Connecttasksreen
/// StatefulWidget is extended to get the Method setState
class ConnectTaskScreen extends StatefulWidget {
  final TaskConnect task;
  final BoxConstraints constraints;
  ConnectTaskScreen(this.task, this.constraints);
  @override
  State<StatefulWidget> createState() {
    return ConnectState(task, constraints);
  }
}

/// ConnectState class creates the Conect task Screen
class ConnectState extends State<ConnectTaskScreen> {
  // task infos and constraints handed over by tasktypeScreen
  final TaskConnect task;
  final BoxConstraints constraints;
  // Both lists stores the word which needs to be written on the Screen
  List<Item> leftWords = [];
  List<Item> rightWords = [];
  // List colors is needed to pass the colors to the single items
  List<Color> colors = [
    LamaColors.redPrimary,
    LamaColors.orangePrimary,
    LamaColors.greenPrimary,
    LamaColors.bluePrimary
  ];
  // leftTouched indicates if a item on the left side is selected
  bool leftTouched = false;
  // choosenWord stores the Item which is selected
  Item choosenWord;

  ConnectState(this.task, this.constraints) {
    // shuffle every list to create a illusion of dynamic task designe
    task.pair1.shuffle();
    task.pair2.shuffle();
    colors.shuffle();
    int i = 0;
    // fill the left and right word lists with Item types
    task.pair1.forEach((element) {
      leftWords.add(Item(false, element.toString(), true, colors[i], task));
      i++;
    });
    task.pair2.forEach((element) {
      rightWords
          .add(Item(false, element.toString(), false, LamaColors.white, task));
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
        Container(
          // positioning answers on the screen
          child: Row(
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
                        _buildPair(index, leftWords),
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
                        _buildPair(index, rightWords),
                  )),
            ],
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
            onTap: () {
              bool noObjectConnected = true;
              rightWords.forEach((element) {
                if (element.shownColor != LamaColors.white) {
                  noObjectConnected = false;
                }
              });
              if (noObjectConnected) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  duration: Duration(seconds: 2),
                  content: Container(
                      height: (constraints.maxHeight / 100) * 6,
                      alignment: Alignment.bottomCenter,
                      child: Center(
                          child: FittedBox(
                        fit: BoxFit.fitWidth,
                        child: Text(
                          "Verbinde mindestens ein Wort!",
                          style: LamaTextTheme.getStyle(),
                          textAlign: TextAlign.center,
                        ),
                      ))),
                  backgroundColor: LamaColors.mainPink,
                ));
              } else {
                bool answer = checkAnswer();
                print(answer);
                BlocProvider.of<TaskBloc>(context)
                    .add(AnswerTaskEvent.initConnect(answer));
              }
            },
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

  /// _buildPair is used by the Gridview Builder to build the Widgets shown left and right on the screen.
  /// The method gets called for the left and than for the right Items.
  /// int [index]           = Used to locate which item is used from the List
  /// List<Item> [itemList] = Is the list filled with either left or right Items
  Widget _buildPair(index, List<Item> itemList) {
    return InkWell(
      child: Container(
          height: 7,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(5)),
              color: itemList[index].shownColor,
              border: Border.all(color: LamaColors.black)),
          child: Center(
            child: Text(itemList[index].content,
                textAlign: TextAlign.center,
                style: LamaTextTheme.getStyle(
                    fontSize: 15, color: LamaColors.black)),
          )),
      // Used to call the touch method. Needs to be set for every single widget
      onTap: () {
        touch(index, itemList);
      },
    );
  }

  /// touch is called when one of the Items gets pressed on.
  /// The method decides based on which item got pressed, if the Item
  /// needs to be set to white + untouched or the provided color of one
  /// of the left items. After this, setState is called and the screen gets rebuilded
  /// int [index]           = Used to locate which item is used from the List
  /// List<Item> [itemList] = Is the list filled with either left or right Items
  void touch(int index, List<Item> itemlist) {
    // check if touched item is located left
    // If the touched Item is left, all items besides the choosen word
    // will be greyed out.
    if (itemlist[index].left) {
      leftTouched = true;
      choosenWord = itemlist[index];
      leftWords.forEach((element) {
        element.shownColor = Colors.grey;
        if (element.content == itemlist[index].content) {
          element.shownColor = element.color;
        }
      });
    }
    // if a right item got selected it gets checked if a left item got selected at first.
    // if yes the color of the item will be adjusted,
    // else a snackbar will be showen
    else {
      if (leftTouched) {
        // check if item got pressed bevore
        if (itemlist[index].touched) {
          itemlist[index].touched = false;
          // is the pressed item colored in a different color as the selected left Item
          // the color will be adjusted.
          // if its the same color, the item gets white to indicate it isn´t selected anymore
          if (itemlist[index].shownColor != choosenWord.shownColor) {
            itemlist[index].shownColor = choosenWord.color;
          } else {
            itemlist[index].shownColor = LamaColors.white;
          }
        }
        // is the item pressed for the first time, the color changes to the color of the
        // selected left Item
        else {
          itemlist[index].shownColor = choosenWord.color;
          itemlist[index].touched = true;
        }
      }
      // Snackbar which is shown if no left item is selected
      else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          duration: Duration(seconds: 2),
          content: Container(
              height: (constraints.maxHeight / 100) * 6,
              alignment: Alignment.bottomCenter,
              child: Center(
                  child: FittedBox(
                fit: BoxFit.fitWidth,
                child: Text(
                  "Wähle zuerst ein Wort von der linken Seite aus !",
                  style: LamaTextTheme.getStyle(),
                  textAlign: TextAlign.center,
                ),
              ))),
          backgroundColor: LamaColors.mainPink,
        ));
      }
    }
    setState(() {}); // rebuild whole screen
  }

  /// checkAnswer is used to compare the selected Answers with the provided Answers
  /// The function returns a bool for either correct (true) or incorrect (false)
  bool checkAnswer() {
    bool result = false; // because of saftyreasons the result is initially assumed to be wrong
    // because you can press the "fertig" button even when items on the left side are greyed out
    // we need to set every item on the left side back to its initial color
    leftWords.forEach((element) {
      element.shownColor = element.color;
    });
    // for every word on the left side the initial color is getting checked with the colors on
    // the right side. When the colors match the content of the right item will be added to the
    // answer list.
    // After that for each left item the answer list will be checked if "answer" and item.correctAnswers
    // are equal
    for (int i = 0; i < leftWords.length; i++) {
      List<String> answers = []; // stores the selected answers
      // check which words on the right have the same color
      rightWords.forEach((right) {
        if (leftWords[i].color == right.shownColor) {
          answers.add(right.content);
        }
      });
      // Check if the answer list ist bigger/shorter than the answer list in the item
      // because if this the case the result is automatically false
      if (answers.length > leftWords[i].correctAnswers.length ||
          answers.length < leftWords[i].correctAnswers.length) {
        result = false;
        return result;
      }
      // check if both list contain the same content
      for (int y = 0; y < answers.length; y++) {
        if (leftWords[i].correctAnswers.contains(answers[y])) {
          result = true;
        } else {
          result = false;
          return result;
        }
      }
      if (result == false) {
        return result;
      }
    }
    return result;
  }
}

/// Class Item represent each word Written on the left and right side of the Screen
/// bool [touched]    = indicator if item is currently selected
/// String [content]  = is the word written inside the Widget
/// bool [left]       = indicator if item is written on the left side of the screen
/// Color [color]     = is the given color from the constructor. It´s important so that if a
///                     Item from the left side changed its color to grey, it can remember its given color
/// Color [shownColor] = is the color which is shown on the Display
/// List<String> [correctAnswers] = to make the Answer validation easier each left Item stores its associated values(Answers)
class Item {
  bool touched;
  String content;
  bool left;
  Color color;
  Color shownColor = LamaColors.white;
  List<String> correctAnswers = [];

  Item(this.touched, this.content, this.left, this.color, TaskConnect task) {
    if (left) {
      // set the Color displayed on the screen to the given color from the constructor
      shownColor = color;
      // add the associated values to each "left" item
      task.rightAnswers.forEach((element) {
        List<String> tmp = element.split(":");
        if (tmp[0] == content) {
          tmp.remove(content);
          correctAnswers.addAll(tmp);
        }
      });
    }
  }
}
