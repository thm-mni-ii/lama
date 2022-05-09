import 'dart:math';
import 'dart:io';
import 'package:bubble/bubble.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lama_app/app/bloc/task_bloc.dart';
import 'package:lama_app/app/event/task_events.dart';
import 'dart:convert';

import '../../../util/LamaColors.dart';
import '../../../util/LamaTextTheme.dart';
import '../../task-system/task.dart';

List<String> buchstabenListe;
List<int> buchstabenIndexListe;
List<bool> _canShowButton;

String wort;
String wortURL;
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
    List<String> woerterKeys = task.woerter.keys.toList();
    List<String> woerterURLs = task.woerter.values.toList();
    stringIndex = 0;
    i = 0;
    ergebnisIndex = 0;
    messeLaengeVomWort(holeEinWortAusJSON(
        erstelleEineRandomNummer(), woerterKeys, woerterURLs));
  }

  void hideWidget(i) {
    setState(() {
      _canShowButton[i] = false;
    });
  }
 
 // sleep asynch test, funktioniert noch gar nicht
  Future<void> sleepAsync() async {
    await Future.delayed(Duration(seconds: 10));
  }

  Widget zeichneAntwortButton(buchstabe, ix) {
    return ElevatedButton(
      onPressed: () {
        if (buchstabenListe[stringIndex] == buchstabe) {
          ergebnisBuchstabe = buchstabe;
          hideWidget(ix);
          stringIndex++;
          buchstabenListe[ergebnisIndex] = buchstabe;
          ergebnisIndex++;
        }
        (() {
          if (!_canShowButton[wortLaenge - 1]) {
            if (buchstabenListe.join('') == wort) {
              sleepAsync();
              bool answer = true;
              print(answer);
              setState(() {
                // macht sleep ohne dass letzter Buchstabe auftaucht
                sleep(Duration(seconds: 10));
                BlocProvider.of<TaskBloc>(context)
                    .add(AnswerTaskEvent.initBuchstabieren(answer));
              });
            }
          }
        }());
      },
      child: Text(buchstabe, style: TextStyle(fontSize: 15)),
    );
  }

  Widget zeichneContainerMitAntwortButton(x) {
    return Container(
      margin: EdgeInsets.all(10),
      height: 20.0,
      child: (wortLaenge >= x + 1 &&
              _canShowButton[buchstabenIndexListe[
                  x]]) // hier wid geschaut, ob es noch buchstaben zu vergeben gibt und ob der Knopf schon in der Richtigen Reihenfolge gedrückt wurde
          ? zeichneAntwortButton(
              holeBuchstabe(buchstabenIndexListe[x]),
              buchstabenIndexListe[
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

  String holeEinWortAusJSON(i, wortkey, worturl) {
    wort = "test";
    wort = wortkey[i];
    wortURL = worturl[i];
    buchstabenListe = wort.split('');
    buchstabenIndexListe;
    buchstabenIndexListe = List<int>.filled(wort.length, 0, growable: false);
    for (int x = 0; x < wort.length; x++) {
      buchstabenIndexListe[x] = x;
    }
    buchstabenIndexListe.shuffle();

    _canShowButton = List<bool>.filled(wort.length, true, growable: false);
    for (int x = 0; x < wort.length; x++) {
      _canShowButton[x] = true;
    }

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

  BuchstabierenTaskState(this.task, this.constraints);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
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
            child: Image.network(wortURL),
          ),
          SizedBox(
            height: 20,
          ),

          Container(
            height: MediaQuery.of(context).size.height * 0.2,
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
                      : gefuelltesFeld(buchstabenListe[i])
              ],
            ),
          ),
          Container(
            // legt Größe des Grids fest
            height: MediaQuery.of(context).size.height * 0.3,
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
      ),
    );
  }
}
