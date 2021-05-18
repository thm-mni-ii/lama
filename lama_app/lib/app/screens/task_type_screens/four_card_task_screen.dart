import 'package:bubble/bubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lama_app/app/bloc/task_bloc.dart';
import 'package:lama_app/app/event/task_events.dart';
import 'package:lama_app/app/state/task_state.dart';
import 'package:lama_app/app/task-system/task.dart';

class FourCardTaskScreen extends StatelessWidget {
  final String subject;
  final Task4Cards task;
  final List<String> answers = [];

  FourCardTaskScreen(this.subject, this.task) {
    answers.addAll(task.wrongAnswers);
    answers.add(task.rightAnswer);
    print(answers.length);
    answers.shuffle();
  }

  @override
  Widget build(BuildContext context) {
    LinearGradient lg;
    switch (subject) {
      case "Mathe":
        lg = LinearGradient(colors: [Colors.lightBlue, Colors.blue]);
        break;
      case "Englisch":
        lg = LinearGradient(colors: [Colors.orange, Colors.deepOrange]);
        break;
      case "Deutsch":
        lg = LinearGradient(colors: [Colors.pink, Colors.redAccent[400]]);
        break;
    }
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: lg),
        child: SafeArea(
          child: Container(
            color: Colors.white,
            child: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
              return Column(
                children: [
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
                              color: Colors.white,
                            ),
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                        ),
                        Text(subject,
                            style:
                                TextStyle(fontSize: 30, color: Colors.white)),
                      ],
                    ),
                  ),
                  Container(
                    height: (constraints.maxHeight / 100) * 92.5,
                    child: LayoutBuilder(builder:
                        (BuildContext context, BoxConstraints constraints) {
                      return Column(children: [
                        Container(
                          height: (constraints.maxHeight / 100) * 40,
                          width: (constraints.maxWidth),
                          padding: EdgeInsets.all(25),
                          child: Container(
                              decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(50)),
                                  gradient: LinearGradient(colors: [
                                    Colors.orangeAccent,
                                    Colors.deepOrange
                                  ]),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.grey.withOpacity(0.5),
                                        spreadRadius: 5,
                                        blurRadius: 7,
                                        offset: Offset(0, 3))
                                  ]),
                              child: Align(
                                child: Text(
                                  task.question,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 30,
                                    color: Colors.white,
                                  ),
                                ),
                              )),
                        ),
                        Container(
                          height: (constraints.maxHeight / 100) * 20,
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
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
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
                            height: (constraints.maxHeight / 100) * 40,
                            child: Padding(
                                padding: const EdgeInsets.only(
                                  top: 10,
                                  left: 5,
                                  right: 5,
                                ),
                                child: GridView.builder(
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      childAspectRatio: 1.6 / 1,
                                      mainAxisSpacing: 10,
                                      crossAxisSpacing: 10,
                                    ),
                                    itemCount: 4,
                                    itemBuilder: (context, index) =>
                                        _buildCards(context, index)))),
                      ]);
                    }),
                  )
                ],
              );
            }),
          ),
        ),
      ),
    );
  }

  Widget _buildCards(context, index) {
    Color color = index % 3 == 0 ? Colors.lightGreen : Colors.lightBlue;
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
              style: TextStyle(color: Colors.white, fontSize: 25),
            ),
          ),
        ),
      ),
    );
  }
}
