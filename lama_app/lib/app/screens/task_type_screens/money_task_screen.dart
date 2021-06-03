import 'package:bubble/bubble.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lama_app/app/task-system/task.dart';
import 'package:lama_app/util/LamaColors.dart';
import 'package:lama_app/util/LamaTextTheme.dart';

double currentAmountDouble = 0;

class MoneyTaskScreen extends StatefulWidget {
  final TaskMoney task;
  final BoxConstraints constraints;

  MoneyTaskScreen(this.task, this.constraints);

  @override
  State<StatefulWidget> createState() {
    return MoneyTaskState(task, constraints);
  }
}

class MoneyTaskState extends State<MoneyTaskScreen> {
  final TaskMoney task;
  final BoxConstraints constraints;
  double finalMoneyAmount;

  //String currentAmountString;

  MoneyTaskState(this.task, this.constraints) {
    print(currentAmountDouble);
    finalMoneyAmount = task.moneyAmount;
    print(finalMoneyAmount.toStringAsFixed(2));
    //currentAmountString = currentAmountDouble.toString() + "€";
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      // Lama Speechbubble
      Container(
        height: (constraints.maxHeight / 100) * 20,
        padding: EdgeInsets.only(left: 15, right: 15),
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
      // Money Balance display
      Container(
        height: (constraints.maxHeight / 100) * 12,
        padding: EdgeInsets.only(top: 15),
        //color: LamaColors.greenAccent,
        child: Container(
          alignment: Alignment.bottomCenter,
          height: (constraints.maxHeight / 100) * 1,
          width: (constraints.maxHeight / 100) * 40,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(20)),
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
              currentAmountDouble.toStringAsFixed(2) + "€",
              style: LamaTextTheme.getStyle(
                  fontSize: 50,
                  color: LamaColors.white,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
      //2, 1, 50, 20
      Container(
        height: (constraints.maxHeight / 100) * 25,
        //color: LamaColors.orangeAccent,
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              InkWell(
                child: SvgPicture.asset(
                  "assets/images/svg/EuroCoins/2_Euro.svg",
                  semanticsLabel: "Zwei Euro",
                  width: 100,
                ),
                onTap: () {
                  setState(() {
                    currentAmountDouble = currentAmountDouble + 2;
                  });
                },
              ),
              InkWell(
                child: SvgPicture.asset(
                  "assets/images/svg/EuroCoins/1_Euro.svg",
                  semanticsLabel: "Ein Euro",
                  width: 90,
                ),
                onTap: () {
                  setState(() {
                    currentAmountDouble = currentAmountDouble + 1;
                  });
                },
              ),
              InkWell(
                child: SvgPicture.asset(
                  "assets/images/svg/EuroCoins/50_Cent.svg",
                  semanticsLabel: "Fünfzig Cent",
                  width: 90,
                ),
                onTap: () {
                  setState(() {
                    currentAmountDouble = currentAmountDouble + 0.5;
                  });
                },
              ),
              InkWell(
                child: SvgPicture.asset(
                  "assets/images/svg/EuroCoins/20_Cent.svg",
                  semanticsLabel: "Zwanzig Cent",
                  width: 80,
                ),
                onTap: () {
                  setState(() {
                    currentAmountDouble = currentAmountDouble + 0.2;
                  });
                },
              ),
            ],
          ),
        ),
      ),
      //10, 5, 2, 1
      Container(
        height: (constraints.maxHeight / 100) * 20,
        //color: LamaColors.orangeAccent,
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              InkWell(
                child: SvgPicture.asset(
                  "assets/images/svg/EuroCoins/10_Cent.svg",
                  semanticsLabel: "Zehn Cent",
                  width: 75,
                ),
                onTap: () {
                  setState(() {
                    currentAmountDouble = currentAmountDouble + 0.1;
                  });
                },
              ),
              InkWell(
                child: SvgPicture.asset(
                  "assets/images/svg/EuroCoins/5_Cent.svg",
                  semanticsLabel: "Fünf Cent",
                  width: 70,
                ),
                onTap: () {
                  setState(() {
                    currentAmountDouble = currentAmountDouble + 0.05;
                  });
                },
              ),
              InkWell(
                child: SvgPicture.asset(
                  "assets/images/svg/EuroCoins/2_Cent.svg",
                  semanticsLabel: "Zwei Cent",
                  width: 65,
                ),
                onTap: () {
                  setState(() {
                    currentAmountDouble = currentAmountDouble + 0.02;
                  });
                },
              ),
              InkWell(
                child: SvgPicture.asset(
                  "assets/images/svg/EuroCoins/1_Cent.svg",
                  semanticsLabel: "Ein Cent",
                  width: 55,
                ),
                onTap: () {
                  setState(() {
                    currentAmountDouble = currentAmountDouble + 0.01;
                  });
                },
              ),
            ],
          ),
        ),
      ),
      Container(
        height: (constraints.maxHeight / 100) * 20,
        child: Align(
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                height: (constraints.maxHeight / 100) * 12,
                width: (constraints.maxWidth / 100) * 35,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
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
                    "Reset",
                    style: LamaTextTheme.getStyle(
                        fontSize: 25,
                        color: LamaColors.white,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Container(
                height: (constraints.maxHeight / 100) * 12,
                width: (constraints.maxWidth / 100) * 35,
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
                child: Center(
                  child: Text(
                    "Fertig",
                    style: LamaTextTheme.getStyle(
                        fontSize: 25,
                        color: LamaColors.white,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    ]);
  }
}
