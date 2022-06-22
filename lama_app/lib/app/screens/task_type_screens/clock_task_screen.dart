import 'dart:async';
import 'dart:math';
import 'dart:ui';
import 'package:bubble/bubble.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:lama_app/app/bloc/task_bloc.dart';
import 'package:lama_app/app/event/task_events.dart';
import 'package:lama_app/app/task-system/task.dart';
import 'package:lama_app/util/LamaColors.dart';
import 'package:lama_app/util/LamaTextTheme.dart';

/// Author: H.Bismo

class ClockTaskScreen extends StatefulWidget {
  final ClockTest task;
  final BoxConstraints constraints;
  ClockTaskScreen(this.task, this.constraints);
  //final FlutterTts flutterTts = FlutterTts();

  @override
  State<StatefulWidget> createState() {
    return ClockTaskState(task, constraints);
  }
}

class ClockTaskState extends State<ClockTaskScreen> {
  final TextEditingController controller = TextEditingController();
  final BoxConstraints constraints;
  final ClockTest task;
  ClockPainter bloc;
  final List<String> answers = [];
  int i = 1;
  int timer = 15;
  String showtimer;
  String sonneMond;
  var randStunde;
  var randMinute;
  var halbeMinute;
  var rnd = Random();
  var wrgStunde;
  var wrgMinute;
  var wrgStunde2;
  var wrgMinute2;
  var wrgStunde3;
  var wrgMinute3;
  var wrgStunde4;
  var wrgMinute4;
  var wrgMinute5;
  var wrgMinute6;
  var vierMinute;
  var allMinuten;
  List<String> wrongAnswer;

  final FlutterTts flutterTts = FlutterTts();
  String selectedAnswer = "leer";

  readText(String text) async {

    await flutterTts.setLanguage("de-De");
    await flutterTts.setVolume(1.0);
    await flutterTts.speak(text);
  }

  readQuestion() async {
    var text = task.lamaText;
    await flutterTts.setLanguage("de-De");
    await flutterTts.speak(text);
  }


  confirmAnswer(String answer, index) {
    if(answer != selectedAnswer) {
      readText(answer);
    } else {
      BlocProvider.of<TaskBloc>(context)
          .add(AnswerTaskEvent(answers[index]));
    }
  }

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

  ClockTaskState(this.task, this.constraints) {
    this.allMinuten = rnd.nextInt(60);
    this.wrgStunde2 = rnd.nextInt(24);
    this.wrgMinute2 = rnd.nextInt(2) * 30;
    this.wrgStunde = rnd.nextInt(24);
    this.wrgMinute = 0;
    this.wrgStunde3 = rnd.nextInt(24);
    this.wrgMinute3 = rnd.nextInt(4) * 15;
    this.wrgStunde4 = rnd.nextInt(24);
    this.wrgMinute4 = 0;
    this.wrgMinute5 = rnd.nextInt(2) * 30;
    this.wrgMinute6 = rnd.nextInt(4) * 15;
    this.randStunde = rnd.nextInt(24);
    this.randMinute = 0;
    this.halbeMinute = rnd.nextInt(2) * 30;
    this.vierMinute = rnd.nextInt(4) * 15;

    bloc = ClockPainter(task, constraints, this.randStunde, this.randMinute,
        this.vierMinute, this.allMinuten, this.halbeMinute);
    task.rightAnswer = bloc.strAnswer();
    answers.add(task.rightAnswer); //get the right answer
    answers.add(wrgAnswer());
    answers.add(wrgAnswer2()); // add the wrong answers
    answers.shuffle();
    print(answers);

    readQuestion();
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


  String wrgAnswer() {
    while (this.wrgStunde == this.randStunde && (this.wrgMinute == this.randMinute || this.wrgMinute2 == this.halbeMinute || this.wrgMinute3 == this.vierMinute)){
      this.wrgStunde = rnd.nextInt(24);
      this.wrgMinute2 = rnd.nextInt(2) * 30;
      this.wrgMinute3 = rnd.nextInt(4) * 15;
    }
      if (task.uhr == "halbeStunde") {
           if (this.wrgMinute2 == 0){
             if(this.wrgStunde < 10){
               return "0" + this.wrgStunde.toString() + ":" + "00";
             } else {
               return this.wrgStunde.toString() + ":" + "00";
             }
            } else{
              if (this.wrgMinute2 < 10){
                if(this.wrgStunde < 10){
                  return "0" + this.wrgStunde.toString() + ":" + "0" + this.wrgMinute2.toString();
                } else{
                  return this.wrgStunde.toString() + ":" + "0" + this.wrgMinute2.toString();
                }
              } else {
                if(this.wrgStunde < 10){
                  return "0" + this.wrgStunde.toString() + ":" + this.wrgMinute2.toString();
                } else {
                  return this.wrgStunde.toString() + ":" + this.wrgMinute2.toString();
                }
              }
            }
        } else if (task.uhr == "vollStunde") {
        if (this.wrgStunde < 10) {
          return "0" + this.wrgStunde.toString() + ":" + "00";
        } else {
          return this.wrgStunde.toString() + ":" + "0" + this.wrgMinute.toString();
        }
      } else if (task.uhr == "viertelStunde") {
          if (this.wrgMinute3 == 0){
             if(this.wrgStunde < 10){
               return "0" + this.wrgStunde.toString() + ":" + "00";
             } else {
               return this.wrgStunde.toString() + ":" + "00";
             }
            } else{
              if (this.wrgMinute3 < 10){
                if(this.wrgStunde < 10){
                  return "0" + this.wrgStunde.toString() + ":" + "0" + this.wrgMinute3.toString();
                } else{
                  return this.wrgStunde.toString() + ":" + "0" + this.wrgMinute3.toString();
                }
              } else {
                if(this.wrgStunde < 10){
                  return "0" + this.wrgStunde.toString() + ":" + this.wrgMinute3.toString();
                } else {
                  return this.wrgStunde.toString() + ":" + this.wrgMinute3.toString();
                }
              }
            }
        } else if (task.uhr == "allStunden"){
          return this.wrgStunde.toString() + this.wrgMinute3.toString();
        } 
        return wrgAnswer();
  }

  String wrgAnswer2() {
    while (this.wrgStunde3 == this.randStunde && (this.wrgMinute4 == this.randMinute || this.wrgMinute5 == this.halbeMinute || this.wrgMinute6 == this.vierMinute)){
      this.wrgStunde3 = rnd.nextInt(24);
      this.wrgMinute5 = rnd.nextInt(2) * 30;
      this.wrgMinute6 = rnd.nextInt(4) * 15;
    }
      if (task.uhr == "halbeStunde") {
           if (this.wrgMinute5 == 0){
             if(this.wrgStunde3 < 10){
               return "0" + this.wrgStunde3.toString() + ":" + "00";
             } else {
               return this.wrgStunde3.toString() + ":" + "00";
             }
            } else{
              if (this.wrgMinute5 < 10){
                if(this.wrgStunde3 < 10){
                  return "0" + this.wrgStunde3.toString() + ":" + "0" + this.wrgMinute5.toString();
                } else{
                  return this.wrgStunde3.toString() + ":" + "0" + this.wrgMinute5.toString();
                }
              } else {
                if(this.wrgStunde3 < 10){
                  return "0" + this.wrgStunde3.toString() + ":" + this.wrgMinute5.toString();
                } else {
                  return this.wrgStunde3.toString() + ":" + this.wrgMinute5.toString();
                }
              }
            }
        } else if (task.uhr == "vollStunde") {
        if (this.wrgStunde3 < 10) {
          return "0" + this.wrgStunde3.toString() + ":" + "0" + this.wrgMinute4.toString();
        } else {
          return this.wrgStunde3.toString() + ":" + "0" + this.wrgMinute4.toString();
        }
      } else if (task.uhr == "viertelStunde") {
          if (this.wrgMinute6 == 0){
             if(this.wrgStunde3 < 10){
               return "0" + this.wrgStunde3.toString() + ":" + "00";
             } else {
               return this.wrgStunde3.toString() + ":" + "00";
             }
            } else{
              if (this.wrgMinute6 < 10){
                if(this.wrgStunde3 < 10){
                  return "0" + this.wrgStunde3.toString() + ":" + "0" + this.wrgMinute6.toString();
                } else{
                  return this.wrgStunde3.toString() + ":" + "0" + this.wrgMinute6.toString();
                }
              } else {
                if(this.wrgStunde3 < 10){
                  return "0" + this.wrgStunde3.toString() + ":" + this.wrgMinute6.toString();
                } else {
                  return this.wrgStunde3.toString() + ":" + this.wrgMinute6.toString();
                }
              }
            }
        } else if (task.uhr == "allStunden"){
          return this.wrgStunde.toString() + this.wrgMinute3.toString();
        }
        return wrgAnswer2();
  }

  @override
  Widget build(BuildContext context) {
    if (task.uhr == "allStunden") {
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
                          randMinute, vierMinute, allMinuten,halbeMinute)),
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
                        showtimer,
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
    } else{
      return Column(children: [
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
                      child: InkWell(
                        onTap: () {
                          readText(task.lamaText);
                        },
                        child: Text(
                          // doing
                          task.lamaText,
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
                    painter: ClockPainter(
                        task,
                        constraints,
                        randStunde,
                        randMinute,
                        vierMinute,
                        allMinuten,
                        halbeMinute)),
              )),
        ),
        Container(
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
                    showtimer,
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
                    color: answers[0] == selectedAnswer ? LamaColors.purpleAccent: LamaColors.greenAccent,
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 1,
                          blurRadius: 7,
                          offset: Offset(0, 3)),
                    ]),
                child: InkWell(

                  onTap: () {
                    confirmAnswer(answers[0], 0);
                    setState(() {
                      selectedAnswer = answers[0];
                    });
                  },
                  child: Center(
                    child: Text(
                      answers[0],
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
                    color: answers[1] == selectedAnswer ? LamaColors.purpleAccent: LamaColors.greenAccent,
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 1,
                          blurRadius: 7,
                          offset: Offset(0, 3))
                    ]),
                child: InkWell(
                  onTap: () {
                    confirmAnswer(answers[1], 1);
                    setState(() {
                      selectedAnswer = answers[1];
                    });
                  },
                  child: Center(
                    child: Text(
                      answers[1],
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
                    color: answers[2] == selectedAnswer ? LamaColors.purpleAccent: LamaColors.greenAccent,
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 1,
                          blurRadius: 7,
                          offset: Offset(0, 3))
                    ]),
                child: InkWell(
                onTap: () {
                  confirmAnswer(answers[2], 2);
                  setState(() {
                  selectedAnswer = answers[2];
                  });
                  },
                  child: Center(
                    child: Text(
                      answers[2],
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
        )
      ]);
    }
  }
    }
      


class ClockPainter extends CustomPainter {
  final ClockTest task;
  var allMinuten;
  var rnd = Random();
  var randStunde;
  var randMinute;
  var vierMinute;
  var halbeMinute;
  final BoxConstraints constraints;

  ClockPainter(this.task, this.constraints, randStunde, randMinute, vierMinute,
      allMinuten, halbeMinute) {
    this.randStunde = randStunde;
    this.randMinute = randMinute;
    this.vierMinute = vierMinute;
    this.allMinuten = allMinuten;
    this.halbeMinute = halbeMinute;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return true;
  }

  String strAnswer() {
    if (task.uhr == "halbeStunde") {
      if (this.halbeMinute == 0) {
        if (this.randStunde < 10) {
          return "0" + this.randStunde.toString() + ":" + "0" + this.halbeMinute.toString();
        } else {
          return this.randStunde.toString() + ":" + "0" + this.halbeMinute.toString();
        }
      } else {
        if (this.randStunde < 10) {
          return "0" +
              this.randStunde.toString() + ":" + this.halbeMinute.toString();
        } else{
            return this.randStunde.toString() + ":" + this.halbeMinute.toString();
        }
        
      }
    } else if (task.uhr == "vollStunde") {
      if (this.randStunde < 10) {
        return "0" + this.randStunde.toString() + ":" + "0" + this.randMinute.toString();
      } else {
        return this.randStunde.toString() + ":" + "0" + this.randMinute.toString();
      }
    } else if (task.uhr == "viertelStunde") {
      if (this.vierMinute == 0) {
        if (this.randStunde < 10) {
          return "0" + this.randStunde.toString() + ":" + "0" + this.vierMinute.toString();
        } else {
          return this.randStunde.toString() + ":" + "0" + this.vierMinute.toString();
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
    } return strAnswer();
  }

  @override
  void paint(Canvas canvas, Size size) {
    // TODO: implement paint
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
          RadialGradient(colors: [Colors.lightBlue, Colors.blueAccent[700]])
              .createShader(Rect.fromCircle(center: center, radius: rad))
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 10;

    var hourClock = Paint()
      ..shader = RadialGradient(colors: [Color(0xFFEA74AB), Color(0xFFC279FB)])
          .createShader(Rect.fromCircle(center: center, radius: rad))
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 16;
    var minClock1 = Paint()
      ..shader =
          RadialGradient(colors: [Colors.indigo[600], Colors.blueAccent[700]])
              .createShader(Rect.fromCircle(center: center, radius: rad))
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 10;

    var hourClock1 = Paint()
      ..shader =
          RadialGradient(colors: [Colors.indigo[600], Colors.blueAccent[700]])
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
        if (halbeMinute == 30) {
          if (i == randStunde) {
            var minClockX = X + 80 * cos(90 * pi / 180);
            var minClockY = Y + 80 * sin(90 * pi / 180);
            var hourClockX = X + 60 * cos((i * 30 + 285) * pi / 180);
            var hourClockY = Y + 60 * sin((i * 30 + 285) * pi / 180);
            canvas.drawLine(center, Offset(minClockX, minClockY), minClock);
            canvas.drawLine(center, Offset(hourClockX, hourClockY), hourClock);
            print(randStunde.toString() + ":" + halbeMinute.toString());
          }
        } else if (halbeMinute == 0) {
          for (int i = 0; i < 24; i++) {
            if (i == randStunde) {
              var minClockX = X + 80 * cos(270 * pi / 180);
              var minClockY = Y + 80 * sin(270 * pi / 180);
              var hourClockX = X + 60 * cos((i * 30 + 270) * pi / 180);
              var hourClockY = Y + 60 * sin((i * 30 + 270) * pi / 180);
              canvas.drawLine(center, Offset(minClockX, minClockY), minClock);
              canvas.drawLine(
                  center, Offset(hourClockX, hourClockY), hourClock);
              print(randStunde.toString() + ":" + halbeMinute.toString());
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
            canvas.drawLine(center, Offset(hourClockX, hourClockY), hourClock1);
            print(randStunde.toString() + ":" + randMinute.toString());
          }
        } else if (vierMinute == 15) {
          for (int i = 0; i < 24; i++) {
            if (i == randStunde) {
              var minClockX = X + 80 * cos(360 * pi / 180);
              var minClockY = Y + 80 * sin(360 * pi / 180);
              var hourClockX = X + 60 * cos((i * 30 + 278) * pi / 180);
              var hourClockY = Y + 60 * sin((i * 30 + 278) * pi / 180);
              canvas.drawLine(center, Offset(minClockX, minClockY), minClock1);
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
              canvas.drawLine(center, Offset(minClockX, minClockY), minClock1);
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
              canvas.drawLine(center, Offset(minClockX, minClockY), minClock1);
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
              canvas.drawLine(center, Offset(minClockX, minClockY), minClock1);
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
