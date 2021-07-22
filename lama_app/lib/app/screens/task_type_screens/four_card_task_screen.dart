import 'package:bubble/bubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lama_app/app/bloc/task_bloc.dart';
import 'package:lama_app/app/event/task_events.dart';
import 'package:lama_app/app/task-system/task.dart';
import 'package:lama_app/util/LamaColors.dart';
import 'package:lama_app/util/LamaTextTheme.dart';

/// [StatelessWidget] that contains the screen for the 4Cards TaskType.
///
/// Author: K.Binder
class FourCardTaskScreen extends StatelessWidget {
  final Task4Cards task;
  final List<String> answers = [];

  //The constraints describe the space useable by the task.
  //Its parent is always a container covering the whole available area
  final BoxConstraints constraints;

  FourCardTaskScreen(this.task, this.constraints) {
    answers.addAll(task.wrongAnswers);
    answers.add(task.rightAnswer);
    print(answers.length);
    answers.shuffle();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Container(
        height: (constraints.maxHeight / 100) * 40,
        width: (constraints.maxWidth),
        padding: EdgeInsets.all(25),
        child: Container(
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
            child: Align(
              child: Text(task.question,
                  textAlign: TextAlign.center,
                  style: LamaTextTheme.getStyle(fontSize: 30)),
            )),
      ),
      Container(
        height: (constraints.maxHeight / 100) * 15,
        padding: EdgeInsets.only(left: 15, right: 15),
        child: Stack(children: [
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
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
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
    ]);
  }

  ///Returns one of the four cards that contain the different answers as [Widget].
  Widget _buildCards(context, index) {
    Color color =
        index % 3 == 0 ? LamaColors.greenAccent : LamaColors.blueAccent;
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
        onTap: () => BlocProvider.of<TaskBloc>(context)
            .add(AnswerTaskEvent(answers[index])),
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
  }
}
