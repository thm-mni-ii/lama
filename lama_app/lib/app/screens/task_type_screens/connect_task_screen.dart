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

class ConnectTaskScreen extends StatefulWidget {
  final TaskConnect task;
  final BoxConstraints constraints;

  ConnectTaskScreen(this.task, this.constraints);

  @override
  State<StatefulWidget> createState() {
    return ConnectState(task, constraints);
  }
}

class ConnectState extends State<ConnectTaskScreen> {
  final TaskConnect task;
  final BoxConstraints constraints;
  List<String> givenAnswers;

  ConnectState(this.task, this.constraints) {
    task.pair1.shuffle();
    task.pair2.shuffle();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
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
              )
            ],
          ),
        ),
        Row(
          children: [
            Container(
              width: constraints.maxWidth/3,
              height: (constraints.maxHeight/100)*60,
              child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 1,
                  childAspectRatio: 1 / 1,
                  mainAxisSpacing: 10,
                  ),
                itemCount: task.pair1.length,
                itemBuilder: (context, index) => _buildPair(context, index, task.pair1),
            )
          ),
            Container(
              width: constraints.maxWidth/3,
              height: (constraints.maxHeight/100)*60
            ),
            Container(
                width: constraints.maxWidth/3,
                height: (constraints.maxHeight/100)*60,
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 1,
                    childAspectRatio: 1 / 1,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: task.pair1.length,
                  itemBuilder: (context, index) => _buildPair(context, index, task.pair2),
                )
            ),
          ],
        ),
        SizedBox(
          height: (constraints.maxHeight/100)*5,
        ),
        Container(
          width: (constraints.maxWidth / 100) * 50,
          height: (constraints.maxHeight / 100) * 15,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(20)),
              color: LamaColors.greenAccent,
              boxShadow: [
                BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3))
              ]),
          child: InkWell(
            onTap: () => BlocProvider.of<TaskBloc>(context).add(
                AnswerTaskEvent.initMarkWords(givenAnswers)),
            child: Center(
              child: Text(
                "Fertig!",
                textAlign: TextAlign.center,
                style: LamaTextTheme.getStyle(),
              ),
            ),
          ),
        ),
        SizedBox(
          height: (constraints.maxHeight / 100) * 5,
        )
      ],
    );
  }

  Widget _buildPair(context, index, List<String> pair) {
    return Container(
      height: 7,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(5)),
        color: LamaColors.white,
      ),
      child: Center(
        child: Text(
          pair[index],
          textAlign: TextAlign.center,
          style: LamaTextTheme.getStyle(fontSize: 15)
        ),
      )
    );
  }
}