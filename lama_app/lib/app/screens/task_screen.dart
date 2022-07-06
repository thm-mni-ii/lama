import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lama_app/app/bloc/taskBloc/gridselecttask_bloc.dart';
import 'package:lama_app/app/bloc/task_bloc.dart';
import 'package:lama_app/app/event/task_events.dart';
import 'package:lama_app/app/event/tts_event.dart';
import 'package:lama_app/app/screens/task_type_screens/buchstabieren_task_screen.dart';
import 'package:lama_app/app/screens/task_type_screens/clock_task_screen.dart';
import 'package:lama_app/app/screens/task_type_screens/cloze_test_task_screen_stateful.dart';
import 'package:lama_app/app/screens/task_type_screens/connect_task_screen.dart';
import 'package:lama_app/app/screens/task_type_screens/equation_task_screen.dart';
import 'package:lama_app/app/screens/task_type_screens/four_card_task_screen_stateful.dart';
import 'package:lama_app/app/screens/task_type_screens/grid_select_task_screen.dart';
import 'package:lama_app/app/screens/task_type_screens/mark_words_task_screen.dart';
import 'package:lama_app/app/screens/task_type_screens/match_Category_task_screen.dart';
import 'package:lama_app/app/screens/task_type_screens/money_task_screen.dart';
import 'package:lama_app/app/screens/task_type_screens/number_line_task_screen.dart';
import 'package:lama_app/app/screens/task_type_screens/vocable_test_task_screen.dart';
import 'package:lama_app/app/screens/task_type_screens/zerlegung_task_screen.dart';
import 'package:lama_app/app/state/QuestionText.dart';
import 'package:lama_app/app/state/task_state.dart';
import 'package:lama_app/app/task-system/task.dart';
import 'package:lama_app/util/LamaColors.dart';
import 'package:lama_app/util/LamaTextTheme.dart';
import 'package:lama_app/app/state/tts_state.dart';
import 'package:lama_app/app/bloc/taskbloc/tts_bloc.dart';


import 'package:lama_app/app/screens/task_type_screens/buchstabieren_task_helper.dart';

///[StatefulWidget] for the screen framework containing the current Task Widget.
///
///Author: K.Binder
class TaskScreen extends StatefulWidget {
  final int? userGrade;
  TaskScreen([this.userGrade]);

  @override
  State<StatefulWidget> createState() => TaskScreenState(userGrade);
}

///[State] for the [TaskScreen]
///
///Author: K.Binder
class TaskScreenState extends State<TaskScreen> {
  int? randomNummer;
  Image? image;
  late TaskBuchstabieren task;
  int? userGrade;

  TaskScreenState([this.userGrade]);

  ///Loads the first Task of the list that was passed by
  ///the [ChooseTasksetScreen] during initialization.
  void initState() {
    super.initState();
    BlocProvider.of<TaskBloc>(context).add(ShowNextTaskEvent());
  }

  @override
  Widget build(BuildContext context) {
    LinearGradient? lg;
    return BlocBuilder<TaskBloc, TaskState>(
      builder: (context, state) {
        //State that signals a Task should be displayed
        if (state is DisplayTaskState) {
          SvgPicture coinImg = SvgPicture.asset(
              'assets/images/svg/Ton.svg',
              semanticsLabel: 'lama_coin');
          if (state.task != null && state.task.leftToSolve! <= 0)
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
                  colors: [LamaColors.orangeAccent, LamaColors.redPrimary]);
              break;
            case "Sachkunde":
              lg = LinearGradient(
                  colors: [LamaColors.purpleAccent, LamaColors.purplePrimary]);
              break;
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
                              Text(state.subject!,
                                  style: LamaTextTheme.getStyle(
                                      color: LamaColors.white,
                                      fontSize: 30,
                                      fontWeight: FontWeight.w500)),
                              BlocProvider(
                                create: (context) => TTSBloc(),
                                child: BlocBuilder<TTSBloc, TTSState>(
                                builder: (context, state) {
                                  return Align(
                                    alignment: Alignment.centerRight,
                                    child: InkWell(
                                        child: CircleAvatar(
                                          maxRadius: 21,
                                          child: SvgPicture.asset(
                                              'assets/images/svg/Ton.svg',
                                              semanticsLabel: 'TonIcon',
                                              color: LamaColors.purpleAccent
                                          ),
                                          backgroundColor: LamaColors.white,
                                        ),
                                        onTap: () =>
                                        {
                                          BlocProvider.of<TTSBloc>(context).
                                          add(ReadQuestion(QuestionText.getText(), QuestionText.getLang()))
                                        }
                                    ),
                                  );
                                }
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                            height: (constraints.maxHeight / 100) * 92.5,
                            //"TaskBox" that will be filled depending on
                            //the TaskType of the current Task
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
        }
        //State that signals a Task was answered and evaluated and a result is provided
        else if (state is TaskAnswerResultState) {
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
                        itemCount: state.subTaskResult!.length,
                        itemBuilder: (context, index) {
                          if (state.subTaskResult![index] == null) {
                            return CircleAvatar(
                              backgroundColor: Colors.grey,
                            );
                          } else if (!state.subTaskResult![index]!) {
                            return CircleAvatar(
                              backgroundColor: LamaColors.redAccent,
                            );
                          } else if (state.subTaskResult![index]!) {
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
                        itemCount: state.subTaskResult!.length,
                        itemBuilder: (context, index) {
                          if (state.subTaskResult![index] == null) {
                            return CircleAvatar(
                              backgroundColor: Colors.grey,
                            );
                          } else if (!state.subTaskResult![index]!) {
                            return CircleAvatar(
                              backgroundColor: LamaColors.redAccent,
                            );
                          } else if (state.subTaskResult![index]!) {
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
        }
        //State that signals that all Tasks have been completed and to show the summary
        else if (state is AllTasksCompletedState) {
          return Scaffold(
            body: Container(
              color: LamaColors.mainPink,
              child: SafeArea(
                child: Container(
                  color: LamaColors.white,
                  child: LayoutBuilder(builder:
                      (BuildContext context, BoxConstraints constraints) {
                    return buildCompletionScreen(
                        state.tasks!, state.answerResults, constraints);
                  }),
                ),
              ),
            ),
          );
        }
        return Container(
          color: LamaColors.white,
        );
      },
    );
  }

  ///Returns the Widget that corresponds to the TaskType of [task].
  ///
  ///Also passes the constraints of the "TaskBox" (see [build()])
  ///to allow the task screens to scale accordingly.
  Widget getScreenForTaskWithConstraints(
      Task task, BoxConstraints constraints) {
    switch (task.type) {
      case "4Cards":
        return FourCardTaskScreenStateful(task as Task4Cards, constraints);
      case "Zerlegung":
        return ZerlegungTaskScreen(
            task: task as TaskZerlegung?, constraints: constraints);
      case "NumberLine":
        return NumberLineTaskScreen(task as TaskNumberLine, constraints);
      case "ClozeTest":
        return ClozeTestTaskScreen(task as TaskClozeTest, constraints);
      case "Clock":
        return ClockTaskScreen(task as ClockTest, constraints);
      case "MarkWords":
        return MarkWordsScreen(task as TaskMarkWords, constraints);
      case "MatchCategory":
        return MatchCategoryTaskScreen(task as TaskMatchCategory, constraints);
      case "GridSelect":
        return GridSelectTaskScreen(
            task as TaskGridSelect, constraints, GridSelectTaskBloc());
      case "MoneyTask":
        return MoneyTaskScreen(task as TaskMoney, constraints);
      case "VocableTest":
        return VocableTestTaskScreen(task as TaskVocableTest, constraints);
      case "Connect":
        return ConnectTaskScreen(task as TaskConnect, constraints);
      case "Equation":
        return EquationTaskScreen(task as TaskEquation, constraints);
      case "Buchstabieren":
        // precacheAllImagesForTask(task, context);
        randomNummer = erstelleEineRandomNummer(task);
        return BuchstabierenTaskScreen(
            task as TaskBuchstabieren,
            constraints,
            cacheImageByUrl(context, holeUrl(task, randomNummer!)),
            randomNummer,
            userGrade);
      default:
        return Container();
    }
  }

  ///Returns the Widget that displays the summary after all tasks have been solved.
  Widget buildCompletionScreen(
      List<Task> tasks, List<bool> results, BoxConstraints constraints) {
    int rightAnswers = 0;
    int coinsEarned = 0;
    for (int i = 0; i < results.length; i++) {
      if (results[i]) {
        rightAnswers++;
        if (tasks[i].leftToSolve! > -1) coinsEarned += tasks[i].reward!;
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

  ///Returns a single item of the list in the summary screen.
  ///
  ///Contains the information, whether a Task has been solved
  ///correctly and how many lama coins were awarded.
  Widget buildListItem(
      int index, BoxConstraints constraints, bool result, Task task) {
    Icon icon = result
        ? Icon(Icons.check, color: LamaColors.greenAccent, size: 50)
        : Icon(Icons.close, color: LamaColors.redAccent, size: 50);
    Text coinText;
    if (result) {
      if (task.leftToSolve! > -1)
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
