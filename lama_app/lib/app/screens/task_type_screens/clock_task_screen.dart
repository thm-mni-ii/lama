import 'dart:async';
import 'dart:math';
import 'package:bubble/bubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:lama_app/app/bloc/task_bloc.dart';
import 'package:lama_app/app/event/task_events.dart';
import 'package:lama_app/app/task-system/task.dart';
import 'package:lama_app/util/LamaColors.dart';
import 'package:lama_app/util/LamaTextTheme.dart';

import 'package:lama_app/app/state/home_screen_state.dart';
import 'package:lama_app/app/event/tts_event.dart';
import 'package:lama_app/app/state/tts_state.dart';
import 'package:lama_app/app/bloc/taskBloc/tts_bloc.dart';


import 'package:numberpicker/numberpicker.dart';

/// Author: H.Bismo

class ClockTaskScreen extends StatefulWidget {
  final ClockTest task;
  final BoxConstraints constraints;
  ClockTaskScreen(this.task, this.constraints);

  @override
  State<StatefulWidget> createState() {
    return ClockTaskState(task, constraints);
  }
}

class ClockTaskState extends State<ClockTaskScreen> {
  final TextEditingController controller = TextEditingController();
  final BoxConstraints constraints;
  final ClockTest task;
  ClockPainter? bloc;
  ClockPainter2? bloc2;
  final List<String?> answers = [];
  int i = 1;
  int timer = 15;
  String? showtimer;
  String? sonneMond;
  var randStunde;
  var randMinute;
  var randStunde2;
  var randMinute2;
  var rnd = Random();
  var rnd2 = Random();
  var wrgStunde;
  var wrgMinute;
  var wrgStunde2;
  var wrgMinute2;
  var vierMinute;
  var vierMinute2;
  var allMinuten;

  bool alreadySaid = false;
  var allMinuten2;
  List<String> wrongAnswer = [];
  int currentValue = 0;
  int currentValue2 = 0;
  int diffHour = 0;
  int diffMinute = 0;
  bool correct = true;
  bool incorrect = false;
  int midStunde = 0;

  String setImage() {
    if (this.randStunde < 5 || this.randStunde > 17) {
      if (this.randStunde == 18 || this.randStunde == 19) {
        return sonneMond = "assets/images/png/sunset.png";
      } else {
        return sonneMond = "assets/images/png/moon.png";
      }
    } else {
      if (this.randStunde == 5 || this.randStunde == 6) {
        return sonneMond = "assets/images/png/sunrise.png";
      } else {
        return sonneMond = "assets/images/png/sun.png";
      }
    }
  }

  String setAM() {
    if (this.randStunde > 12) {
      return "PM";
    } else {
      return "AM";
    }
  }

  String setAM2() {
    if (this.randStunde2 > 12) {
      return "PM";
    } else {
      return "AM";
    }
  }

  ClockTaskState(this.task, this.constraints) {
    this.allMinuten = rnd.nextInt(60);
    this.allMinuten2 = rnd2.nextInt(60);
    this.wrgStunde2 = rnd.nextInt(24);
    this.wrgMinute2 = rnd.nextInt(60);
    this.wrgStunde = rnd.nextInt(24);
    this.wrgMinute = rnd.nextInt(60);
    this.randStunde = rnd.nextInt(24);
    this.randMinute = rnd.nextInt(2) * 30;
    this.randStunde2 = rnd2.nextInt(24);
    this.randMinute2 = rnd2.nextInt(2) * 30;
    this.vierMinute = rnd.nextInt(4) * 15;
    this.vierMinute2 = rnd2.nextInt(4) * 15;

    bloc = ClockPainter(task, constraints, this.randStunde, this.randMinute,
        this.vierMinute, this.allMinuten);
    task.rightAnswer = bloc?.strAnswer();
    answers.add(task.rightAnswer); //get the right answer
    answers.add(wrgAnswer());
    answers.add(wrgAnswer2()); // add the wrong answers
    answers.shuffle();
    print(answers);

    if (this.randStunde2 < this.randStunde) {
      this.midStunde = this.randStunde2 + 24;
      print(this.midStunde);
      this.diffHour = (this.midStunde - this.randStunde - 1).toInt();
    } else if (this.randStunde2 == this.randStunde &&
        this.allMinuten2 < this.allMinuten) {
      this.midStunde = this.randStunde2 + 24;
      print(this.midStunde);
      this.diffHour = (this.midStunde - this.randStunde - 1).toInt();
    } else {
      this.diffHour = (this.randStunde2 - this.randStunde - 1).toInt();
    }
    this.diffMinute =
        (this.allMinuten2 % 100 + (60 - this.allMinuten % 100)).toInt();
    if (this.diffMinute >= 60) {
      this.diffHour++;
      this.diffMinute = this.diffMinute - 60;
    }
  }

  @override
  void initState() {
    if (task.timer == true) {
      showtimer = "15";
      startTimer();
      super.initState();
    } else {
      showtimer = "";
      super.initState();
    }

    super.initState();
  }

  void startTimer() async {
    const sek = Duration(seconds: 1);
    Timer.periodic(sek, (Timer t) {
      setState(() {
        if (timer < 1) {
          t.cancel();
        } else {
          timer = timer - 1;
        }
        showtimer = timer.toString();
      });
    });
  }

  int diffHourAnswer() {
    if (this.randStunde2 < this.randStunde) {
      int midStunde = this.randStunde2 + 24;
      print(midStunde);
      this.diffHour = (midStunde - this.randStunde - 1).toInt();
    } else if (this.randStunde2 == this.randStunde &&
        this.allMinuten2 < this.allMinuten) {
      int midStunde = this.randStunde2 + 24;
      print(midStunde);
      this.diffHour = (midStunde - this.randStunde - 1).toInt();
    } else {
      this.diffHour = (this.randStunde2 - this.randStunde - 1).toInt();
    }
    this.diffMinute =
        (this.allMinuten2 % 100 + (60 - this.allMinuten % 100)).toInt();
    if (this.diffMinute >= 60) {
      this.diffHour++;
      this.diffMinute = this.diffMinute - 60;
    }

    int resHour = this.diffHour;
    print(resHour);
    return resHour;
  }

  int diffMinuteAnswer() {
    if (this.randStunde2 < this.randStunde) {
      int midStunde = this.randStunde2 + 24;
      print(midStunde);
      this.diffHour = (midStunde - this.randStunde - 1).toInt();
    } else if (this.randStunde2 == this.randStunde &&
        this.allMinuten2 < this.allMinuten) {
      int midStunde = this.randStunde2 + 24;
      print(midStunde);
      this.diffHour = (midStunde - this.randStunde - 1).toInt();
    } else {
      this.diffHour = (this.randStunde2 - this.randStunde - 1).toInt();
    }
    this.diffMinute =
        (this.allMinuten2 % 100 + (60 - this.allMinuten % 100)).toInt();
    if (this.diffMinute >= 60) {
      this.diffHour++;
      this.diffMinute = this.diffMinute - 60;
    }

    int resMinute = this.diffMinute;
    print(resMinute);
    return resMinute;
  }

  String wrgAnswer() {
    if (this.wrgStunde != this.randStunde ||
        this.wrgMinute != this.randMinute) {
      if (task.uhr == "halbeStunde") {
        if (this.wrgMinute == 0) {
          if (this.wrgStunde < 10) {
            return "0" + this.wrgStunde.toString() + ":" + "00";
          } else {
            return this.wrgStunde.toString() + ":" + "00";
          }
        } else {
          if (this.wrgStunde < 10) {
            return "0" +
                this.wrgStunde.toString() +
                ":" +
                this.wrgStunde.toString();
          }
          return this.wrgStunde.toString() + ":" + this.wrgMinute.toString();
        }
      } else if (task.uhr == "vollStunde") {
        if (this.wrgStunde < 10) {
          return "0" + this.wrgStunde.toString() + ":" + "00";
        } else {
          return this.wrgStunde.toString() + ":" + "00";
        }
      } else if (task.uhr == "viertelStunde") {
        if (this.wrgMinute == 0) {
          if (this.randStunde < 10) {
            return "0" + this.wrgStunde.toString() + ":" + "00";
          } else {
            return this.wrgStunde.toString() + ":" + "00";
          }
        } else {
          if (this.wrgStunde < 10) {
            return "0" +
                this.wrgStunde.toString() +
                ":" +
                this.wrgMinute.toString();
          } else {
            return this.wrgStunde.toString() + ":" + this.wrgMinute.toString();
          }
        }
      } else if (task.uhr == "allStunden") {
        if (this.wrgMinute < 10) {
          if (this.wrgStunde < 10) {
            return "0" +
                this.wrgStunde.toString() +
                ":" +
                "0" +
                this.wrgMinute.toString();
          } else {
            return this.wrgStunde.toString() +
                ":" +
                "0" +
                this.wrgMinute.toString();
          }
        } else if (this.allMinuten >= 10) {
          if (this.wrgStunde < 10) {
            return "0" +
                this.wrgStunde.toString() +
                ":" +
                this.wrgMinute.toString();
          } else {
            return this.wrgStunde.toString() + ":" + this.wrgMinute.toString();
          }
        } else {
          return this.wrgStunde.toString() + ":" + this.wrgMinute.toString();
        }
      }
    }
    return this.wrgStunde.toString() + ":" + this.wrgMinute.toString();
  }

  String wrgAnswer2() {
    if (this.wrgStunde2 != this.randStunde ||
        this.wrgMinute2 != this.randMinute) {
      if (task.uhr == "halbeStunde") {
        if (this.wrgMinute2 == 0) {
          if (this.wrgStunde2 < 10) {
            return "0" + this.wrgStunde2.toString() + ":" + "00";
          } else {
            return this.wrgStunde2.toString() + ":" + "00";
          }
        } else {
          if (this.wrgStunde2 < 10) {
            return "0" +
                this.wrgStunde2.toString() +
                ":" +
                this.wrgMinute2.toString();
          }
          return this.wrgStunde2.toString() + ":" + this.wrgMinute2.toString();
        }
      } else if (task.uhr == "vollStunde") {
        if (this.wrgStunde2 < 10) {
          return "0" + this.wrgStunde2.toString() + ":" + "00";
        } else {
          return this.wrgStunde2.toString() + ":" + "00";
        }
      } else if (task.uhr == "viertelStunde") {
        if (this.wrgMinute2 == 0) {
          if (this.wrgStunde2 < 10) {
            return "0" + this.wrgStunde2.toString() + ":" + "00";
          } else {
            return this.wrgStunde2.toString() + ":" + "00";
          }
        } else {
          if (this.wrgStunde2 < 10) {
            return "0" +
                this.wrgStunde2.toString() +
                ":" +
                this.wrgMinute2.toString();
          } else {
            return this.wrgStunde2.toString() +
                ":" +
                this.wrgMinute2.toString();
          }
        }
      } else if (task.uhr == "allStunden") {
        if (this.wrgMinute2 < 10) {
          if (this.wrgStunde2 < 10) {
            return "0" +
                this.wrgStunde2.toString() +
                ":" +
                "0" +
                this.wrgMinute2.toString();
          } else {
            return this.wrgStunde.toString() +
                ":" +
                "0" +
                this.wrgMinute.toString();
          }
        } else if (this.wrgMinute2 >= 10) {
          if (this.wrgStunde2 < 10) {
            return "0" +
                this.wrgStunde2.toString() +
                ":" +
                this.wrgMinute2.toString();
          } else {
            return this.wrgStunde2.toString() +
                ":" +
                this.wrgMinute2.toString();
          }
        } else {
          return this.wrgStunde2.toString() + ":" + this.wrgMinute2.toString();
        }
      }
    }
    return this.wrgStunde2.toString() + ":" + this.wrgMinute2.toString();
  }

  void _showAlertDialog(String txt) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(txt),
        );
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    String qlang;
    task.questionLanguage == null ? qlang = "Deutsch" : qlang = task.questionLanguage!;

    print(this.randStunde.toString() + ":" + this.allMinuten.toString());
    print(this.randStunde2.toString() + ":" + this.allMinuten2.toString());
    print(this.diffHour);
    print(this.diffMinute);
    if (task.uhr == "allStunden") {
      return BlocProvider(
        create: (context) => TTSBloc(),
        child: BlocBuilder<TTSBloc, TTSState>(
          builder: (context, TTSState state) {
    if (state is EmptyTTSState ) {
    context.read<TTSBloc>().add(
    QuestionOnInitEvent(task.lamaText!, "qlang"));
    }
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
    child: InkWell(
    onTap: () {
    //log('task.lamaText!: ${task.lamaText!}');
    BlocProvider.of<TTSBloc>(context)
        .add(ClickOnQuestionEvent.initVoice(task.lamaText!, qlang));
    },
    child: Center(
    child: Text(
    task.lamaText!,
    style: LamaTextTheme.getStyle(
    color: LamaColors.black, fontSize: 15),
    ),
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
    ),
    Align(
    alignment: Alignment(1.0, 5.0),
    child: Container(
    padding: EdgeInsets.only(left: 100, top: 15),
    child: Image.asset(
    setImage(),
    width: 30,
    height: 30,
    ))),
    ],
    ),
    ),
    //Items
    Padding(
    padding: EdgeInsets.all(5),
    child: Container(
    height: (constraints.maxHeight / 100) * 45,
    child: Container(
    width: 270,
    height: 270,
    child: CustomPaint(
    painter: ClockPainter(task, constraints, randStunde,
    randMinute, vierMinute, allMinuten)),
    )),
    ),
    Container(
    height: (constraints.maxHeight / 100) * 27.5,
    alignment: Alignment.topCenter,
    child: Column(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: [
    Container(
    child: Align(
    alignment: Alignment.bottomLeft,
    child: Center(
    child: Text(
    showtimer!,
    style: TextStyle(
    fontSize: 15.0,
    fontWeight: FontWeight.w700,
    ),
    ),
    ),
    )),
    Container(
    height: (constraints.maxHeight / 100) * 15,
    child: Center(
    child: Padding(
    padding: const EdgeInsets.symmetric(horizontal: 15),
    child: TextField(
    autocorrect: false,
    enableSuggestions: false,
    cursorColor: Colors.white,
    controller: controller,
    decoration: InputDecoration(
    fillColor: LamaColors.blueAccent,
    hintStyle: LamaTextTheme.getStyle(
    fontSize: 20,
    fontWeight: FontWeight.w500,
    color: LamaColors.white.withOpacity(0.5)),
    filled: true,
    border: OutlineInputBorder(
    borderRadius:
    BorderRadius.all(Radius.circular(50)),
    borderSide: BorderSide.none),
    focusedBorder: OutlineInputBorder(
    borderRadius:
    BorderRadius.all(Radius.circular(50)),
    borderSide: BorderSide.none),
    enabledBorder: OutlineInputBorder(
    borderRadius:
    BorderRadius.all(Radius.circular(50)),
    borderSide: BorderSide.none),
    hintText: 'Gib die Uhrzeit ein! (HH:MM)'),
    maxLines: 1,
    keyboardType: TextInputType.text,
    textAlign: TextAlign.center,
    style: LamaTextTheme.getStyle(
    fontSize: 22.5, fontWeight: FontWeight.w500),
    ),
    ),
    )),
    ]),
    ),
    Container(
    height: (constraints.maxHeight / 100) * 9,
    child: Center(
    child: InkWell(
    child: Container(
    height: (constraints.maxHeight / 100) * 15,
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
    "Fertig!",
    style: LamaTextTheme.getStyle(
    fontSize: 30,
    ),
    ),
    ),
    ),
    onTap: () {
    bool noInput = true;
    if ((controller.text) != null) {
    noInput = false;
    }
    if (noInput) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    duration: Duration(seconds: 2),
    content: Container(
    height: (constraints.maxHeight / 100) * 6,
    alignment: Alignment.bottomCenter,
    child: Center(
    child: FittedBox(
    fit: BoxFit.fitWidth,
    child: Text(
    "Gib eine Zahl ein!",
    style: LamaTextTheme.getStyle(),
    textAlign: TextAlign.center,
    ),
    ))),
    backgroundColor: LamaColors.mainPink,
    ));
    } else {
    bool answer = (controller.text) == task.rightAnswer;
    BlocProvider.of<TaskBloc>(context)
        .add(AnswerTaskEvent.initClockTask(answer));
    print(answer);
    }
    }),
    ),
    ),
    ],
            );
          }
        ),
      );
    } else if (task.uhr == "differentStunden") {
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
                          "Wie viel Zeitunterschied gibt es?",
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
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: 55, right: 50),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(setAM(),
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Icon(Icons.arrow_right),
                Text(setAM2(),
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))
              ],
            ),
          ),

          //Items
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 50),
                child: Container(
                    height: (constraints.maxHeight / 100) * 20,
                    child: Container(
                      width: 160,
                      height: 160,
                      child: CustomPaint(
                          painter: ClockPainter(task, constraints, randStunde,
                              randMinute, vierMinute, allMinuten)),
                    )),
              ),
              Padding(
                padding: EdgeInsets.only(top: 50),
                child: Container(
                    height: (constraints.maxHeight / 100) * 20,
                    child: Container(
                      width: 160,
                      height: 160,
                      child: CustomPaint(
                          painter: ClockPainter2(task, constraints, randStunde2,
                              randMinute2, vierMinute2, allMinuten2)),
                    )),
              )
            ],
          ),
          Container(
              margin: EdgeInsets.only(top: 70),
              alignment: Alignment.topCenter,
              padding: EdgeInsets.only(right: 40, left: 40),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "HH",
                    style: TextStyle(fontSize: 18),
                  ),
                  Text(
                    "MM",
                    style: TextStyle(fontSize: 18),
                  )
                ],
              )),
          Container(
            margin: EdgeInsets.only(top: 50, bottom: 50),
            alignment: Alignment.topCenter,
            padding: EdgeInsets.only(left: 80, right: 80),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                    child: NumberPicker(
                  itemCount: 1,
                  value: currentValue,
                  maxValue: 23,
                  minValue: 0,
                  onChanged: (value) => setState(() => currentValue = value),
                )),
                Text(":",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                Container(
                  child: NumberPicker(
                    itemCount: 1,
                    value: currentValue2,
                    maxValue: 59,
                    minValue: 0,
                    onChanged: (value) => setState(() => currentValue2 = value),
                  ),
                )
              ],
            ),
          ),
          Container(
            height: (constraints.maxHeight / 100) * 9,
            child: Center(
              child: InkWell(
                  child: Container(
                    height: (constraints.maxHeight / 100) * 15,
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
                        "Fertig!",
                        style: LamaTextTheme.getStyle(
                          fontSize: 30,
                        ),
                      ),
                    ),
                  ),
                  onTap: () {
                    if (this.currentValue == this.diffHour &&
                        this.currentValue2 == this.diffMinute) {
                      BlocProvider.of<TaskBloc>(context)
                          .add(AnswerTaskEvent.initClockTask(correct));
                    } else {
                      BlocProvider.of<TaskBloc>(context)
                          .add(AnswerTaskEvent.initClockTask(incorrect));
                    }
                  }),
            ),
          ),
        ],
      );
    } else {
  return BlocProvider(
  create: (context) => TTSBloc(),
  child: Column(children: [
        // Lama Speechbubble
          Container(
          height: (constraints.maxHeight / 100) * 15,
          padding: EdgeInsets.only(left: 15, right: 15, top: 15),
          // create space between each childs
          
           child: BlocBuilder<TTSBloc, TTSState>(
             builder: (context, state) {
              if (state is EmptyTTSState ) {
                context.read<TTSBloc>().add(
                QuestionOnInitEvent(task.lamaText!, qlang));
              }
              return Stack(
                 children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  padding: EdgeInsets.only(left: 75),
                  height: 50,
                  width: MediaQuery.of(context).size.width,
                  child: Bubble(
                    nip: BubbleNip.leftCenter,
                    child: InkWell(
                      onTap: () {
                        BlocProvider.of<TTSBloc>(context)
                            .add(ClickOnQuestionEvent.initVoice(task.lamaText!, qlang));
                      },
                      child: Center(
                        child: Text(
                          task.lamaText!,
                          style: LamaTextTheme.getStyle(
                              color: LamaColors.black, fontSize: 15),
                        ),
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
              ),
              Align(
                  alignment: Alignment(1.0, 5.0),
                  child: Container(
                      padding: EdgeInsets.only(left: 100, top: 15),
                      child: Image.asset(
                        setImage(),
                        width: 30,
                        height: 30,
                      ))),
            ],
          );
        },
        ),
        ),
        //Items
        Padding(
          padding: EdgeInsets.all(5),
          child: Container(
              height: (constraints.maxHeight / 100) * 45,
              child: Container(
                width: 270,
                height: 270,
                child: CustomPaint(
                    painter: ClockPainter(task, constraints, randStunde,
                        randMinute, vierMinute, allMinuten)),
              )),
        ),
        BlocBuilder<TTSBloc, TTSState>(
          builder: (context, state) {
        return Container(
          height: (constraints.maxHeight / 100) * 35,
          alignment: Alignment.bottomCenter,
          padding: EdgeInsets.only(top: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                  child: Align(
                alignment: Alignment.bottomLeft,
                child: Center(
                  child: Text(
                    showtimer!,
                    style: TextStyle(
                      fontSize: 15.0,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              )),
              Container(
                height: 55,
                width: 150,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                    color: LamaColors.greenAccent,
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 1,
                          blurRadius: 7,
                          offset: Offset(0, 3)),
                    ]),
                child: InkWell(
                  onDoubleTap: () {
                    BlocProvider.of<TaskBloc>(context)
                        .add(AnswerTaskEvent(answers[0]));
                    BlocProvider.of<TTSBloc>(context).
                    add(SetDefaultEvent());
                  },
                  onTap: () {
                    BlocProvider.of<TTSBloc>(context).
                    add(ClickOnAnswerEvent(answers[0]!,"de"));

                  },
                  child: Center(
                    child: Text(
                      answers[0]!,
                      style: LamaTextTheme.getStyle(
                        color: LamaColors.white,
                        fontSize: 30,
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                height: 55,
                width: 150,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                    color: LamaColors.greenAccent,
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 1,
                          blurRadius: 7,
                          offset: Offset(0, 3))
                    ]),
                child: InkWell(
                  onDoubleTap: () {
                    //selectedAnswer = answers[1]!;
                    BlocProvider.of<TaskBloc>(context)
                        .add(AnswerTaskEvent(answers[1]));
                    BlocProvider.of<TTSBloc>(context).
                    add(SetDefaultEvent());
                  },
                  onTap: () {
                    BlocProvider.of<TTSBloc>(context).
                    add(ClickOnAnswerEvent(answers[1]!,"de"));

                  },
                  child: Center(
                    child: Text(
                      answers[1]!,
                      style: LamaTextTheme.getStyle(
                        color:  LamaColors.white,
                        fontSize: 30,
                      ),
                    ),
                  ),
                ),
              ),

              Container(
                height: 55,
                width: 150,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                    color: LamaColors.greenAccent,
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 1,
                          blurRadius: 7,
                          offset: Offset(0, 3))
                    ]),
                child: InkWell(
                  onDoubleTap: () {
                    BlocProvider.of<TaskBloc>(context)
                        .add(AnswerTaskEvent(answers[2]));
                    BlocProvider.of<TTSBloc>(context).
                    add(SetDefaultEvent());
                    //selectedAnswer = answers[2]!;
                  },
                  onTap: () {

                    BlocProvider.of<TTSBloc>(context).
                    add(ClickOnAnswerEvent(answers[2]!,"de"));
                    },
                    child: Center(
                      child: Text(
                        answers[2]!,
                        style: LamaTextTheme.getStyle(
                          color: LamaColors.white,
                          fontSize: 30,
                        ),
                      ),
                    ),
                  ),
              ),
            ],
          ),
        );
        },
      )
      ]),
    );
    }
  }
}

class ClockPainter extends CustomPainter {
  final ClockTest task;
  var allMinuten;
  var wrgStunde;
  var wrgMinute;
  var rnd = Random();
  var randStunde;
  var randMinute;
  var vierMinute;
  final BoxConstraints constraints;

  ClockPainter(this.task, this.constraints, randStunde, randMinute, vierMinute,
      allMinuten) {
    this.randStunde = randStunde;
    this.randMinute = randMinute;
    this.vierMinute = vierMinute;
    this.allMinuten = allMinuten;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return true;
  }

  int intAnswer() {
    return randStunde + ":" + allMinuten;
  }

  String strAnswer() {
    if (task.uhr == "halbeStunde") {
      if (this.randMinute == 0) {
        if (this.randStunde < 10) {
          return "0" + this.randStunde.toString() + ":" + "00";
        } else {
          return this.randStunde.toString() + ":" + "00";
        }
      } else {
        if (this.randStunde < 10) {
          return "0" +
              this.randStunde.toString() +
              ":" +
              this.randMinute.toString();
        }
        return this.randStunde.toString() + ":" + this.randMinute.toString();
      }
    } else if (task.uhr == "vollStunde") {
      if (this.randStunde < 10) {
        return "0" + this.randStunde.toString() + ":" + "00";
      } else {
        return this.randStunde.toString() + ":" + "00";
      }
    } else if (task.uhr == "viertelStunde") {
      if (this.vierMinute == 0) {
        if (this.randStunde < 10) {
          return "0" + this.randStunde.toString() + ":" + "00";
        } else {
          return this.randStunde.toString() + ":" + "00";
        }
      } else {
        if (this.randStunde < 10) {
          return "0" +
              this.randStunde.toString() +
              ":" +
              this.vierMinute.toString();
        } else {
          return this.randStunde.toString() + ":" + this.vierMinute.toString();
        }
      }
    } else if (task.uhr == "allStunden") {
      if (this.allMinuten < 10) {
        if (this.randStunde < 10) {
          return "0" +
              this.randStunde.toString() +
              ":" +
              "0" +
              this.allMinuten.toString();
        } else {
          return this.randStunde.toString() +
              ":" +
              "0" +
              this.allMinuten.toString();
        }
      } else if (this.allMinuten >= 10) {
        if (this.randStunde < 10) {
          return "0" +
              this.randStunde.toString() +
              ":" +
              this.allMinuten.toString();
        } else {
          return this.randStunde.toString() + ":" + this.allMinuten.toString();
        }
      } else {
        return this.randStunde.toString() + ":" + this.allMinuten.toString();
      }
    }
    return this.randStunde.toString() + ":" + this.randMinute.toString();
  }

  @override
  void paint(Canvas canvas, Size size) {
    // TODO: implement paint
    if (task.uhr == "differentStunden") {
      var X = size.width / 2;
      var Y = size.width / 2;
      var center = Offset(X, Y);
      var rad = min(X, Y);

      var clockDraw = Paint()..color = LamaColors.white;

      var clockOutline = Paint()
        ..color = Colors.black26
        ..strokeWidth = 16
        ..style = PaintingStyle.stroke;

      var clockCenter = Paint()..color = Color(0xFFEAECFF);

      var minClock = Paint()
        ..shader =
            RadialGradient(colors: [Colors.lightBlue, Colors.blueAccent[700]!])
                .createShader(Rect.fromCircle(center: center, radius: rad))
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeWidth = 4;

      var hourClock = Paint()
        ..shader =
            RadialGradient(colors: [Color(0xFFEA74AB), Color(0xFFC279FB)])
                .createShader(Rect.fromCircle(center: center, radius: rad))
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeWidth = 6;
      var minClock1 = Paint()
        ..shader = RadialGradient(
                colors: [Colors.indigo[600]!, Colors.blueAccent[700]!])
            .createShader(Rect.fromCircle(center: center, radius: rad))
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeWidth = 4;

      var hourClock1 = Paint()
        ..shader = RadialGradient(
                colors: [Colors.indigo[600]!, Colors.blueAccent[700]!])
            .createShader(Rect.fromCircle(center: center, radius: rad))
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeWidth = 6;

      var dashNum = Paint()
        ..color = Colors.black
        ..strokeWidth = 5;

      var dashMin = Paint()
        ..color = Colors.black
        ..strokeWidth = 1;

      canvas.drawCircle(center, rad - 40, clockDraw);
      canvas.drawCircle(center, rad - 40, clockOutline);

      for (int j = 0; j < 60; j++) {
        if (j == allMinuten) {
          for (int i = 0; i < 24; i++) {
            if (i == randStunde) {
              var minClockX = X + 60 * cos((270 + j * 6) * pi / 180);
              var minClockY = Y + 60 * sin((270 + j * 6) * pi / 180);
              var hourClockX =
                  X + 40 * cos((i * 30 + 270 + j * 0.5) * pi / 180);
              var hourClockY =
                  Y + 40 * sin((i * 30 + 270 + j * 0.5) * pi / 180);
              canvas.drawLine(center, Offset(minClockX, minClockY), minClock1);
              canvas.drawLine(
                  center, Offset(hourClockX, hourClockY), hourClock1);
            }
          }
        }
      }
      canvas.drawCircle(center, 10, clockCenter);

      var outerClock = rad;
      var innerClock = rad - 20;

      var outerMinute = rad;
      var innerMinute = rad - 14;

      for (double i = 0; i < 360; i += 30) {
        for (double i = 0; i < 360; i += 6) {
          var x1 = X - outerMinute * cos(i * pi / 180);
          var y1 = X - outerMinute * sin(i * pi / 180);

          var x2 = X - innerMinute * cos(i * pi / 180);
          var y2 = X - innerMinute * sin(i * pi / 180);
          canvas.drawLine(Offset(x1, y1), Offset(x2, y2), dashMin);
        }
        var x1 = X - outerClock * cos(i * pi / 180);
        var y1 = X - outerClock * sin(i * pi / 180);

        var x2 = X - innerClock * cos(i * pi / 180);
        var y2 = X - innerClock * sin(i * pi / 180);
        canvas.drawLine(Offset(x1, y1), Offset(x2, y2), dashNum);
      }
    } else {
      var X = size.width / 2;
      var Y = size.width / 2;
      var center = Offset(X, Y);
      var rad = min(X, Y);

      var clockDraw = Paint()..color = LamaColors.white;

      var clockOutline = Paint()
        ..color = Colors.black26
        ..strokeWidth = 16
        ..style = PaintingStyle.stroke;

      var clockCenter = Paint()..color = Color(0xFFEAECFF);

      var minClock = Paint()
        ..shader =
            RadialGradient(colors: [Colors.lightBlue, Colors.blueAccent[700]!])
                .createShader(Rect.fromCircle(center: center, radius: rad))
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeWidth = 10;

      var hourClock = Paint()
        ..shader =
            RadialGradient(colors: [Color(0xFFEA74AB), Color(0xFFC279FB)])
                .createShader(Rect.fromCircle(center: center, radius: rad))
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeWidth = 16;
      var minClock1 = Paint()
        ..shader = RadialGradient(
                colors: [Colors.indigo[600]!, Colors.blueAccent[700]!])
            .createShader(Rect.fromCircle(center: center, radius: rad))
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeWidth = 10;

      var hourClock1 = Paint()
        ..shader = RadialGradient(
                colors: [Colors.indigo[600]!, Colors.blueAccent[700]!])
            .createShader(Rect.fromCircle(center: center, radius: rad))
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeWidth = 16;

      var dashNum = Paint()
        ..color = Colors.black
        ..strokeWidth = 5;

      var dashMin = Paint()
        ..color = Colors.black
        ..strokeWidth = 1;

      canvas.drawCircle(center, rad - 40, clockDraw);
      canvas.drawCircle(center, rad - 40, clockOutline);

      if (task.uhr == "vollStunde") {
        for (int i = 0; i < 24; i++) {
          if (i == randStunde) {
            var minClockX = X + 80 * cos(270 * pi / 180);
            var minClockY = Y + 80 * sin(270 * pi / 180);
            var hourClockX = X + 60 * cos((i * 30 + 270) * pi / 180);
            var hourClockY = Y + 60 * sin((i * 30 + 270) * pi / 180);
            canvas.drawLine(center, Offset(minClockX, minClockY), minClock);
            canvas.drawLine(center, Offset(hourClockX, hourClockY), hourClock);
            print(randStunde.toString() + ":" + randMinute.toString());
          }
        }
      } else if (task.uhr == "halbeStunde") {
        for (int i = 0; i < 24; i++) {
          if (randMinute == 30) {
            if (i == randStunde) {
              var minClockX = X + 80 * cos(90 * pi / 180);
              var minClockY = Y + 80 * sin(90 * pi / 180);
              var hourClockX = X + 60 * cos((i * 30 + 285) * pi / 180);
              var hourClockY = Y + 60 * sin((i * 30 + 285) * pi / 180);
              canvas.drawLine(center, Offset(minClockX, minClockY), minClock);
              canvas.drawLine(
                  center, Offset(hourClockX, hourClockY), hourClock);
              print(randStunde.toString() + ":" + randMinute.toString());
            }
          } else if (randMinute == 0) {
            for (int i = 0; i < 24; i++) {
              if (i == randStunde) {
                var minClockX = X + 80 * cos(270 * pi / 180);
                var minClockY = Y + 80 * sin(270 * pi / 180);
                var hourClockX = X + 60 * cos((i * 30 + 270) * pi / 180);
                var hourClockY = Y + 60 * sin((i * 30 + 270) * pi / 180);
                canvas.drawLine(center, Offset(minClockX, minClockY), minClock);
                canvas.drawLine(
                    center, Offset(hourClockX, hourClockY), hourClock);
                print(randStunde.toString() + ":" + randMinute.toString());
              }
            }
          }
        }
      } else if (task.uhr == "viertelStunde") {
        for (int i = 0; i < 24; i++) {
          if (vierMinute == 30) {
            if (i == randStunde) {
              var minClockX = X + 80 * cos(90 * pi / 180);
              var minClockY = Y + 80 * sin(90 * pi / 180);
              var hourClockX = X + 60 * cos((i * 30 + 285) * pi / 180);
              var hourClockY = Y + 60 * sin((i * 30 + 285) * pi / 180);
              canvas.drawLine(center, Offset(minClockX, minClockY), minClock1);
              canvas.drawLine(
                  center, Offset(hourClockX, hourClockY), hourClock1);
              print(randStunde.toString() + ":" + randMinute.toString());
            }
          } else if (vierMinute == 15) {
            for (int i = 0; i < 24; i++) {
              if (i == randStunde) {
                var minClockX = X + 80 * cos(360 * pi / 180);
                var minClockY = Y + 80 * sin(360 * pi / 180);
                var hourClockX = X + 60 * cos((i * 30 + 278) * pi / 180);
                var hourClockY = Y + 60 * sin((i * 30 + 278) * pi / 180);
                canvas.drawLine(
                    center, Offset(minClockX, minClockY), minClock1);
                canvas.drawLine(
                    center, Offset(hourClockX, hourClockY), hourClock1);
                print(randStunde.toString() + ":" + randMinute.toString());
              }
            }
          } else if (vierMinute == 45) {
            for (int i = 0; i < 24; i++) {
              if (i == randStunde) {
                var minClockX = X + 80 * cos(180 * pi / 180);
                var minClockY = Y + 80 * sin(180 * pi / 180);
                var hourClockX = X + 60 * cos((i * 30 + 293) * pi / 180);
                var hourClockY = Y + 60 * sin((i * 30 + 293) * pi / 180);
                canvas.drawLine(
                    center, Offset(minClockX, minClockY), minClock1);
                canvas.drawLine(
                    center, Offset(hourClockX, hourClockY), hourClock1);
                print(randStunde.toString() + ":" + randMinute.toString());
              }
            }
          } else if (vierMinute == 0) {
            for (int i = 0; i < 24; i++) {
              if (i == randStunde) {
                var minClockX = X + 80 * cos(270 * pi / 180);
                var minClockY = Y + 80 * sin(270 * pi / 180);
                var hourClockX = X + 60 * cos((i * 30 + 270) * pi / 180);
                var hourClockY = Y + 60 * sin((i * 30 + 270) * pi / 180);
                canvas.drawLine(
                    center, Offset(minClockX, minClockY), minClock1);
                canvas.drawLine(
                    center, Offset(hourClockX, hourClockY), hourClock1);
                print(randStunde.toString() + ":" + randMinute.toString());
              }
            }
          }
        }
      } else if (task.uhr == "allStunden") {
        for (int j = 0; j < 60; j++) {
          if (j == allMinuten) {
            for (int i = 0; i < 24; i++) {
              if (i == randStunde) {
                var minClockX = X + 80 * cos((270 + j * 6) * pi / 180);
                var minClockY = Y + 80 * sin((270 + j * 6) * pi / 180);
                var hourClockX =
                    X + 60 * cos((i * 30 + 270 + j * 0.5) * pi / 180);
                var hourClockY =
                    Y + 60 * sin((i * 30 + 270 + j * 0.5) * pi / 180);
                canvas.drawLine(
                    center, Offset(minClockX, minClockY), minClock1);
                canvas.drawLine(
                    center, Offset(hourClockX, hourClockY), hourClock1);
                print(randStunde.toString() + ":" + allMinuten.toString());
              }
            }
          }
        }
      }
      canvas.drawCircle(center, 16, clockCenter);

      var outerClock = rad;
      var innerClock = rad - 20;

      var outerMinute = rad;
      var innerMinute = rad - 14;

      for (double i = 0; i < 360; i += 30) {
        for (double i = 0; i < 360; i += 6) {
          var x1 = X - outerMinute * cos(i * pi / 180);
          var y1 = X - outerMinute * sin(i * pi / 180);

          var x2 = X - innerMinute * cos(i * pi / 180);
          var y2 = X - innerMinute * sin(i * pi / 180);
          canvas.drawLine(Offset(x1, y1), Offset(x2, y2), dashMin);
        }
        var x1 = X - outerClock * cos(i * pi / 180);
        var y1 = X - outerClock * sin(i * pi / 180);

        var x2 = X - innerClock * cos(i * pi / 180);
        var y2 = X - innerClock * sin(i * pi / 180);
        canvas.drawLine(Offset(x1, y1), Offset(x2, y2), dashNum);
      }
    }
  }
}

class ClockPainter2 extends CustomPainter {
  final ClockTest task;
  var allMinuten2;
  var wrgStunde;
  var wrgMinute;
  var rnd2 = Random();
  var randStunde2;
  var randMinute2;
  var vierMinute2;
  final BoxConstraints constraints;

  ClockPainter2(this.task, this.constraints, randStunde2, randMinute2,
      vierMinute2, allMinuten2) {
    this.randStunde2 = randStunde2;
    this.randMinute2 = randMinute2;
    this.vierMinute2 = vierMinute2;
    this.allMinuten2 = allMinuten2;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return true;
  }

  int intAnswer() {
    return randStunde2 + ":" + allMinuten2;
  }

  String strAnswer() {
    if (task.uhr == "halbeStunde") {
      if (this.randMinute2 == 0) {
        if (this.randStunde2 < 10) {
          return "0" + this.randStunde2.toString() + ":" + "00";
        } else {
          return this.randStunde2.toString() + ":" + "00";
        }
      } else {
        if (this.randStunde2 < 10) {
          return "0" +
              this.randStunde2.toString() +
              ":" +
              this.randMinute2.toString();
        }
        return this.randStunde2.toString() + ":" + this.randMinute2.toString();
      }
    } else if (task.uhr == "vollStunde") {
      if (this.randStunde2 < 10) {
        return "0" + this.randStunde2.toString() + ":" + "00";
      } else {
        return this.randStunde2.toString() + ":" + "00";
      }
    } else if (task.uhr == "viertelStunde") {
      if (this.vierMinute2 == 0) {
        if (this.randStunde2 < 10) {
          return "0" + this.randStunde2.toString() + ":" + "00";
        } else {
          return this.randStunde2.toString() + ":" + "00";
        }
      } else {
        if (this.randStunde2 < 10) {
          return "0" +
              this.randStunde2.toString() +
              ":" +
              this.vierMinute2.toString();
        } else {
          return this.randStunde2.toString() +
              ":" +
              this.vierMinute2.toString();
        }
      }
    } else if (task.uhr == "allStunden") {
      if (this.allMinuten2 < 10) {
        if (this.randStunde2 < 10) {
          return "0" +
              this.randStunde2.toString() +
              ":" +
              "0" +
              this.allMinuten2.toString();
        } else {
          return this.randStunde2.toString() +
              ":" +
              "0" +
              this.allMinuten2.toString();
        }
      } else if (this.allMinuten2 >= 10) {
        if (this.randStunde2 < 10) {
          return "0" +
              this.randStunde2.toString() +
              ":" +
              this.allMinuten2.toString();
        } else {
          return this.randStunde2.toString() +
              ":" +
              this.allMinuten2.toString();
        }
      } else {
        return this.randStunde2.toString() + ":" + this.allMinuten2.toString();
      }
    }
    return this.randStunde2.toString() + ":" + this.randMinute2.toString();
  }

  @override
  void paint(Canvas canvas, Size size) {
    // TODO: implement paint

    if (task.uhr == "differentStunden") {
      var X = size.width / 2;
      var Y = size.width / 2;
      var center = Offset(X, Y);
      var rad = min(X, Y);

      var clockDraw = Paint()..color = LamaColors.white;

      var clockOutline = Paint()
        ..color = Colors.black26
        ..strokeWidth = 16
        ..style = PaintingStyle.stroke;

      var clockCenter = Paint()..color = Color(0xFFEAECFF);

      var minClock = Paint()
        ..shader =
            RadialGradient(colors: [Colors.lightBlue, Colors.blueAccent[700]!])
                .createShader(Rect.fromCircle(center: center, radius: rad))
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeWidth = 10;

      var hourClock = Paint()
        ..shader =
            RadialGradient(colors: [Color(0xFFEA74AB), Color(0xFFC279FB)])
                .createShader(Rect.fromCircle(center: center, radius: rad))
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeWidth = 16;
      var minClock1 = Paint()
        ..shader = RadialGradient(colors: [
          Color.fromARGB(255, 245, 205, 63),
          Color.fromARGB(255, 233, 84, 20)
        ]).createShader(Rect.fromCircle(center: center, radius: rad))
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeWidth = 4;

      var hourClock1 = Paint()
        ..shader = RadialGradient(colors: [
          Color.fromARGB(255, 245, 205, 63),
          Color.fromARGB(255, 233, 84, 20)
        ]).createShader(Rect.fromCircle(center: center, radius: rad))
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeWidth = 6;

      var dashNum = Paint()
        ..color = Colors.black
        ..strokeWidth = 5;

      var dashMin = Paint()
        ..color = Colors.black
        ..strokeWidth = 1;

      canvas.drawCircle(center, rad - 40, clockDraw);
      canvas.drawCircle(center, rad - 40, clockOutline);

      for (int j = 0; j < 60; j++) {
        if (j == allMinuten2) {
          for (int i = 0; i < 24; i++) {
            if (i == randStunde2) {
              var minClockX = X + 60 * cos((270 + j * 6) * pi / 180);
              var minClockY = Y + 60 * sin((270 + j * 6) * pi / 180);
              var hourClockX =
                  X + 40 * cos((i * 30 + 270 + j * 0.5) * pi / 180);
              var hourClockY =
                  Y + 40 * sin((i * 30 + 270 + j * 0.5) * pi / 180);
              canvas.drawLine(center, Offset(minClockX, minClockY), minClock1);
              canvas.drawLine(
                  center, Offset(hourClockX, hourClockY), hourClock1);
            }
          }
        }
      }
      canvas.drawCircle(center, 10, clockCenter);

      var outerClock = rad;
      var innerClock = rad - 20;

      var outerMinute = rad;
      var innerMinute = rad - 14;

      for (double i = 0; i < 360; i += 30) {
        for (double i = 0; i < 360; i += 6) {
          var x1 = X - outerMinute * cos(i * pi / 180);
          var y1 = X - outerMinute * sin(i * pi / 180);

          var x2 = X - innerMinute * cos(i * pi / 180);
          var y2 = X - innerMinute * sin(i * pi / 180);
          canvas.drawLine(Offset(x1, y1), Offset(x2, y2), dashMin);
        }
        var x1 = X - outerClock * cos(i * pi / 180);
        var y1 = X - outerClock * sin(i * pi / 180);

        var x2 = X - innerClock * cos(i * pi / 180);
        var y2 = X - innerClock * sin(i * pi / 180);
        canvas.drawLine(Offset(x1, y1), Offset(x2, y2), dashNum);
      }
    } else {
      var X = size.width / 2;
      var Y = size.width / 2;
      var center = Offset(X, Y);
      var rad = min(X, Y);

      var clockDraw = Paint()..color = LamaColors.white;

      var clockOutline = Paint()
        ..color = Colors.black26
        ..strokeWidth = 16
        ..style = PaintingStyle.stroke;

      var clockCenter = Paint()..color = Color(0xFFEAECFF);

      var minClock = Paint()
        ..shader =
            RadialGradient(colors: [Colors.lightBlue, Colors.blueAccent[700]!])
                .createShader(Rect.fromCircle(center: center, radius: rad))
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeWidth = 10;

      var hourClock = Paint()
        ..shader =
            RadialGradient(colors: [Color(0xFFEA74AB), Color(0xFFC279FB)])
                .createShader(Rect.fromCircle(center: center, radius: rad))
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeWidth = 16;
      var minClock1 = Paint()
        ..shader = RadialGradient(
                colors: [Colors.indigo[600]!, Colors.blueAccent[700]!])
            .createShader(Rect.fromCircle(center: center, radius: rad))
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeWidth = 10;

      var hourClock1 = Paint()
        ..shader = RadialGradient(
                colors: [Colors.indigo[600]!, Colors.blueAccent[700]!])
            .createShader(Rect.fromCircle(center: center, radius: rad))
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeWidth = 16;

      var dashNum = Paint()
        ..color = Colors.black
        ..strokeWidth = 5;

      var dashMin = Paint()
        ..color = Colors.black
        ..strokeWidth = 1;

      canvas.drawCircle(center, rad - 40, clockDraw);
      canvas.drawCircle(center, rad - 40, clockOutline);

      if (task.uhr == "vollStunde") {
        for (int i = 0; i < 24; i++) {
          if (i == randStunde2) {
            var minClockX = X + 80 * cos(270 * pi / 180);
            var minClockY = Y + 80 * sin(270 * pi / 180);
            var hourClockX = X + 60 * cos((i * 30 + 270) * pi / 180);
            var hourClockY = Y + 60 * sin((i * 30 + 270) * pi / 180);
            canvas.drawLine(center, Offset(minClockX, minClockY), minClock);
            canvas.drawLine(center, Offset(hourClockX, hourClockY), hourClock);
            print(randStunde2.toString() + ":" + randMinute2.toString());
          }
        }
      } else if (task.uhr == "halbeStunde") {
        for (int i = 0; i < 24; i++) {
          if (randMinute2 == 30) {
            if (i == randStunde2) {
              var minClockX = X + 80 * cos(90 * pi / 180);
              var minClockY = Y + 80 * sin(90 * pi / 180);
              var hourClockX = X + 60 * cos((i * 30 + 285) * pi / 180);
              var hourClockY = Y + 60 * sin((i * 30 + 285) * pi / 180);
              canvas.drawLine(center, Offset(minClockX, minClockY), minClock);
              canvas.drawLine(
                  center, Offset(hourClockX, hourClockY), hourClock);
              print(randStunde2.toString() + ":" + randMinute2.toString());
            }
          } else if (randMinute2 == 0) {
            for (int i = 0; i < 24; i++) {
              if (i == randStunde2) {
                var minClockX = X + 80 * cos(270 * pi / 180);
                var minClockY = Y + 80 * sin(270 * pi / 180);
                var hourClockX = X + 60 * cos((i * 30 + 270) * pi / 180);
                var hourClockY = Y + 60 * sin((i * 30 + 270) * pi / 180);
                canvas.drawLine(center, Offset(minClockX, minClockY), minClock);
                canvas.drawLine(
                    center, Offset(hourClockX, hourClockY), hourClock);
                print(randStunde2.toString() + ":" + randMinute2.toString());
              }
            }
          }
        }
      } else if (task.uhr == "viertelStunde") {
        for (int i = 0; i < 24; i++) {
          if (vierMinute2 == 30) {
            if (i == randStunde2) {
              var minClockX = X + 80 * cos(90 * pi / 180);
              var minClockY = Y + 80 * sin(90 * pi / 180);
              var hourClockX = X + 60 * cos((i * 30 + 285) * pi / 180);
              var hourClockY = Y + 60 * sin((i * 30 + 285) * pi / 180);
              canvas.drawLine(center, Offset(minClockX, minClockY), minClock1);
              canvas.drawLine(
                  center, Offset(hourClockX, hourClockY), hourClock1);
              print(randStunde2.toString() + ":" + randMinute2.toString());
            }
          } else if (vierMinute2 == 15) {
            for (int i = 0; i < 24; i++) {
              if (i == randStunde2) {
                var minClockX = X + 80 * cos(360 * pi / 180);
                var minClockY = Y + 80 * sin(360 * pi / 180);
                var hourClockX = X + 60 * cos((i * 30 + 278) * pi / 180);
                var hourClockY = Y + 60 * sin((i * 30 + 278) * pi / 180);
                canvas.drawLine(
                    center, Offset(minClockX, minClockY), minClock1);
                canvas.drawLine(
                    center, Offset(hourClockX, hourClockY), hourClock1);
                print(randStunde2.toString() + ":" + randMinute2.toString());
              }
            }
          } else if (vierMinute2 == 45) {
            for (int i = 0; i < 24; i++) {
              if (i == randStunde2) {
                var minClockX = X + 80 * cos(180 * pi / 180);
                var minClockY = Y + 80 * sin(180 * pi / 180);
                var hourClockX = X + 60 * cos((i * 30 + 293) * pi / 180);
                var hourClockY = Y + 60 * sin((i * 30 + 293) * pi / 180);
                canvas.drawLine(
                    center, Offset(minClockX, minClockY), minClock1);
                canvas.drawLine(
                    center, Offset(hourClockX, hourClockY), hourClock1);
                print(randStunde2.toString() + ":" + randMinute2.toString());
              }
            }
          } else if (vierMinute2 == 0) {
            for (int i = 0; i < 24; i++) {
              if (i == randStunde2) {
                var minClockX = X + 80 * cos(270 * pi / 180);
                var minClockY = Y + 80 * sin(270 * pi / 180);
                var hourClockX = X + 60 * cos((i * 30 + 270) * pi / 180);
                var hourClockY = Y + 60 * sin((i * 30 + 270) * pi / 180);
                canvas.drawLine(
                    center, Offset(minClockX, minClockY), minClock1);
                canvas.drawLine(
                    center, Offset(hourClockX, hourClockY), hourClock1);
                print(randStunde2.toString() + ":" + randMinute2.toString());
              }
            }
          }
        }
      } else if (task.uhr == "allStunden2") {
        for (int j = 0; j < 60; j++) {
          if (j == allMinuten2) {
            for (int i = 0; i < 24; i++) {
              if (i == randStunde2) {
                var minClockX = X + 80 * cos((270 + j * 6) * pi / 180);
                var minClockY = Y + 80 * sin((270 + j * 6) * pi / 180);
                var hourClockX =
                    X + 60 * cos((i * 30 + 270 + j * 0.5) * pi / 180);
                var hourClockY =
                    Y + 60 * sin((i * 30 + 270 + j * 0.5) * pi / 180);
                canvas.drawLine(
                    center, Offset(minClockX, minClockY), minClock1);
                canvas.drawLine(
                    center, Offset(hourClockX, hourClockY), hourClock1);
                print(randStunde2.toString() + ":" + allMinuten2.toString());
              }
            }
          }
        }
      }
      canvas.drawCircle(center, 16, clockCenter);

      var outerClock = rad;
      var innerClock = rad - 20;

      var outerMinute = rad;
      var innerMinute = rad - 14;

      for (double i = 0; i < 360; i += 30) {
        for (double i = 0; i < 360; i += 6) {
          var x1 = X - outerMinute * cos(i * pi / 180);
          var y1 = X - outerMinute * sin(i * pi / 180);

          var x2 = X - innerMinute * cos(i * pi / 180);
          var y2 = X - innerMinute * sin(i * pi / 180);
          canvas.drawLine(Offset(x1, y1), Offset(x2, y2), dashMin);
        }
        var x1 = X - outerClock * cos(i * pi / 180);
        var y1 = X - outerClock * sin(i * pi / 180);

        var x2 = X - innerClock * cos(i * pi / 180);
        var y2 = X - innerClock * sin(i * pi / 180);
        canvas.drawLine(Offset(x1, y1), Offset(x2, y2), dashNum);
      }
    }
  }
}
