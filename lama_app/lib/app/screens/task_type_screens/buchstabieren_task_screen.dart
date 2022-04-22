import 'dart:math';

import 'package:bubble/bubble.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lama_app/app/bloc/task_bloc.dart';
import 'package:lama_app/app/event/task_events.dart';

import '../../../util/LamaColors.dart';
import '../../../util/LamaTextTheme.dart';
import '../../task-system/task.dart';

final growableList = <int>[
  -1,
  -1,
  -1,
  -1,
  -1
]; //vorab hard gecodet, diese Liste soll dem Index der Buchstaben eines Wortes entsprechen

class BuchstabierenTaskScreen extends StatefulWidget {
  final TaskBuchstabieren task;
  final BoxConstraints constraints;

  BuchstabierenTaskScreen(this.task, this.constraints);

  @override
  State<StatefulWidget> createState() {
    return BuchstabierenTaskState(task, constraints);
  }
}

class BuchstabierenTaskState extends State<BuchstabierenTaskScreen> {
  // task infos and constraints handed over by tasktypeScreen
  final TaskBuchstabieren task;
  final BoxConstraints constraints;
  // Value which is checked after pressing the "fertig" Button
  int i = 0;
  bool answer;

//hier beginnt der erste State der Aufgabe "Buchstabieren"
//zufalls Nummer wird generiert und das erste Wort wird aus eine json gezogen
  void initState() {
    super.initState();
    erstelleEinmaligeRandomNummer();
  }

  Widget zeichneAntwortButton(buchstabe) {
    return ElevatedButton(
      onPressed: () {},
      child: Text(buchstabe, style: TextStyle(fontSize: 15)),
    );
  }

  String holeBuchstabe(i) {
    var losungsWort =
        "Auto"; //task.woerter[randomIntNum]; als beispiel verwenden wir erstmal nur das Wort "Auto", zum randomisieren wird "task.woerter[randomIntNum];" an dieser Stelle implementiert
    String test1 = losungsWort[i];
    return test1;
  }

  void erstelleEinmaligeRandomNummer() {
    setState(() {
      //hier kann eine for schleife für die länge des Wortes ein array mit aufsteigenden Zahlen erstellen, beginnend mit der 0
      growableList[0] = -1;
      growableList[1] = -1;
      growableList[2] = -1;
      growableList[3] = -1;
      growableList[4] = -1;
      var rng = Random();

      for (int y = 0; y < 4;) {
        var randomIntNum = rng.nextInt(4);
        if (!growableList.contains(randomIntNum)) {
          growableList[y] = randomIntNum;
          y++;
        }
      }
      for (int y = 0; y < 4; y++) {
        debugPrint(growableList[y].toString() + 'hier steht die random number');
      }
    });
  }

  BuchstabierenTaskState(this.task, this.constraints);

  @override
  Widget build(BuildContext context) {
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
                    child: Text(
                      "$i " + task.woerter[0],
                      style: LamaTextTheme.getStyle(
                          color: LamaColors.greenAccent, fontSize: 15),
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
        decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.fromLTRB(0, 50, 0, 0),
        height: MediaQuery.of(context).size.height / 5,
        width: MediaQuery.of(context).size.width / 2,
        child: SvgPicture.asset('assets/images/svg/Objects/Auto.svg'),
      ),
      Container(
        margin: EdgeInsets.all(10),
        height: 50.0,
        child: (false ==
                false) //TODO: hier wid geschaut, ob es noch buchstaben zu vergeben gibt
            ? zeichneAntwortButton(holeBuchstabe(growableList[
                0])) //hier soll nun der zufällig ausgewählte Buchstabe noch eingesetzt werden
            : ElevatedButton(
                onPressed:
                    () {}, //wenn in richtiger Reihenfolge gedrückt, dann soll der Buchstabe
                child: Text("Buchstabe konnte nicht geholt werden",
                    style: TextStyle(fontSize: 15)),
              ),
      ),
      Container(
        margin: EdgeInsets.all(10),
        height: 50.0,
        child: (false ==
                false) //TODO: hier wid geschaut, ob es noch buchstaben zu vergeben gibt
            ? zeichneAntwortButton(holeBuchstabe(growableList[
                1])) //hier soll nun der zufällig ausgewählte Buchstabe noch eingesetzt werden
            : ElevatedButton(
                onPressed: () {},
                child: Text("Buchstabe konnte nicht geholt werden",
                    style: TextStyle(fontSize: 15)),
              ),
      ),
      Container(
        margin: EdgeInsets.all(10),
        height: 50.0,
        child: (false ==
                false) //TODO: hier wid geschaut, ob es noch buchstaben zu vergeben gibt
            ? zeichneAntwortButton(holeBuchstabe(growableList[
                2])) //hier soll nun der zufällig ausgewählte Buchstabe noch eingesetzt werden
            : ElevatedButton(
                onPressed: () {},
                child: Text("Buchstabe konnte nicht geholt werden",
                    style: TextStyle(fontSize: 15)),
              ),
      ),
      Container(
        margin: EdgeInsets.all(10),
        height: 50.0,
        child: (false ==
                false) //TODO: hier wid geschaut, ob es noch buchstaben zu vergeben gibt
            ? zeichneAntwortButton(holeBuchstabe(growableList[
                3])) //hier soll nun der zufällig ausgewählte Buchstabe noch eingesetzt werden
            : ElevatedButton(
                onPressed: () {},
                child: Text("Buchstabe konnte nicht geholt werden",
                    style: TextStyle(fontSize: 15)),
              ),
      ),
    ]);
  }
}
