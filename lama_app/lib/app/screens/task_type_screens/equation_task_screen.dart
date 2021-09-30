import 'dart:math';
import 'package:bubble/bubble.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lama_app/app/bloc/taskBloc/equation_bloc.dart';
import 'package:lama_app/app/bloc/task_bloc.dart';
import 'package:lama_app/app/event/task_events.dart';
import 'package:lama_app/app/task-system/task.dart';
import 'package:lama_app/util/LamaColors.dart';
import 'package:lama_app/util/LamaTextTheme.dart';
import 'package:lama_app/util/OperatorWidget.dart';

/// [StatefulWidget] that contains the screen for the Equation TaskType
///
///
/// Author: K. Binder
/// Basic Layout Author: F. Leonhardt
class EquationTaskScreen extends StatefulWidget {
  final BoxConstraints constraints;
  final TaskEquation task;

  EquationTaskScreen(this.task, this.constraints);

  @override
  State<StatefulWidget> createState() {
    return EquationTaskState(task, constraints);
  }
}

/// [State] that contains the UI side logic for the Equation TaskType
///
/// Author: K. Binder
/// Basic Layout Author: F. Leonhardt
class EquationTaskState extends State<EquationTaskScreen> {
  final BoxConstraints constraints;
  final TaskEquation task;
  EquationBloc bloc;
  EquationTaskState(this.task, this.constraints) {
    bloc = EquationBloc(task);
  }

  @override
  void initState() {
    super.initState();
    if (task.isRandom)
      bloc.add(RandomEquationEvent());
    else
      bloc.add(NonRandomEquationEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<EquationBloc>(
      create: (context) => bloc,
      child: BlocBuilder<EquationBloc, EquationState>(
        builder: (context, state) {
          if (state is BuiltEquationState) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildLamaText(),
                Container(
                  //EQUATION
                  width: constraints.maxWidth,
                  height: (constraints.maxHeight / 100) * 7,
                  child: _buildEquation(state.equationItems),
                ),
                SizedBox(
                  height: (constraints.maxHeight / 100) * 10,
                ),
                Container(
                  //OPERATORS
                  width: constraints.maxWidth,
                  height: (constraints.maxHeight / 100) * 7,
                  child: _mathOperations(context),
                ),
                SizedBox(
                  height: (constraints.maxHeight / 100) * 1,
                ),
                Container(
                  //ANSWERS
                  width: constraints.maxWidth,
                  height: (constraints.maxHeight / 100) * 30,
                  child: _buildAnswers(state.answers),
                ),
                SizedBox(
                  height: (constraints.maxHeight / 100) * 1,
                ),
                Container(
                  height: (constraints.maxHeight / 100) * 10,
                  child: Align(
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [_buildResetButton(), _buildSubmitButton()],
                    ),
                  ),
                ),
                SizedBox(
                  height: (constraints.maxHeight / 100) * 1,
                )
              ],
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }

  ///Returns the anna saying the lama_text in a speechbubble
  Widget _buildLamaText() {
    return Container(
      padding: EdgeInsets.only(left: 15, right: 15),
      height: (constraints.maxHeight / 100) * 30,
      width: (constraints.maxWidth),
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
                        fontSize: 15, color: LamaColors.black),
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
    );
  }

  Widget _buildResetButton() {
    return Container(
      height: (constraints.maxHeight / 100) * 10,
      width: (constraints.maxWidth / 100) * 35,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          color: LamaColors.redAccent,
          boxShadow: [
            BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 7,
                offset: Offset(0, 3))
          ]),
      child: InkWell(
        child: IconButton(
            padding: EdgeInsets.all(1.0),
            icon: Icon(
              Icons.replay_rounded,
              size: 40,
            ),
            color: LamaColors.white,
            onPressed: () {
              bloc.add(EquationResetEvent());
            }),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return Container(
      width: (constraints.maxWidth / 100) * 35,
      height: (constraints.maxHeight / 100) * 10,
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
        onTap: () {
          BlocProvider.of<TaskBloc>(context)
              .add(AnswerTaskEvent.initEquationNew(bloc.currentEquation));
        },
        child: Center(
          child: Text(
            "Fertig!",
            textAlign: TextAlign.center,
            style: LamaTextTheme.getStyle(),
          ),
        ),
      ),
    );
  }

  /// Return possible answers for equation in [GridView] as [Widget]
  Widget _buildAnswers(List<String> answerList) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 5,
              childAspectRatio: 0.01 / 0.01,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10),
          itemCount: answerList.length,
          itemBuilder: (context, index) {
            return Draggable<String>(
              data: answerList[index],
              childWhenDragging: EquationItemWidget(
                  constraints, LamaColors.bluePrimary, answerList[index],
                  fontSize: 20),
              child: EquationItemWidget(
                  constraints, LamaColors.blueAccent, answerList[index],
                  fontSize: 20),
              feedback: Material(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                child: EquationItemWidget(
                    constraints, LamaColors.blueAccent, answerList[index]),
              ),
            );
          },
        ),
      ),
    );
  }

  /// Return equation and chose if the build container is a dragtarget or not as [Widget]
  Widget _buildEquation(List<String> equation) {
    return Center(
        child: ListView.separated(
            separatorBuilder: (context, index) => SizedBox(
                  width: (constraints.maxWidth / 100) * 2,
                ),
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            itemCount: equation.length,
            itemBuilder: (BuildContext context, index) {
              return (equation[index] != "?")
                  ? _equationField(context, equation[index])
                  : _equationTarget(context, equation[index], index);
            }));
  }

  /// Return a container for equation which is a dragtarget as [Widget]
  Widget _equationTarget(BuildContext context, String equationItem, index) {
    return DragTarget(
        builder: (context, candidate, rejectedData) => Container(
              width: (constraints.maxWidth / 100) * 12,
              height: (constraints.maxHeight / 100) * 5,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  color: LamaColors.purpleAccent),
              child: Center(
                child: Text(
                  equationItem,
                  textAlign: TextAlign.center,
                  style: LamaTextTheme.getStyle(fontSize: 15),
                ),
              ),
            ),
        onWillAccept: (data) => true,
        onAccept: (data) {
          BlocProvider.of<EquationBloc>(context)
              .add(UpdateEquationEvent(data, index));
        }

        //onLeave: fullAnswer.remove(fullAnswer[fullAnswer.indexOf(data)]),
        );
  }

  /// Return a container for equation which contains the part of equation as [Widget]
  Widget _equationField(BuildContext context, String equationItem) {
    return Container(
      width: (constraints.maxWidth / 100) * 12,
      height: (constraints.maxHeight / 100) * 5,
      alignment: Alignment.center,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          color: LamaColors.purplePrimary),
      child: Center(
        child: Text(
          equationItem,
          textAlign: TextAlign.center,
          style: LamaTextTheme.getStyle(fontSize: 15),
        ),
      ),
    );
  }

  /// Return the math operations as draggable container as [Widget]
  Widget _mathOperations(BuildContext context) {
    final opAdd = EquationItemWidget(constraints, LamaColors.blueAccent, "+");

    final opSub = EquationItemWidget(constraints, LamaColors.blueAccent, "-");

    final opMul = EquationItemWidget(constraints, LamaColors.blueAccent, "*");

    final opDiv = EquationItemWidget(constraints, LamaColors.blueAccent, "/");

    return Container(
      child: Padding(
        padding: EdgeInsets.only(
            left: (constraints.maxWidth / 100) * 22.5,
            right: (constraints.maxWidth / 100) * 22.5),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          Draggable<String>(
            data: "+",
            child: opAdd,
            childWhenDragging:
                EquationItemWidget(constraints, LamaColors.bluePrimary, "+"),
            feedback: Material(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              child: opAdd,
            ),
          ),
          Draggable(
            data: "-",
            child: opSub,
            childWhenDragging:
                EquationItemWidget(constraints, LamaColors.bluePrimary, "-"),
            feedback: Material(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              child: opSub,
            ),
          ),
          Draggable(
            data: "*",
            child: opMul,
            childWhenDragging:
                EquationItemWidget(constraints, LamaColors.bluePrimary, "*"),
            feedback: Material(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              child: Container(child: opMul),
            ),
          ),
          Draggable(
            data: "/",
            child: opDiv,
            childWhenDragging:
                EquationItemWidget(constraints, LamaColors.bluePrimary, "/"),
            feedback: Material(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              child: opDiv,
            ),
          ),
        ]),
      ),
    );
  }
}
