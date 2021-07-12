import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lama_app/app/bloc/taskBloc/gridselecttask_bloc.dart';
import 'package:lama_app/app/bloc/task_bloc.dart';
import 'package:lama_app/app/event/task_events.dart';
import 'package:lama_app/app/screens/task_type_screens/cloze_test_task_screen.dart';
import 'package:lama_app/app/screens/task_type_screens/connect_task_screen.dart';
import 'package:lama_app/app/screens/task_type_screens/four_card_task_screen.dart';
import 'package:lama_app/app/screens/task_type_screens/grid_select_task_screen.dart';
import 'package:lama_app/app/screens/task_type_screens/mark_words_task_screen.dart';
import 'package:lama_app/app/screens/task_type_screens/match_Category_task_screen.dart';
import 'package:lama_app/app/screens/task_type_screens/money_task_screen.dart';
import 'package:lama_app/app/screens/task_type_screens/vocable_test_task_screen.dart';
import 'package:lama_app/app/state/task_state.dart';
import 'package:lama_app/app/task-system/task.dart';
import 'package:lama_app/util/LamaColors.dart';
import 'package:lama_app/util/LamaTextTheme.dart';

class TaskScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => TaskScreenState();
}

class TaskScreenState extends State<TaskScreen> {
  void initState() {
    super.initState();
    BlocProvider.of<TaskBloc>(context).add(ShowNextTaskEvent());
  }

  @override
  Widget build(BuildContext context) {
    LinearGradient lg;
    return BlocBuilder<TaskBloc, TaskState>(
      builder: (context, state) {
        if (state is DisplayTaskState) {
          SvgPicture coinImg = SvgPicture.asset(
              'assets/images/svg/lama_coin.svg',
              semanticsLabel: 'lama_coin');
          if (state.task != null && state.task.leftToSolve <= 0)
            coinImg = SvgPicture.asset('assets/images/svg/lama_coin_grey.svg',
                semanticsLabel: 'lama_coin_grey');
          switch (state.subject) {
            case "Mathe":
              lg = LinearGradient(
                  colors: [LamaColors.blueAccent, LamaColors.bluePrimary]);
              break;
            case "Englisch":
              lg = LinearGradient(
                  colors: [LamaColors.orangeAccent, LamaColors.orangePrimary]);
              break;
            case "Deutsch":
              lg = LinearGradient(
                  colors: [LamaColors.redAccent, LamaColors.redPrimary]);
              break;
            case "Sachkunde":
              lg = LinearGradient(
                  colors: [LamaColors.purpleAccent, LamaColors.purplePrimary]);
          }
          return Scaffold(
            resizeToAvoidBottomInset: false,
            body: Container(
              decoration: BoxDecoration(gradient: lg),
              child: SafeArea(
                child: Container(
                  color: LamaColors.white,
                  child: LayoutBuilder(
                    builder:
                        (BuildContext context, BoxConstraints constraints) {
                      return Column(children: [
                        Container(
                          height: (constraints.maxHeight / 100) * 7.5,
                          decoration: BoxDecoration(
                            gradient: lg,
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(25),
                              bottomRight: Radius.circular(25),
                            ),
                          ),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: IconButton(
                                  padding: EdgeInsets.all(0),
                                  icon: Icon(
                                    Icons.arrow_back,
                                    size: 40,
                                    color: LamaColors.white,
                                  ),
                                  onPressed: () => Navigator.of(context).pop(),
                                ),
                              ),
                              Text(state.subject,
                                  style: LamaTextTheme.getStyle(
                                      color: LamaColors.white,
                                      fontSize: 30,
                                      fontWeight: FontWeight.w500)),
                              Align(
                                alignment: Alignment.centerRight,
                                child: Padding(
                                  padding: EdgeInsets.only(right: 15),
                                  child: Container(
                                    height: (constraints.maxHeight / 100) * 5,
                                    width: (constraints.maxHeight / 100) * 5,
                                    child: coinImg,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                            height: (constraints.maxHeight / 100) * 92.5,
                            child: LayoutBuilder(builder: (BuildContext context,
                                BoxConstraints constraints) {
                              return getScreenForTaskWithConstraints(
                                  state.task, constraints);
                            }))
                      ]);
                    },
                  ),
                ),
              ),
            ),
          );
        } else if (state is TaskAnswerResultState) {
          if (state.correct) {
            if (state.subTaskResult == null) {
              return Container(
                color: LamaColors.white,
                child: Center(
                  child: Icon(
                    Icons.check,
                    size: 100,
                    color: LamaColors.greenAccent,
                  ),
                ),
              );
            } else {
              return Container(
                color: LamaColors.white,
                child: Column(
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height / 100 * 90,
                      child: Icon(
                        Icons.check,
                        size: 100,
                        color: LamaColors.greenAccent,
                      ),
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height / 100 * 10,
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: state.subTaskResult.length,
                        itemBuilder: (context, index) {
                          if (state.subTaskResult[index] == null) {
                            return CircleAvatar(
                              backgroundColor: Colors.grey,
                            );
                          } else if (!state.subTaskResult[index]) {
                            return CircleAvatar(
                              backgroundColor: LamaColors.redAccent,
                            );
                          } else if (state.subTaskResult[index]) {
                            return CircleAvatar(
                              backgroundColor: LamaColors.greenAccent,
                            );
                          }
                          return CircleAvatar(
                            backgroundColor: Colors.grey,
                          );
                        },
                        scrollDirection: Axis.horizontal,
                      ),
                    )
                  ],
                ),
              );
            }
          } else {
            if (state.subTaskResult == null) {
              return Container(
                color: LamaColors.white,
                child: Center(
                  child: Icon(
                    Icons.close,
                    size: 100,
                    color: LamaColors.redAccent,
                  ),
                ),
              );
            } else {
              return Container(
                color: LamaColors.white,
                child: Column(
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height / 100 * 90,
                      child: Icon(
                        Icons.close,
                        size: 100,
                        color: LamaColors.redAccent,
                      ),
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height / 100 * 10,
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: state.subTaskResult.length,
                        itemBuilder: (context, index) {
                          if (state.subTaskResult[index] == null) {
                            return CircleAvatar(
                              backgroundColor: Colors.grey,
                            );
                          } else if (!state.subTaskResult[index]) {
                            return CircleAvatar(
                              backgroundColor: LamaColors.redAccent,
                            );
                          } else if (state.subTaskResult[index]) {
                            return CircleAvatar(
                              backgroundColor: LamaColors.greenAccent,
                            );
                          }
                          return CircleAvatar(
                            backgroundColor: Colors.grey,
                          );
                        },
                        scrollDirection: Axis.horizontal,
                      ),
                    )
                  ],
                ),
              );
            }
          }
        } else if (state is AllTasksCompletedState) {
          return Scaffold(
            body: Container(
              color: LamaColors.mainPink,
              child: SafeArea(
                child: Container(
                  color: LamaColors.white,
                  child: LayoutBuilder(builder:
                      (BuildContext context, BoxConstraints constraints) {
                    return buildCompletionScreen(
                        state.tasks, state.answerResults, constraints);
                  }),
                ),
              ),
            ),
          );
        }
        return Text("No task passed");
      },
    );
  }

  //Task is the loaded Task and the constraints constrain the space
  // which the taskscreen can use to display its stuff
  Widget getScreenForTaskWithConstraints(
      Task task, BoxConstraints constraints) {
    switch (task.type) {
      case "4Cards":
        return FourCardTaskScreen(task, constraints);
      case "ClozeTest":
        return ClozeTestTaskScreen(task, constraints);
      case "MarkWords":
        return MarkWordsScreen(task, constraints);
      case "MatchCategory":
        return MatchCategoryTaskScreen(task, constraints);
      case "GridSelect":
        return GridSelectTaskScreen(task, constraints, GridSelectTaskBloc());
      case "MoneyTask":
        return MoneyTaskScreen(task, constraints);
      case "VocableTest":
        return VocableTestTaskScreen(task, constraints);
      case "Connect":
        return ConnectTaskScreen(task, constraints);
      default:
        return Container();
    }
  }

  Widget buildCompletionScreen(
      List<Task> tasks, List<bool> results, BoxConstraints constraints) {
    int rightAnswers = 0;
    int coinsEarned = 0;
    for (int i = 0; i < results.length; i++) {
      if (results[i]) {
        rightAnswers++;
        if (tasks[i].leftToSolve > -1) coinsEarned += tasks[i].reward;
      }
    }
    return Column(
      children: [
        Container(
          height: (constraints.maxHeight / 100) * 10,
          decoration: BoxDecoration(
            color: LamaColors.mainPink,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(25),
              bottomRight: Radius.circular(25),
            ),
            boxShadow: [
              BoxShadow(
                  offset: Offset(0, 1),
                  color: LamaColors.black.withOpacity(0.5))
            ],
          ),
          child: Center(
            child: Text("Abschlussbericht", style: LamaTextTheme.getStyle()),
          ),
        ),
        Container(
          height: (constraints.maxHeight / 100) * 55,
          child: Padding(
            padding: const EdgeInsets.only(left: 10, right: 5),
            child: Scrollbar(
              isAlwaysShown: true,
              child: ListView.separated(
                  itemBuilder: (context, index) {
                    return buildListItem(
                        index, constraints, results[index], tasks[index]);
                  },
                  separatorBuilder: (builder, index) {
                    return SizedBox(
                        height: (constraints.maxHeight / 100) * 2.5);
                  },
                  itemCount: tasks.length),
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(
                color: LamaColors.mainPink,
                width: 3,
              ),
            ),
          ),
          height: (constraints.maxHeight / 100) * 20,
          width: constraints.maxWidth,
          child: Padding(
            padding: EdgeInsets.only(top: 10, left: 20, right: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Gesamt:",
                    style: LamaTextTheme.getStyle(color: LamaColors.black)),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Aufgaben richtig: ",
                          style: LamaTextTheme.getStyle(
                              color: LamaColors.black, fontSize: 20)),
                      Text(
                          rightAnswers.toString() +
                              "/" +
                              results.length.toString(),
                          style: LamaTextTheme.getStyle(
                              color: LamaColors.black, fontSize: 20)),
                    ]),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Münzen verdient: ",
                          style: LamaTextTheme.getStyle(
                              color: LamaColors.black, fontSize: 20)),
                      Text(coinsEarned.toString(),
                          style: LamaTextTheme.getStyle(
                              color: LamaColors.black, fontSize: 20)),
                    ]),
              ],
            ),
          ),
        ),
        Container(
          height: (constraints.maxHeight / 100) * 15,
          child: Center(
            child: InkWell(
              child: Container(
                height: (constraints.maxHeight / 100) * 10,
                width: (constraints.maxWidth / 100) * 70,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(25),
                  ),
                  color: LamaColors.greenAccent,
                  boxShadow: [
                    BoxShadow(
                        offset: Offset(0, 2),
                        color: LamaColors.black.withOpacity(0.5))
                  ],
                ),
                child: Center(
                  child: Text(
                    "Fertig",
                    style: LamaTextTheme.getStyle(
                      fontSize: 30,
                    ),
                  ),
                ),
              ),
              onTap: () => Navigator.pop(context),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildListItem(
      int index, BoxConstraints constraints, bool result, Task task) {
    Icon icon = result
        ? Icon(Icons.check, color: LamaColors.greenAccent, size: 50)
        : Icon(Icons.close, color: LamaColors.redAccent, size: 50);
    Text coinText;
    if (result) {
      if (task.leftToSolve > -1)
        coinText = Text("+" + task.reward.toString(),
            style: LamaTextTheme.getStyle(color: LamaColors.greenAccent));
      else
        coinText =
            Text("+0", style: LamaTextTheme.getStyle(color: Colors.grey));
    } else {
      coinText = Text("+0",
          style: LamaTextTheme.getStyle(color: LamaColors.redAccent));
    }
    return Container(
      height: (constraints.maxHeight / 100) * 10,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text("Aufgabe " + (index + 1).toString(),
                style: LamaTextTheme.getStyle(
                    fontSize: 20, color: LamaColors.black)),
          ),
          icon,
          Align(
            alignment: Alignment.centerRight,
            child: Container(
                width: (constraints.maxWidth / 100) * 25,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    coinText,
                    Container(
                      width: (constraints.maxWidth / 100) * 10,
                      child: SvgPicture.asset('assets/images/svg/lama_coin.svg',
                          semanticsLabel: 'lama_coins'),
                    ),
                  ],
                )),
          )
        ],
      ),
    );
  }
}
