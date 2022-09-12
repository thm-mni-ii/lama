import 'dart:async';
import 'dart:math';
import 'package:bubble/bubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lama_app/app/bloc/task_bloc.dart';
import 'package:lama_app/app/bloc/taskbloc/tts_bloc.dart';
import 'package:lama_app/app/event/task_events.dart';
import 'package:lama_app/app/task-system/task.dart';
import 'package:lama_app/util/LamaColors.dart';
import 'package:lama_app/util/LamaTextTheme.dart';
import 'package:numberpicker/numberpicker.dart';

import '../../event/tts_event.dart';
import '../../state/tts_state.dart';

/// Author: H.Bismo

class ClockDifferentScreen extends StatefulWidget {
  final ClockDifferent task;
  final BoxConstraints constraints;
  ClockDifferentScreen(this.task, this.constraints);

  @override
  State<StatefulWidget> createState() {
    return ClockDifferentState(task, constraints);
  }
}

class ClockDifferentState extends State<ClockDifferentScreen> {
  final TextEditingController controller = TextEditingController();
  final BoxConstraints constraints;
  final ClockDifferent task;
  ClockPainter? bloc;
  ClockPainter2? bloc2;
  final List<String?> answers = [];
  String? sonneMond;
  var mode;
  var randStunde;
  var randMinute;
  var randStunde2;
  var randMinute2;
  var halbeMinute;
  var halbeMinute2;
  var rnd = Random();
  var rnd2 = Random();
  var vierMinute;
  var vierMinute2;
  var allMinuten;
  var allMinuten2;

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

  String setImage2() {
    if (this.randStunde2 < 5 || this.randStunde2 > 17) {
      if (this.randStunde2 == 18 || this.randStunde2 == 19) {
        return sonneMond = "assets/images/png/sunset.png";
      } else {
        return sonneMond = "assets/images/png/moon.png";
      }
    } else {
      if (this.randStunde2 == 5 || this.randStunde2 == 6) {
        return sonneMond = "assets/images/png/sunrise.png";
      } else {
        return sonneMond = "assets/images/png/sun.png";
      }
    }
  }

  String setAM() {
    if (this.randStunde >= 12) {
      return "PM";
    } else {
      return "AM";
    }
  }

  String setAM2() {
    if (this.randStunde2 >= 12) {
      return "PM";
    } else {
      return "AM";
    }
  }

  ClockDifferentState(this.task, this.constraints) {
    this.halbeMinute = rnd.nextInt(2) * 30;
    this.halbeMinute2 = rnd.nextInt(2) * 30;
    this.allMinuten = rnd.nextInt(60);
    this.allMinuten2 = rnd2.nextInt(60);
    this.randStunde = rnd.nextInt(24);
    this.randMinute = rnd.nextInt(2) * 0;
    this.randStunde2 = rnd2.nextInt(24);
    this.randMinute2 = rnd2.nextInt(2) * 0;
    this.vierMinute = rnd.nextInt(4) * 15;
    this.vierMinute2 = rnd2.nextInt(4) * 15;

    print(answers);
    if (task.uhr == "allStunden") {
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
    } else if (task.uhr == "vollStunde") {
      if (this.randStunde2 < this.randStunde) {
        this.midStunde = this.randStunde2 + 24;
        print(this.midStunde);
        this.diffHour = (this.midStunde - this.randStunde).toInt();
      } else {
        this.diffHour = (this.randStunde2 - this.randStunde).toInt();
      }
      this.diffMinute = 0;
    } else if (task.uhr == "halbeStunde") {
      if (this.randStunde2 < this.randStunde) {
        this.midStunde = this.randStunde2 + 24;
        print(this.midStunde);
        this.diffHour = (this.midStunde - this.randStunde - 1).toInt();
      } else if (this.randStunde2 == this.randStunde &&
          this.halbeMinute2 < this.halbeMinute) {
        this.midStunde = this.randStunde2 + 24;
        print(this.midStunde);
        this.diffHour = (this.midStunde - this.randStunde - 1).toInt();
      } else {
        this.diffHour = (this.randStunde2 - this.randStunde - 1).toInt();
      }
      this.diffMinute =
          (this.halbeMinute2 % 100 + (60 - this.halbeMinute % 100)).toInt();
      if (this.diffMinute >= 60) {
        this.diffHour++;
        this.diffMinute = this.diffMinute - 60;
      }
    } else if (task.uhr == "viertelStunde") {
      if (this.randStunde2 < this.randStunde) {
        this.midStunde = this.randStunde2 + 24;
        print(this.midStunde);
        this.diffHour = (this.midStunde - this.randStunde - 1).toInt();
      } else if (this.randStunde2 == this.randStunde &&
          this.vierMinute2 < this.vierMinute) {
        this.midStunde = this.randStunde2 + 24;
        print(this.midStunde);
        this.diffHour = (this.midStunde - this.randStunde - 1).toInt();
      } else {
        this.diffHour = (this.randStunde2 - this.randStunde - 1).toInt();
      }
      this.diffMinute =
          (this.vierMinute2 % 100 + (60 - this.vierMinute % 100)).toInt();
      if (this.diffMinute >= 60) {
        this.diffHour++;
        this.diffMinute = this.diffMinute - 60;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    print(this.randStunde.toString() + ":" + this.allMinuten.toString());
    print(this.randStunde2.toString() + ":" + this.allMinuten2.toString());
    print(this.diffHour);
    print(this.diffMinute);

    return BlocProvider(
      create: (context) => TTSBloc(),
  child: SingleChildScrollView(
      child: Column(
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
                  child: BlocBuilder<TTSBloc, TTSState>(
                builder: (context, state) {
                  if (state is EmptyTTSState) {
                    context.read<TTSBloc>().add(QuestionOnInitEvent("Wie viel Zeitunterschied gibt es?","de")); // hard
                  }
                  return InkWell(
                    onTap: () {
                      BlocProvider.of<TTSBloc>(context)
                          .add(ClickOnQuestionEvent.initVoice("Wie viel Zeitunterschied gibt es?", "de"));
                    },
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
                if (task.clockMode == "usMode") ...[
                  Text(setAM(),
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Icon(Icons.arrow_right),
                  Text(setAM2(),
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))
                ] else if (task.clockMode == "gerMode") ...[
                  Image.asset(
                    setImage(),
                    width: 30,
                    height: 30,
                  ),
                  Icon(Icons.arrow_right),
                  Image.asset(
                    setImage2(),
                    width: 30,
                    height: 30,
                  ),
                ]
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
                              randMinute, halbeMinute, vierMinute, allMinuten)),
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
                          painter: ClockPainter2(
                              task,
                              constraints,
                              randStunde2,
                              randMinute2,
                              halbeMinute2,
                              vierMinute2,
                              allMinuten2)),
                    )),
              )
            ],
          ),
          Container(
              height: (constraints.maxHeight / 100) * 10,
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
            height: (constraints.maxHeight / 100) * 10,
            alignment: Alignment.topCenter,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                NumberPicker(
                  itemCount: 1,
                  value: currentValue,
                  maxValue: 23,
                  minValue: 0,
                  onChanged: (value) => setState(() => currentValue = value),
                ),
                Text(":",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                NumberPicker(
                  itemCount: 1,
                  value: currentValue2,
                  maxValue: 59,
                  minValue: 0,
                  onChanged: (value) => setState(() => currentValue2 = value),
                ),
              ],
            ),
          ),
          Container(
            height: (constraints.maxHeight / 100) * 10,
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
                          .add(AnswerTaskEvent.initClockDifferent(correct));
                    } else {
                      BlocProvider.of<TaskBloc>(context)
                          .add(AnswerTaskEvent.initClockDifferent(incorrect));
                    }
                  }),
            ),
          ),
        ],
      ),
    ),
);
  }
}

class ClockPainter extends CustomPainter {
  final ClockDifferent task;
  var halbeMinute;
  var allMinuten;
  var wrgStunde;
  var wrgMinute;
  var rnd = Random();
  var randStunde;
  var randMinute;
  var vierMinute;
  final BoxConstraints constraints;

  ClockPainter(this.task, this.constraints, randStunde, randMinute, halbeMinute,
      vierMinute, allMinuten) {
    this.halbeMinute = halbeMinute;
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
          RadialGradient(colors: [Colors.lightBlue, Colors.blueAccent[700]!])
              .createShader(Rect.fromCircle(center: center, radius: rad))
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 4;

    var hourClock = Paint()
      ..shader = RadialGradient(colors: [Color(0xFFEA74AB), Color(0xFFC279FB)])
          .createShader(Rect.fromCircle(center: center, radius: rad))
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 6;
    var minClock1 = Paint()
      ..shader =
          RadialGradient(colors: [Colors.indigo[600]!, Colors.blueAccent[700]!])
              .createShader(Rect.fromCircle(center: center, radius: rad))
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 4;

    var hourClock1 = Paint()
      ..shader =
          RadialGradient(colors: [Colors.indigo[600]!, Colors.blueAccent[700]!])
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

    if (task.uhr == "vollStunde") {
      for (int i = 0; i < 24; i++) {
        if (i == this.randStunde) {
          var minClockX = X + 80 * cos(270 * pi / 180);
          var minClockY = Y + 80 * sin(270 * pi / 180);
          var hourClockX = X + 50 * cos((i * 30 + 270) * pi / 180);
          var hourClockY = Y + 50 * sin((i * 30 + 270) * pi / 180);
          canvas.drawLine(center, Offset(minClockX, minClockY), minClock);
          canvas.drawLine(center, Offset(hourClockX, hourClockY), hourClock);
          print(randStunde.toString() + ":" + randMinute.toString());
        }
      }
    } else if (task.uhr == "halbeStunde") {
      for (int i = 0; i < 24; i++) {
        if (this.halbeMinute == 30) {
          if (i == this.randStunde) {
            var minClockX = X + 80 * cos(90 * pi / 180);
            var minClockY = Y + 80 * sin(90 * pi / 180);
            var hourClockX = X + 50 * cos((i * 30 + 285) * pi / 180);
            var hourClockY = Y + 50 * sin((i * 30 + 285) * pi / 180);
            canvas.drawLine(center, Offset(minClockX, minClockY), minClock);
            canvas.drawLine(center, Offset(hourClockX, hourClockY), hourClock);
            print(
                this.randStunde.toString() + ":" + this.randMinute.toString());
          }
        } else if (this.halbeMinute == 0) {
          for (int i = 0; i < 24; i++) {
            if (i == this.randStunde) {
              var minClockX = X + 80 * cos(270 * pi / 180);
              var minClockY = Y + 80 * sin(270 * pi / 180);
              var hourClockX = X + 50 * cos((i * 30 + 270) * pi / 180);
              var hourClockY = Y + 50 * sin((i * 30 + 270) * pi / 180);
              canvas.drawLine(center, Offset(minClockX, minClockY), minClock);
              canvas.drawLine(
                  center, Offset(hourClockX, hourClockY), hourClock);
              print(this.randStunde.toString() +
                  ":" +
                  this.randMinute.toString());
            }
          }
        }
      }
    } else if (task.uhr == "viertelStunde") {
      for (int i = 0; i < 24; i++) {
        if (this.vierMinute == 30) {
          if (i == this.randStunde) {
            var minClockX = X + 80 * cos(90 * pi / 180);
            var minClockY = Y + 80 * sin(90 * pi / 180);
            var hourClockX = X + 50 * cos((i * 30 + 285) * pi / 180);
            var hourClockY = Y + 50 * sin((i * 30 + 285) * pi / 180);
            canvas.drawLine(center, Offset(minClockX, minClockY), minClock);
            canvas.drawLine(center, Offset(hourClockX, hourClockY), hourClock);
            print(
                this.randStunde.toString() + ":" + this.randMinute.toString());
          }
        } else if (this.vierMinute == 15) {
          for (int i = 0; i < 24; i++) {
            if (i == this.randStunde) {
              var minClockX = X + 80 * cos(360 * pi / 180);
              var minClockY = Y + 80 * sin(360 * pi / 180);
              var hourClockX = X + 50 * cos((i * 30 + 278) * pi / 180);
              var hourClockY = Y + 50 * sin((i * 30 + 278) * pi / 180);
              canvas.drawLine(center, Offset(minClockX, minClockY), minClock);
              canvas.drawLine(
                  center, Offset(hourClockX, hourClockY), hourClock1);
              print(this.randStunde.toString() +
                  ":" +
                  this.randMinute.toString());
            }
          }
        } else if (this.vierMinute == 45) {
          for (int i = 0; i < 24; i++) {
            if (i == this.randStunde) {
              var minClockX = X + 80 * cos(180 * pi / 180);
              var minClockY = Y + 80 * sin(180 * pi / 180);
              var hourClockX = X + 50 * cos((i * 30 + 293) * pi / 180);
              var hourClockY = Y + 50 * sin((i * 30 + 293) * pi / 180);
              canvas.drawLine(center, Offset(minClockX, minClockY), minClock);
              canvas.drawLine(
                  center, Offset(hourClockX, hourClockY), hourClock);
              print(this.randStunde.toString() +
                  ":" +
                  this.randMinute.toString());
            }
          }
        } else if (this.vierMinute == 0) {
          for (int i = 0; i < 24; i++) {
            if (i == this.randStunde) {
              var minClockX = X + 80 * cos(270 * pi / 180);
              var minClockY = Y + 80 * sin(270 * pi / 180);
              var hourClockX = X + 50 * cos((i * 30 + 270) * pi / 180);
              var hourClockY = Y + 50 * sin((i * 30 + 270) * pi / 180);
              canvas.drawLine(center, Offset(minClockX, minClockY), minClock);
              canvas.drawLine(
                  center, Offset(hourClockX, hourClockY), hourClock);
              print(this.randStunde.toString() +
                  ":" +
                  this.randMinute.toString());
            }
          }
        }
      }
    } else if (task.uhr == "allStunden") {
      for (int j = 0; j < 60; j++) {
        if (j == this.allMinuten) {
          for (int i = 0; i < 24; i++) {
            if (i == this.randStunde) {
              var minClockX = X + 80 * cos((270 + j * 6) * pi / 180);
              var minClockY = Y + 80 * sin((270 + j * 6) * pi / 180);
              var hourClockX =
                  X + 50 * cos((i * 30 + 270 + j * 0.5) * pi / 180);
              var hourClockY =
                  Y + 50 * sin((i * 30 + 270 + j * 0.5) * pi / 180);
              canvas.drawLine(center, Offset(minClockX, minClockY), minClock);
              canvas.drawLine(
                  center, Offset(hourClockX, hourClockY), hourClock);
              print(this.randStunde.toString() +
                  ":" +
                  this.allMinuten.toString());
            }
          }
        }
      }
    }
  }
}

class ClockPainter2 extends CustomPainter {
  final ClockDifferent task;
  var halbeMinute2;
  var allMinuten2;
  var wrgStunde;
  var wrgMinute;
  var rnd2 = Random();
  var randStunde2;
  var randMinute2;
  var vierMinute2;
  final BoxConstraints constraints;

  ClockPainter2(this.task, this.constraints, randStunde2, randMinute2,
      halbeMinute2, vierMinute2, allMinuten2) {
    this.halbeMinute2 = halbeMinute2;
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
          RadialGradient(colors: [Colors.lightBlue, Colors.blueAccent[700]!])
              .createShader(Rect.fromCircle(center: center, radius: rad))
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 4;

    var hourClock = Paint()
      ..shader = RadialGradient(colors: [Color(0xFFEA74AB), Color(0xFFC279FB)])
          .createShader(Rect.fromCircle(center: center, radius: rad))
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 6;
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

    if (task.uhr == "vollStunde") {
      for (int i = 0; i < 24; i++) {
        if (i == this.randStunde2) {
          var minClockX = X + 80 * cos(270 * pi / 180);
          var minClockY = Y + 80 * sin(270 * pi / 180);
          var hourClockX = X + 50 * cos((i * 30 + 270) * pi / 180);
          var hourClockY = Y + 50 * sin((i * 30 + 270) * pi / 180);
          canvas.drawLine(center, Offset(minClockX, minClockY), minClock);
          canvas.drawLine(center, Offset(hourClockX, hourClockY), hourClock);
          print(
              this.randStunde2.toString() + ":" + this.randMinute2.toString());
        }
      }
    } else if (task.uhr == "halbeStunde") {
      for (int i = 0; i < 24; i++) {
        if (this.halbeMinute2 == 30) {
          if (i == this.randStunde2) {
            var minClockX = X + 80 * cos(90 * pi / 180);
            var minClockY = Y + 80 * sin(90 * pi / 180);
            var hourClockX = X + 50 * cos((i * 30 + 285) * pi / 180);
            var hourClockY = Y + 50 * sin((i * 30 + 285) * pi / 180);
            canvas.drawLine(center, Offset(minClockX, minClockY), minClock);
            canvas.drawLine(center, Offset(hourClockX, hourClockY), hourClock);
            print(this.randStunde2.toString() +
                ":" +
                this.randMinute2.toString());
          }
        } else if (this.halbeMinute2 == 0) {
          for (int i = 0; i < 24; i++) {
            if (i == this.randStunde2) {
              var minClockX = X + 80 * cos(270 * pi / 180);
              var minClockY = Y + 80 * sin(270 * pi / 180);
              var hourClockX = X + 50 * cos((i * 30 + 270) * pi / 180);
              var hourClockY = Y + 50 * sin((i * 30 + 270) * pi / 180);
              canvas.drawLine(center, Offset(minClockX, minClockY), minClock);
              canvas.drawLine(
                  center, Offset(hourClockX, hourClockY), hourClock);
              print(this.randStunde2.toString() +
                  ":" +
                  this.randMinute2.toString());
            }
          }
        }
      }
    } else if (task.uhr == "viertelStunde") {
      for (int i = 0; i < 24; i++) {
        if (this.vierMinute2 == 30) {
          if (i == this.randStunde2) {
            var minClockX = X + 80 * cos(90 * pi / 180);
            var minClockY = Y + 80 * sin(90 * pi / 180);
            var hourClockX = X + 50 * cos((i * 30 + 285) * pi / 180);
            var hourClockY = Y + 50 * sin((i * 30 + 285) * pi / 180);
            canvas.drawLine(center, Offset(minClockX, minClockY), minClock);
            canvas.drawLine(center, Offset(hourClockX, hourClockY), hourClock);
            print(this.randStunde2.toString() +
                ":" +
                this.randMinute2.toString());
          }
        } else if (this.vierMinute2 == 15) {
          for (int i = 0; i < 24; i++) {
            if (i == this.randStunde2) {
              var minClockX = X + 80 * cos(360 * pi / 180);
              var minClockY = Y + 80 * sin(360 * pi / 180);
              var hourClockX = X + 50 * cos((i * 30 + 278) * pi / 180);
              var hourClockY = Y + 50 * sin((i * 30 + 278) * pi / 180);
              canvas.drawLine(center, Offset(minClockX, minClockY), minClock);
              canvas.drawLine(
                  center, Offset(hourClockX, hourClockY), hourClock);
              print(this.randStunde2.toString() +
                  ":" +
                  this.randMinute2.toString());
            }
          }
        } else if (this.vierMinute2 == 45) {
          for (int i = 0; i < 24; i++) {
            if (i == this.randStunde2) {
              var minClockX = X + 80 * cos(180 * pi / 180);
              var minClockY = Y + 80 * sin(180 * pi / 180);
              var hourClockX = X + 50 * cos((i * 30 + 293) * pi / 180);
              var hourClockY = Y + 50 * sin((i * 30 + 293) * pi / 180);
              canvas.drawLine(center, Offset(minClockX, minClockY), minClock);
              canvas.drawLine(
                  center, Offset(hourClockX, hourClockY), hourClock);
              print(this.randStunde2.toString() +
                  ":" +
                  this.randMinute2.toString());
            }
          }
        } else if (this.vierMinute2 == 0) {
          for (int i = 0; i < 24; i++) {
            if (i == this.randStunde2) {
              var minClockX = X + 80 * cos(270 * pi / 180);
              var minClockY = Y + 80 * sin(270 * pi / 180);
              var hourClockX = X + 50 * cos((i * 30 + 270) * pi / 180);
              var hourClockY = Y + 50 * sin((i * 30 + 270) * pi / 180);
              canvas.drawLine(center, Offset(minClockX, minClockY), minClock);
              canvas.drawLine(
                  center, Offset(hourClockX, hourClockY), hourClock);
              print(this.randStunde2.toString() +
                  ":" +
                  this.randMinute2.toString());
            }
          }
        }
      }
    } else if (task.uhr == "allStunden") {
      for (int j = 0; j < 60; j++) {
        if (j == this.allMinuten2) {
          for (int i = 0; i < 24; i++) {
            if (i == this.randStunde2) {
              var minClockX = X + 80 * cos((270 + j * 6) * pi / 180);
              var minClockY = Y + 80 * sin((270 + j * 6) * pi / 180);
              var hourClockX =
                  X + 50 * cos((i * 30 + 270 + j * 0.5) * pi / 180);
              var hourClockY =
                  Y + 50 * sin((i * 30 + 270 + j * 0.5) * pi / 180);
              canvas.drawLine(center, Offset(minClockX, minClockY), minClock);
              canvas.drawLine(
                  center, Offset(hourClockX, hourClockY), hourClock);
              print(this.randStunde2.toString() +
                  ":" +
                  this.allMinuten2.toString());
            }
          }
        }
      }
    }
  }
}
