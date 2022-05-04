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

final growableList2 = <String>['', '', '', '', '', '', '', ''];
final growableList = <int>[
  -1,
  -1,
  -1,
  -1,
  -1,
  -1,
  -1,
  -1
]; //vorab hard gecodet, diese Liste soll dem Index der Buchstaben eines Wortes entsprechen

List<bool> _canShowButton = <bool>[
  true,
  true,
  true,
  true,
  true,
  true,
  true,
  true
];

String wort;
int wortLaenge = 0;
int zufallsZahl;
int stringIndex = 0;
int ergebnisIndex = 0;
var ergebnisBuchstabe;

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
//außerdem werden einige Variablen wieder auf ihren ursprünglichen Zustand gestellt-> wichtig für neue Aufgaben
  void initState() {
    super.initState();
    stringIndex = 0;
    i = 0;
    ergebnisIndex = 0;
    for (int x = 0; x < _canShowButton.length; x++) {
      _canShowButton[x] = true;
    }
    messeLaengeVomWort(holeEinWortAusJSON(erstelleEineRandomNummer()));
    erstelleEinmaligeRandomNummer(wortLaenge);
  }

  void hideWidget(i) {
    setState(() {
      _canShowButton[i] = false;
    });
  }

  Widget zeichneAntwortButton(buchstabe, ix) {
    return ElevatedButton(
      onPressed: () {
        if (wort.substring(stringIndex, stringIndex + 1) == buchstabe) {
          ergebnisBuchstabe = buchstabe;
          hideWidget(ix);
          stringIndex++;
          growableList2[ergebnisIndex] = buchstabe;
          ergebnisIndex++;
        }
      },
      child: Text(buchstabe, style: TextStyle(fontSize: 15)),
    );
  }

  Widget zeichneContainerMitAntwortButton(x) {
    return Container(
      margin: EdgeInsets.all(10),
      height: 20.0,
      child: (wortLaenge >= x + 1 &&
              _canShowButton[growableList[
                  x]]) // hier wid geschaut, ob es noch buchstaben zu vergeben gibt und ob der Knopf schon in der Richtigen Reihenfolge gedrückt wurde
          ? zeichneAntwortButton(
              holeBuchstabe(growableList[x]),
              growableList[
                  x]) //hier soll nun der zufällig ausgewählte Buchstabe noch eingesetzt werden
          : null,
    );
  }

  Widget leeresFeld() {
    return Container(
      margin: EdgeInsets.all(10),
      height: 20.0,
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey,
        ),
      ),
    );
  }

  Widget gefuelltesFeld(buchstabe) {
    return Container(
      margin: EdgeInsets.all(10),
      height: 20.0,
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey,
        ),
      ),
      child: Text(buchstabe),
    );
  }

  // width: (constraints.maxWidth / 100) * 12,
  //     height: (constraints.maxHeight / 100) * 5,
  //     alignment: Alignment.center,
  //     decoration: BoxDecoration(
  //         borderRadius: BorderRadius.all(Radius.circular(10)),
  //         color: LamaColors.purplePrimary),

  String holeEinWortAusJSON(i) {
    wort = task.woerter[i];
    return wort;
  }

  int messeLaengeVomWort(i) {
    wortLaenge = i.length;
    return 0;
  }

  String holeBuchstabe(i) {
    var losungsWort = "Auto"; //default wort
    losungsWort = wort;
    String test1 = losungsWort[i];
    return test1;
  }

  int erstelleEineRandomNummer() {
    var rng = Random();
    var zufallsZahl = rng.nextInt(task.woerter
        .length); //hier entsteht eine random Nummer 0..(Anzahl der Wörter in (task.woerter-1))
    return zufallsZahl;
  }

  void erstelleEinmaligeRandomNummer(i) {
    setState(() {
      //hier kann eine for schleife für die länge des Wortes ein array mit aufsteigenden Zahlen erstellen, beginnend mit der 0
      growableList[0] = -1;
      growableList[1] = -1;
      growableList[2] = -1;
      growableList[3] = -1;
      growableList[4] = -1;
      growableList[5] = -1;
      growableList[6] = -1;
      growableList[7] = -1;
      // growableList[8] = -1;

      var rng = Random();

      for (int y = 0; y < i;) {
        var randomIntNum = rng.nextInt(i);
        if (!growableList.contains(randomIntNum)) {
          growableList[y] = randomIntNum;
          y++;
        }
      }
    });
  }

  BuchstabierenTaskState(this.task, this.constraints);

  @override
  Widget build(BuildContext context) {
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
                  height: 60,
                  width: MediaQuery.of(context).size.width,
                  child: Bubble(
                    nip: BubbleNip.leftCenter,
                    child: Center(
                      child: Text(
                        "Buchstabiere das Wort, indem du auf die Buchstaben in der richtigen Reihenfolge drückst",
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
          margin: EdgeInsets.fromLTRB(0, 30, 0, 0),
          height: MediaQuery.of(context).size.height / 5,
          width: MediaQuery.of(context).size.width / 2,
          child: SvgPicture.asset('assets/images/svg/Objects/Auto.svg'),
        ),
        SizedBox(
          height: 20,
        ),

        Container(
          height: MediaQuery.of(context).size.height * 0.1,
          width: MediaQuery.of(context).size.width * 0.9,
          color: Colors.red,
          child: GridView.count(
            crossAxisCount: 5,
            mainAxisSpacing: 20,
            crossAxisSpacing: 20,
            children: [
              for (int i = 0; i < wortLaenge; i++)
                (_canShowButton[i])
                    ? leeresFeld()
                    : gefuelltesFeld(growableList2[i])
            ],
          ),
        ),
        Container(
          // legt Größe des Grids fest
          height: MediaQuery.of(context).size.height * 0.35,
          width: MediaQuery.of(context).size.width * 0.9,
          color: Colors.green,
          child: GridView.count(
            // zeigt Buchstaben in nächster Zeile an, wenn crossAxisCount überschritten wird
            crossAxisCount: 5,
            mainAxisSpacing: 20,
            children: [
              for (int i = 0; i < wortLaenge; i++)
                zeichneContainerMitAntwortButton(i)
            ],
          ),
        ),
      ],
    );
  }
}
