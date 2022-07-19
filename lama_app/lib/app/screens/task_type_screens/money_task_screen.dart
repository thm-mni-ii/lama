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
import 'package:collection/collection.dart';
import 'dart:math';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:lama_app/app/state/home_screen_state.dart';
import 'package:lama_app/app/event/tts_event.dart';
import 'package:lama_app/app/state/tts_state.dart';
import 'package:lama_app/app/bloc/taskBloc/tts_bloc.dart';
import 'package:lama_app/app/state/QuestionText.dart';



/// This file creates the Money task Screen
/// The Money Task is used to learn the calculating with money.
/// Euro Coins (2€, 1€, 0.5€, 0.2€, 0.1€, 5cent, 2cent, 1cent) will be displayed
/// on the Screen. By touching the coin the the Value of the coin will be stored.
/// The goal is to gather the asked amount of money by tapping on the right coins.
///
/// Author: T.Rentsch
/// latest Changes: 22.07.2021

/// Globale Variables
// currentAmountInt is used to Store the gathered amount of money

class MoneyTaskScreen extends StatefulWidget {
  final TaskMoney task;
  final BoxConstraints constraints;


  MoneyTaskScreen(this.task, this.constraints);

  @override
  State<StatefulWidget> createState() {
    return MoneyTaskState(task, constraints);
  }
}

/// MoneyTaskState class creates the Money Task Screen
class MoneyTaskState extends State<MoneyTaskScreen> {
  // task infos and constraints handed over by tasktypeScreen
  final TaskMoney task;
  final BoxConstraints constraints;
  // Value which is checked after pressing the "fertig" Button
  int? finalMoneyAmount;
  // Stores the pressed coins
  // needed for the undo button
  List<int> deletions = [];
  int currentAmountInt = 0;
  //index maps to coins => 2€ = 0 1 € = 1, usw..
  List<int> amounts = [0, 0, 0, 0, 0, 0, 0, 0];
  int i = 0;
  bool? answer;
  var random = Random();
  var rnd;
  int? moneyAmount;
  late int maxAmount;
  late String moneyAmountText;
  int minCount = 0;
  int tempAmount = 0;
  int questionRead = 0;
  bool alreadySaid = false;

  MoneyTaskState(this.task, this.constraints) {
    finalMoneyAmount = currentAmountInt;
    maxAmount = 10 * 100;
    rnd = random.nextInt(maxAmount);
    if (task.difficulty == 1) {
      rnd = (random.nextInt(20) + 1) * 50;
    }
    if (task.difficulty == 2) {
      rnd = (random.nextInt(100) + 1) * 10;
    }
    if (task.difficulty == 3) {
      rnd = (random.nextInt(1000) + 1);
    }

    this.moneyAmount = rnd;

    while (this.moneyAmount != this.tempAmount) {
      if ((this.moneyAmount! - this.tempAmount) >= 200) {
        this.tempAmount += 200;
        ++minCount;
      } else if ((this.moneyAmount! - this.tempAmount) >= 100) {
        this.tempAmount += 100;
        ++minCount;
      } else if ((this.moneyAmount! - this.tempAmount) >= 50) {
        this.tempAmount += 50;
        ++minCount;
      } else if ((this.moneyAmount! - this.tempAmount) >= 20) {
        this.tempAmount += 20;
        ++minCount;
      } else if ((this.moneyAmount! - this.tempAmount) >= 10) {
        this.tempAmount += 10;
        ++minCount;
      } else if ((this.moneyAmount! - this.tempAmount) >= 5) {
        this.tempAmount += 5;
        ++minCount;
      } else if ((this.moneyAmount! - this.tempAmount) >= 2) {
        this.tempAmount += 2;
        ++minCount;
      } else if ((this.moneyAmount! - this.tempAmount) >= 1) {
        this.tempAmount += 1;
        ++minCount;
      } else {
        break;
      }
    }

    int length = moneyAmount.toString().length;
    if (length == 2) {
      moneyAmountText = "0";
      moneyAmountText = moneyAmountText +
          this
              .moneyAmount
              .toString()
              .substring(0, this.moneyAmount.toString().length - length) +
          "," +
          this.moneyAmount.toString().substring(
              this.moneyAmount.toString().length - length,
              this.moneyAmount.toString().length);
    } else if (length == 1) {
      moneyAmountText = "0";
      moneyAmountText = moneyAmountText +
          this
              .moneyAmount
              .toString()
              .substring(0, this.moneyAmount.toString().length - length) +
          ",0" +
          this.moneyAmount.toString().substring(
              this.moneyAmount.toString().length - length,
              this.moneyAmount.toString().length);
    } else {
      moneyAmountText = "";
      moneyAmountText = moneyAmountText +
          this
              .moneyAmount
              .toString()
              .substring(0, this.moneyAmount.toString().length - 2) +
          "," +
          this.moneyAmount.toString().substring(
              this.moneyAmount.toString().length - 2,
              this.moneyAmount.toString().length);
    }
  }

  @override
  Widget build(BuildContext context) {
    String qlang;
    task.questionLanguage == null || task.questionLanguage == "" || task.questionLanguage == "Deutsch" ? qlang = "Deutsch" : qlang = "Englisch";
    final sum = amounts.sum;
    tempAmount = 0;
    String text = task.optimum!  ?
    "Sammle $moneyAmountText€ mit so wenig Münzen wie möglich zusammen!"
        : "Sammle $moneyAmountText€ mit den Münzen zusammen!";

    return BlocProvider(
  create: (context) => TTSBloc(),
  child: Column(children: [
      // Lama Speechbubble
      Container(
        height: (constraints.maxHeight / 100) * 20,
        padding: EdgeInsets.only(left: 15, right: 15),
        // create space between each child
        child: Stack(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: BlocBuilder<TTSBloc, TTSState>(
                builder: (context, state) {
                  if (state is EmptyTTSState && !alreadySaid) {
                    context.read<TTSBloc>().add(
                    AnswerOnInitEvent(text,qlang));
                    QuestionText.setText(text, qlang);
                    alreadySaid = true;
                  }
                  return Container(
                padding: EdgeInsets.only(left: 75),
                height: 50,
                width: MediaQuery.of(context).size.width,
                child: Bubble(
                  nip: BubbleNip.leftCenter,
                  child: Center(
                    child: Text(
                      task.optimum!
                          ? "Sammle $moneyAmountText€ mit so wenig Münzen wie möglich zusammen!"
                          : "Sammle $moneyAmountText€ mit den Münzen zusammen!",
                      style: LamaTextTheme.getStyle(
                          color: LamaColors.black, fontSize: 15),
                    ),
                  ),
                ),
              );
  },
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
      //Coin Display 2, 1, 50, 20
      Container(
        height: (constraints.maxHeight / 100) * 25,
        //color: LamaColors.orangeAccent,
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              InkWell(
                child: Container(
                  height: (constraints.maxHeight / 100) * 20,
                  child: Stack(alignment: Alignment.centerRight, children: [
                    SvgPicture.asset(
                      (false)
                          ? "assets/images/svg/EuroCoins/2_Euro.svg"
                          : (false)
                              ? "assets/images/svg/EuroCoins/2_Euro.svg"
                              : "assets/images/svg/EuroCoins/2_Euro.svg",
                      semanticsLabel: "Zwei Euro",
                      width: (constraints.maxWidth / 100) * 25,
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Text(
                        amounts[0].toString(),
                        style: LamaTextTheme.getStyle(color: LamaColors.black),
                      ),
                    ),
                  ]),
                ),
                onTap: () {
                  setState(() {
                    deletions.add(200);
                    amounts[0]++;
                    currentAmountInt = currentAmountInt + 200;
                    currentAmountInt = int.parse(currentAmountInt.toString());
                  });
                },
              ),
              InkWell(
                child: Container(
                  height: (constraints.maxHeight / 100) * 20,
                  child: Stack(alignment: Alignment.centerRight, children: [
                    // SvgPicture.asset(
                    //   "assets/images/jpg/5euro.jpg",
                    //   semanticsLabel: "Ein Euro",
                    //   width: (constraints.maxWidth / 100) * 23,
                    //),
                    // (task.difficulty == 3)
                    //     ? Image.asset(
                    //         "assets/images/jpg/5_Euro.jpg",
                    //         width: (constraints.maxWidth / 100) * 23,
                    //       ) :
                    SvgPicture.asset(
                      "assets/images/svg/EuroCoins/1_Euro.svg",
                      semanticsLabel: "Ein Euro",
                      width: (constraints.maxWidth / 100) * 23,
                    ),

                    Align(
                      alignment: Alignment.bottomRight,
                      child: Text(
                        amounts[1].toString(),
                        style: LamaTextTheme.getStyle(color: LamaColors.black),
                      ),
                    ),
                  ]),
                ),
                onTap: () {
                  setState(() {
                    deletions.add(100);
                    amounts[1]++;
                    // (task.difficulty == 3)
                    //     ? currentAmountInt = currentAmountInt + 5 :
                    currentAmountInt = currentAmountInt + 100;
                    currentAmountInt = int.parse(currentAmountInt.toString());
                  });
                },
              ),
              InkWell(
                child: Container(
                  height: (constraints.maxHeight / 100) * 20,
                  child: Stack(
                    alignment: Alignment.centerRight,
                    children: [
                      SvgPicture.asset(
                        "assets/images/svg/EuroCoins/50_Cent.svg",
                        semanticsLabel: "Fünfzig Cent",
                        width: (constraints.maxWidth / 100) * 23,
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Text(
                          amounts[2].toString(),
                          style:
                              LamaTextTheme.getStyle(color: LamaColors.black),
                        ),
                      ),
                    ],
                  ),
                ),
                onTap: () {
                  setState(() {
                    deletions.add(50);
                    amounts[2]++;
                    currentAmountInt = currentAmountInt + 50;
                    currentAmountInt = int.parse(currentAmountInt.toString());
                  });
                },
              ),
              InkWell(
                child: Container(
                  height: (constraints.maxHeight / 100) * 20,
                  child: Stack(alignment: Alignment.centerRight, children: [
                    SvgPicture.asset(
                      "assets/images/svg/EuroCoins/20_Cent.svg",
                      semanticsLabel: "Zwanzig Cent",
                      width: (constraints.maxWidth / 100) * 20,
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Text(
                        amounts[3].toString(),
                        style: LamaTextTheme.getStyle(color: LamaColors.black),
                      ),
                    ),
                  ]),
                ),
                onTap: () {
                  setState(() {
                    deletions.add(20);
                    amounts[3]++;
                    currentAmountInt = currentAmountInt + 20;
                    currentAmountInt = int.parse(currentAmountInt.toString());
                  });
                },
              ),
            ],
          ),
        ),
      ),
      //Coin Display 10, 5, 2, 1
      Container(
        height: (constraints.maxHeight / 100) * 20,
        padding: EdgeInsets.only(bottom: 20),
        //color: LamaColors.orangeAccent,
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              InkWell(
                child: Container(
                  height: (constraints.maxWidth / 100) * 20,
                  width: (constraints.maxWidth / 100) * 25,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      SvgPicture.asset(
                        "assets/images/svg/EuroCoins/10_Cent.svg",
                        semanticsLabel: "Zehn Cent",
                        width: (constraints.maxWidth / 100) * 20,
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Text(
                          amounts[4].toString(),
                          style:
                              LamaTextTheme.getStyle(color: LamaColors.black),
                        ),
                      ),
                    ],
                  ),
                ),
                onTap: () {
                  setState(() {
                    deletions.add(10);
                    amounts[4]++;
                    currentAmountInt = currentAmountInt + 10;
                    currentAmountInt = int.parse(currentAmountInt.toString());
                  });
                },
              ),
              InkWell(
                child: Container(
                  height: (constraints.maxWidth / 100) * 20,
                  width: (constraints.maxWidth / 100) * 23,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      SvgPicture.asset(
                        "assets/images/svg/EuroCoins/5_Cent.svg",
                        semanticsLabel: "Fünf Cent",
                        width: (constraints.maxWidth / 100) * 19,
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Text(
                          amounts[5].toString(),
                          style:
                              LamaTextTheme.getStyle(color: LamaColors.black),
                        ),
                      ),
                    ],
                  ),
                ),
                onTap: () {
                  setState(() {
                    deletions.add(5);
                    amounts[5]++;
                    currentAmountInt = currentAmountInt + 5;
                    currentAmountInt = int.parse(currentAmountInt.toString());
                  });
                },
              ),
              InkWell(
                child: Container(
                  height: (constraints.maxWidth / 100) * 20,
                  width: (constraints.maxWidth / 100) * 23,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      SvgPicture.asset(
                        "assets/images/svg/EuroCoins/2_Cent.svg",
                        semanticsLabel: "Zwei Cent",
                        width: (constraints.maxWidth / 100) * 16,
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Text(
                          amounts[6].toString(),
                          style:
                              LamaTextTheme.getStyle(color: LamaColors.black),
                        ),
                      ),
                    ],
                  ),
                ),
                onTap: () {
                  setState(() {
                    deletions.add(2);
                    amounts[6]++;
                    currentAmountInt = currentAmountInt + 2;
                    currentAmountInt = int.parse(currentAmountInt.toString());
                  });
                },
              ),
              InkWell(
                child: Container(
                  height: (constraints.maxWidth / 100) * 20,
                  width: (constraints.maxWidth / 100) * 20,
                  child: Stack(alignment: Alignment.center, children: [
                    SvgPicture.asset(
                      "assets/images/svg/EuroCoins/1_Cent.svg",
                      semanticsLabel: "Ein Cent",
                      width: (constraints.maxWidth / 100) * 13,
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Text(
                        amounts[7].toString(),
                        style: LamaTextTheme.getStyle(color: LamaColors.black),
                      ),
                    ),
                  ]),
                ),
                onTap: () {
                  setState(() {
                    deletions.add(1);
                    amounts[7]++;
                    currentAmountInt = currentAmountInt + 1;
                    currentAmountInt = int.parse(currentAmountInt.toString());
                  });
                },
              ),
            ],
          ),
        ),
      ),
      // reset and finish Button
      Container(
        height: (constraints.maxHeight / 100) * 20,
        child: Align(
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              //undo button
              Container(
                height: (constraints.maxHeight / 100) * 12,
                width: (constraints.maxWidth / 100) * 35,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    color: LamaColors.redAccent,
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 1,
                          blurRadius: 7,
                          offset: Offset(0, 3)),
                    ]),
                child: InkWell(
                  child: IconButton(
                    padding: EdgeInsets.all(1.0),
                    icon: Icon(
                      Icons.replay_rounded,
                      size: 40,
                    ),
                    color: LamaColors.white,
                    onPressed: () {
                      setState(() {
                        if (deletions.isNotEmpty) {
                          currentAmountInt = currentAmountInt - deletions.last;
                          int deletedElement = deletions.removeLast();
                          updateAmount(deletedElement);
                        } else {
                          ScaffoldMessenger.of(context).removeCurrentSnackBar();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Container(
                                    height: (constraints.maxHeight / 100) * 4,
                                    alignment: Alignment.bottomCenter,
                                    child: Center(
                                        child: FittedBox(
                                      fit: BoxFit.fitWidth,
                                      child: Text(
                                        "Füge zuerst einen Betrag hinzu",
                                        style: LamaTextTheme.getStyle(),
                                        textAlign: TextAlign.center,
                                      ),
                                    ))),
                                backgroundColor: LamaColors.mainPink,
                                duration: Duration(seconds: 1)),
                          );
                        }
                      });
                    },
                  ),
                ),
              ),
              //fertig button
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
                child: InkWell(
                  child: Center(
                    child: Text(
                      "Fertig",
                      style: LamaTextTheme.getStyle(
                          fontSize: 25,
                          color: LamaColors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  onTap: () {
                    finalMoneyAmount = currentAmountInt;
                    currentAmountInt = 0;
                    tempAmount = 0;
                    deletions.clear();
                    print("finalmoneyamount: $finalMoneyAmount");
                    print(
                        "finalMoneyAmount.toStringAsFixed(2): $finalMoneyAmount.toStringAsFixed(2)");
                    print("moneyAmount: $moneyAmount");
                    if (task.optimum == true) {
                      if ((this.finalMoneyAmount.toString()) ==
                              (this.moneyAmount.toString()) &&
                          sum == minCount) {
                        answer = true;
                        print("correct");
                      } else {
                        answer = false;
                        print("false");
                      }
                    } else {
                      if ((this.finalMoneyAmount.toString()) ==
                          (this.moneyAmount.toString())) {
                        answer = true;
                        print("correct");
                      } else {
                        answer = false;
                        print("false");
                      }
                    }

                    // (finalMoneyAmount.toStringAsFixed(2) == moneyAmount) ? answer = true : answer = false;
                    BlocProvider.of<TaskBloc>(context)
                        .add(AnswerTaskEvent.initMoneyTask(answer));
                  },
                ),
              )
            ],
          ),
        ),
      ),
    ]),
);
  }

  /// updateAmount is used to refresh the coin press counter
  /// after undoing a tapp the counter of the last tapped coin needs to be decrement
  /// {@param} double [deletedElement] indicates which coin got pressed last
  updateAmount(deletedElement) {
    if (deletedElement == 200) {
      amounts[0]--;
    } else if (deletedElement == 100) {
      amounts[1]--;
    } else if (deletedElement == 50) {
      amounts[2]--;
    } else if (deletedElement == 20) {
      amounts[3]--;
    } else if (deletedElement == 10) {
      amounts[4]--;
    } else if (deletedElement == 5) {
      amounts[5]--;
    } else if (deletedElement == 2) {
      amounts[6]--;
    } else if (deletedElement == 1) {
      amounts[7]--;
    }
  }
}
