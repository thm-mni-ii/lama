import 'dart:developer';

import 'package:bubble/bubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart';
import 'package:lama_app/app/bloc/task_bloc.dart';
import 'package:lama_app/app/event/task_events.dart';
import 'package:lama_app/app/task-system/task.dart';
import 'package:lama_app/util/LamaColors.dart';
import 'package:lama_app/util/LamaTextTheme.dart';
import 'package:flutter_tts/flutter_tts.dart';

import 'package:lama_app/app/bloc/taskBloc/tts_bloc.dart';
import 'package:lama_app/app/event/tts_event.dart';
import 'package:lama_app/app/state/tts_state.dart';
import 'package:lama_app/app/state/QuestionText.dart';

class FourCardTaskScreenStateful extends StatefulWidget {
  final Task4Cards task;
  final List<String> answers = [];
  final BoxConstraints constraints;

  FourCardTaskScreenStateful(this.task, this.constraints) {
    answers.addAll(task.wrongAnswers);
    answers.add(task.rightAnswer!);
    print(answers.length);
    answers.shuffle();

  }


  @override
  FourCards createState() {
    FourCardTaskScreenStateful(task, constraints);
    return FourCards(task, constraints, answers);
  }


}

class FourCards extends State<FourCardTaskScreenStateful> {

  final Task4Cards task;
  final List<String> answers = [];
  final BoxConstraints constraints;

  //String selectedAnswer = "";


  FourCards(this.task, this.constraints, answers) {
    this.answers.add(answers[0]);
    this.answers.add(answers[1]);
    this.answers.add(answers[2]);
    this.answers.add(answers[3]);
  }



  @override
  Widget build(BuildContext context) {
    String qlang;
    task.questionLanguage == null || task.questionLanguage == "" ||
        task.questionLanguage == "Deutsch" ? qlang = "Deutsch" : qlang = "Englisch";

    return BlocProvider(
      create: (context) => TTSBloc(),
      child: Column(children: [
        Container(
          height: (constraints.maxHeight / 100) * 40,
          width: (constraints.maxWidth),
          padding: EdgeInsets.all(25),
          child: BlocBuilder<TTSBloc, TTSState>(
            builder: (context, TTSState state) {
              if (state is EmptyTTSState) {
                context.read<TTSBloc>().add(QuestionOnInitEvent(task.question!,qlang));
                QuestionText.setText(task.question!, qlang);
              }
              return Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(50)),
                    gradient: LinearGradient(colors: [
                      LamaColors.orangeAccent,
                      LamaColors.orangePrimary
                    ]),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: Offset(0, 3))
                    ]),
                    child: InkWell(
                      onTap: () {
                        BlocProvider.of<TTSBloc>(context)
                            .add(ClickOnQuestionEvent.initVoice(task.question!, qlang));
                      },
                      child: Center(
                        child: Text(task.question!,
                            textAlign: TextAlign.center,
                            style: LamaTextTheme.getStyle(fontSize: 30)
                        ),
                      ),
                    ),
              );
            },
          ),
        ),
        BlocBuilder<TTSBloc, TTSState>(
          builder: (context, state) {
        return Container(
          height: (constraints.maxHeight / 100) * 15,
          padding: EdgeInsets.only(left: 15, right: 15),
          child: Stack(children: [
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
                  child: InkWell(
                    onTap: () {
                      BlocProvider.of<TTSBloc>(context)
                          .add(ClickOnQuestionEvent.initVoice("Tippe doppelt, um die Antwort auszuwählen.", ""));
                    },
                    child: Center(
                      child: Text(
                        "Tippe doppelt, um die Antwort auszuwählen.",
                        style: TextStyle(fontSize: 15,
                            fontWeight: FontWeight.bold),
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
          ]),
        );
  },
),
        Container(
            height: (constraints.maxHeight / 100) * 45,
            child: Padding(
                padding: const EdgeInsets.only(
                  top: 10,
                  left: 5,
                  right: 5,
                ),
                child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 1.6 / 1,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                    ),
                    itemCount: 4,
                    itemBuilder: (context, index) =>
                        _buildCards(context, index)))),

      ]),
    );
  }

  Widget _buildCards(context, index) {
    String alang;
    task.answerLanguage == null || task.answerLanguage == "" ? alang = "Deutsch" : alang = task.answerLanguage!;
    //debugPrint(index);
    Color color =
    index % 3 == 0 ? LamaColors.greenAccent : LamaColors.blueAccent;

    return BlocBuilder<TTSBloc, TTSState>(
      builder: (context, state) {
        return Container(
          height: 50,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(20)),
              color: color,
              boxShadow: [
                BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 1,
                    blurRadius: 7,
                    offset: Offset(0, 3))
              ]),
          child: InkWell(
            onTap: () {
              BlocProvider.of<TTSBloc>(context)
                  .add(ClickOnQuestionEvent.initVoice(answers[index], alang));
                //BlocProvider.of<TTSBloc>(context).
                //add(SetDefaultEvent());
            },
            onDoubleTap: () {
              BlocProvider.of<TaskBloc>(context)
                  .add(AnswerTaskEvent(answers[index]));
            },
            child: Padding(
              padding: EdgeInsets.all(5),
              child: Center(
                child: Text(
                  answers[index],
                  textAlign: TextAlign.center,
                  style: LamaTextTheme.getStyle(),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}