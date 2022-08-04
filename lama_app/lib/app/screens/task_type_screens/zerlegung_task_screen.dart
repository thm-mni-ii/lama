import 'package:bubble/bubble.dart';
import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lama_app/app/bloc/taskBloc/tts_bloc.dart';
import 'package:lama_app/app/bloc/task_bloc.dart';
import 'package:lama_app/app/event/task_events.dart';
import 'package:lama_app/app/state/tts_state.dart';
import 'package:lama_app/app/task-system/task.dart';
import 'package:lama_app/util/LamaColors.dart';
import 'package:lama_app/util/LamaTextTheme.dart';
import 'dart:math';

import 'package:lama_app/app/event/tts_event.dart';


 
class NumberBox extends StatelessWidget {

  final Function(int value)? onChanged;
  NumberBox({Key? key, this.onChanged}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 10,
      width: MediaQuery.of(context).size.width / 5,
      child: TextField(
        decoration: InputDecoration(
          fillColor: LamaColors.blueAccent,
          hintStyle: LamaTextTheme.getStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
              color: LamaColors.white.withOpacity(0.5)),
          filled: true,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(50)),
              borderSide: BorderSide.none),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(50)),
              borderSide: BorderSide.none),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(50)),
              borderSide: BorderSide.none),
        ),
        onChanged: (value) {
          onChanged!(int.tryParse(value) ?? 0);
        },
        textAlign: TextAlign.center,
        style: TextStyle(
            fontSize: 18,
            letterSpacing: 2,
            fontWeight: FontWeight.w900,
            color: Colors.white),
        keyboardType: TextInputType.number,
      ),
    );
  }
}
 
class ZerlegungTaskScreen extends StatefulWidget {
  ZerlegungTaskScreen({Key? key, this.task, this.constraints}) : super(key: key) {
  }
  final TaskZerlegung? task;
  final BoxConstraints? constraints;


  @override
  State<StatefulWidget> createState() {
    return ZerlegungTaskScreenState(constraints,task!);
  }
}
 
class ZerlegungTaskScreenState extends State<ZerlegungTaskScreen> {
  TextEditingController controller = TextEditingController();
  final BoxConstraints? constraints;
  final TaskZerlegung task;
  var random = Random();
  int? thousands;
  int? hundreds;
  int? tens;
  int? ones;
  int? rightAnswer;
  List<int> _answerParts = [];
  int? givenAnswer;
  bool? answer;
  ZerlegungTaskScreenState(this.constraints, this.task) {
    if (task.zeros!) {
      thousands = random.nextInt(10) * 1000;
      hundreds = random.nextInt(10) * 100;
      tens = random.nextInt(10) * 10;
      ones = random.nextInt(10) * 1;
    } else {
      thousands = (random.nextInt(9) + 1) * 1000;
      hundreds = (random.nextInt(9) + 1) * 100;
      tens = (random.nextInt(9) + 1) * 10;
      ones = (random.nextInt(9) + 1) * 1;
    } 
 
    if (task.boolThousands!) {
      rightAnswer = thousands! + hundreds! + tens! + ones!;
      print (rightAnswer);
    } else {
      rightAnswer = hundreds! + tens! + ones!;
      print (rightAnswer);
    }
  }
 
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _answerParts = List.filled(4, 0);
  }
 
  @override
  Widget build(BuildContext context) {
    String qlang;
    task.questionLanguage == null  ? qlang = "Deutsch" : qlang = task.questionLanguage!;
    String text = "Zerlege die unten angegebene Zahl in Einer, Zehner, Hunderter und Tausender!";
    String text2 = "Zerlege die unten angegebene Zahl in Einer, Zehner und Hunderter!";
    return BlocProvider(
      create: (context) => TTSBloc(),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
          padding: EdgeInsets.only(left: 15, right: 15),
          child: Stack(children: [
            Align(
              alignment: Alignment.centerLeft,
              child: BlocBuilder<TTSBloc, TTSState>(
              builder: (context, state) {
                if (state is EmptyTTSState ) {
                  context.read<TTSBloc>().add(QuestionOnInitEvent(
                      task.boolThousands!
                          ? text
                          : text2,qlang));
                }
                return Container(
                margin: EdgeInsets.all(35),
                padding: EdgeInsets.only(left: 30),
                width: MediaQuery.of(context).size.width,
                child: Bubble(
                  nip: BubbleNip.leftCenter,
                  child: InkWell(
                    onTap: () {
                      BlocProvider.of<TTSBloc>(context)
                          .add(ClickOnQuestionEvent.initVoice(task.boolThousands!
                          ? text
                          : text2, qlang));
                    },
                    child: Center(
                      child: Text(
                        task.boolThousands!
                            ? text
                            : text2,
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
                child: Container(
                  margin: EdgeInsets.only(right: 5, left: 3, top: 20),
                  padding: EdgeInsets.only(right: 40),
                  height: 100,
                  child: SvgPicture.asset(
                    "assets/images/svg/lama_head.svg",
                    semanticsLabel: "Lama Anna",
                    width: 60,
                  ),
                )),
          ]),
        ),
        SizedBox(height: 50),
        BlocBuilder<TTSBloc, TTSState>(
          builder: (context, state) {
    return Center(
          child: InkWell(
            onTap: () {
              BlocProvider.of<TTSBloc>(context)
                  .add(ClickOnQuestionEvent.initVoice(rightAnswer.toString(), qlang));
            },
            child: Text(
              rightAnswer.toString(),
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 30),
            ),
          ),
        );
  },
),
        SizedBox(height: 50),
        if (task.boolThousands!) ...[
          Container(
            child: Row(
              children: [
                Expanded(child: Container()),
                Column(
                  children: [
                    Container(
                      height: (constraints!.maxHeight / 100) * 8,
                      child: Text(
                        widget.task!.reverse! ? "E" : "T",
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 35,
                            color: Colors.blue),
                      ),
                    ),
                    Row(
                      children: [
                        NumberBox(onChanged: (value) {
                          _answerParts[0] = value;
                        }),
                      ],
                    )
                  ],
                ),
                
                Expanded(child: Container()),
                Container(
                  height: MediaQuery.of(context).size.height / 10,
                  child: Align(
                    alignment: Alignment(0, 0.7),
                    child: Text(
                      "+",
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
                Expanded(child: Container()),
                Column(
                  children: [
                    Container(
                      height: (constraints!.maxHeight / 100) * 8,
                      child: Text(
                        widget.task!.reverse! ? "Z" : "H",
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 35,
                            color: Colors.pinkAccent),
                      ),
                    ),
                    Row(
                      children: [
                        NumberBox(onChanged: (value) {
                          _answerParts[1] = value;
                        }),
                      ],
                    )
                  ],
                ),
                Expanded(child: Container()),
                Container(
                  height: MediaQuery.of(context).size.height / 10,
                  child: Align(
                    alignment: Alignment(0, 0.7),
                    child: Text(
                      "+",
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
                Expanded(child: Container()),
                Column(
                  children: [
                    Container(
                      height: (constraints!.maxHeight / 100) * 8,
                      child: Text(
                        widget.task!.reverse! ? "H" : "Z",
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 35,
                            color: Colors.blue),
                      ),
                    ),
                    NumberBox(onChanged: (value) {
                      _answerParts[2] = value;
                    }),
                  ],
                ),
                Expanded(child: Container()),
                Container(
                  height: MediaQuery.of(context).size.height / 10,
                  child: Align(
                    alignment: Alignment(0, 0.7),
                    child: Text(
                      "+",
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
                Expanded(child: Container()),
                Column(
                  children: [
                    Container(
                      height: (constraints!.maxHeight / 100) * 8,
                      child: Text(
                        widget.task!.reverse! ? "T" : "E",
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 35,
                            color: Colors.pinkAccent),
                      ),
                    ),
                    NumberBox(onChanged: (value) {
                      _answerParts[3] = value;
                    }),
                  ],
                ),
                Expanded(child: Container()),
              ],
            ),
          ),
        ] else ...[
          Container(
            child: Row(
              children: [
                Expanded(child: Container()),
                Column(
                  children: [
                    Container(
                      height: (constraints!.maxHeight / 100) * 8,
                      child: Text(
                        widget.task!.reverse! ? "E" : "H",
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 35,
                            color: Colors.pinkAccent),
                      ),
                    ),
                    Row(
                      children: [
                        NumberBox(onChanged: (value) {
                          _answerParts[0] = value;
                        }),
                      ],
                    )
                  ],
                ),
                Expanded(child: Container()),
                Container(
                  height: MediaQuery.of(context).size.height / 10,
                  child: Align(
                    alignment: Alignment(0, 0.7),
                    child: Text(
                      "+",
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
                Expanded(child: Container()),
                Column(
                  children: [
                    Container(
                      height: (constraints!.maxHeight / 100) * 8,
                      child: Text(
                        'Z',
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 35,
                            color: Colors.blue),
                      ),
                    ),
                    NumberBox(onChanged: (value) {
                      _answerParts[1] = value;
                    }),
                  ],
                ),
                Expanded(child: Container()),
                Container(
                  height: MediaQuery.of(context).size.height / 10,
                  child: Align(
                    alignment: Alignment(0, 0.7),
                    child: Text(
                      "+",
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
                Expanded(child: Container()),
                Column(
                  children: [
                    Container(
                      height: (constraints!.maxHeight / 100) * 8,
                      child: Text(
                        widget.task!.reverse! ? "H" : "E",
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 35,
                            color: Colors.pinkAccent),
                      ),
                    ),
                    NumberBox(onChanged: (value) {
                      _answerParts[2] = value;
                    }),
                  ],
                ),
                Expanded(child: Container()),
              ],
            ),
          ),
        ],
        Container(
          height: (constraints!.maxHeight / 100) * 25,
          child: Center(
            child: InkWell(
              child: Container(
                height: (constraints!.maxHeight / 100) * 15,
                width: (constraints!.maxWidth / 100) * 70,
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
                if (task.reverse == true){
                  if (task.boolThousands!) {
                  if(_answerParts[3] == thousands){
                    if (_answerParts[2] == hundreds){
                      if(_answerParts[1] == tens){
                        if(_answerParts[0] == ones){
                          answer = true;
                        }
                      }
                    }
                  } 
                  else{
                      answer = false;
                    }
                  
                  } else {
                  if (_answerParts[2] == hundreds){
                      if(_answerParts[1] == tens){
                        if(_answerParts[0] == ones){
                          answer = true;
                        }
                      }
                    } else{
                      answer = false;
                    }
                  }
                } else if (task.boolThousands!) {
                  if(_answerParts[0] == thousands){
                    if (_answerParts[1] == hundreds){
                      if(_answerParts[2] == tens){
                        if(_answerParts[3] == ones){
                          answer = true;
                        }
                      }
                    }
                  } 
                  else{
                      answer = false;
                    }
                  
                } else {
                  if (_answerParts[0] == hundreds){
                      if(_answerParts[1] == tens){
                        if(_answerParts[2] == ones){
                          answer = true;
                        }
                      }
                    } else{
                      answer = false;
                    }
                }
                
              
                BlocProvider.of<TaskBloc>(context).add(AnswerTaskEvent.initZerlegung(answer));
                // todo
              },
            ),
          ),
        ),
      ]),
    );
  }
}