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
  List<Color> colors = [
    LamaColors.redPrimary,
    LamaColors.orangePrimary,
    LamaColors.greenPrimary,
    LamaColors.bluePrimary
  ];
  bool leftTouched = false;
  Item choosenWord;

  ConnectState(this.task, this.constraints) {
    task.pair1.shuffle();
    task.pair2.shuffle();
    colors.shuffle();
    int i = 0;
    task.pair1.forEach((element) {
      leftWords.add(Item(false, element.toString(), true, colors[i], task));
      i++;
    });
    task.pair2.forEach((element) {
      rightWords.add(Item(false, element.toString(), false, LamaColors.white, task));
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
            onTap: (){
            bool answer = checkAnswer();
            print(answer);
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

  // Method to build possible answers
  Widget _buildPair(context, index, List<Item> itemList) {
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
      onTap: () {
        touch(index, itemList);
      },
    );
  }

  void touch(int index, List<Item> itemlist) {
    if (itemlist[index].left) {
      if (leftTouched) {
        leftTouched = false;
        leftWords.forEach((element) {
          element.shownColor = element.color;
        });
        rightWords.forEach((element) {
          element.touched = false;
        });
      }
      else {
        leftTouched = true;
        choosenWord = itemlist[index];
        leftWords.forEach((element) {
          element.shownColor = Colors.grey;
          if (element.content == itemlist[index].content) {
            element.shownColor = element.color;
          }
        });
      }
    }
    else {
      if (leftTouched) {
        if (itemlist[index].touched) {
          itemlist[index].touched = false;
          if(itemlist[index].shownColor != choosenWord.shownColor){
            itemlist[index].shownColor = choosenWord.color;
          }
          else {
            itemlist[index].shownColor = LamaColors.white;
          }
        }
        else {
          itemlist[index].shownColor = choosenWord.color;
          itemlist[index].touched = true;
        }
      }
      else {
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
                          "Wähle zuerst ein Wort von der linken Seite aus !",
                          style: LamaTextTheme.getStyle(),
                          textAlign: TextAlign.center,
                        ),
                      ))),
              backgroundColor: LamaColors.mainPink,
            ));
      }
    }
    setState(() {});
  }

  bool checkAnswer(){
    bool result = false;
      for(int i = 0; i < leftWords.length; i++){
      List<String> answers = [];
      rightWords.forEach((right) {
        if(leftWords[i].color == right.shownColor){
          answers.add(right.content);
        }
      });
      if(answers.length > leftWords[i].correctAnswers.length || answers.length < leftWords[i].correctAnswers.length){
        result = false;
        return result;
      }

        for(int y = 0; y < answers.length; y++){
        if(leftWords[i].correctAnswers.contains(answers[y])){
          result = true;
        }
        else{
          result = false;
          return result;
        }
      }
      if(result == false){
        return result;
      }
    }
      return result;
  }
}

class Item {
  bool touched;
  String content;
  bool left;
  Color color;
  Color shownColor = LamaColors.white;
  List<String> correctAnswers = [];

  Item(this.touched, this.content, this.left, this.color, TaskConnect task) {
    if(left){
      shownColor = color;

      task.rightAnswers.forEach((element) {
        List<String> tmp = element.split(":");
        if(tmp[0] == content){
          tmp.remove(content);
          correctAnswers.addAll(tmp);
        }
      });
      }


    }
  }


