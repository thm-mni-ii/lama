import 'package:bubble/bubble.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lama_app/app/bloc/task_bloc.dart';
import 'package:lama_app/app/event/task_events.dart';

import '../../../util/LamaColors.dart';
import '../../../util/LamaTextTheme.dart';
import '../../task-system/task.dart';

List<String> buchstabenListe;
List<int> buchstabenIndexListe;
List<bool> _canShowButton;
List<bool> _canShowAntwortButton;

String wort;
String wortURL;
int wortLaenge = 0;
int zufallsZahl;
int stringIndex = 0;
int ergebnisIndex = 0;
var ergebnisBuchstabe;
int fehlerZaehler = 0;
int maxFehlerAnzahl = 0;

class BuchstabierenTaskScreen extends StatefulWidget {
  final TaskBuchstabieren task;
  final BoxConstraints constraints;
  Image pictureFromNetwork;
  int randomNummer;

  BuchstabierenTaskScreen(
      this.task, this.constraints, this.pictureFromNetwork, this.randomNummer);

  @override
  State<StatefulWidget> createState() {
    return BuchstabierenTaskState(
        task, constraints, pictureFromNetwork, randomNummer);
  }
}

class BuchstabierenTaskState extends State<BuchstabierenTaskScreen> {
  // task infos and constraints handed over by tasktypeScreen
  final TaskBuchstabieren task;
  final BoxConstraints constraints;
  Image pictureFromNetwork;
  int randomNummer;

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
    fehlerZaehler = 0;

    messeLaengeVomWort(
        holeEinWortAusJSON(randomNummer, woerterKeys, woerterURLs));
  }

  void hideWidget(i) {
    setState(() {
      _canShowButton[i] = false;
    });
  }

  void showWidget(i) {
    setState(() {
      _canShowAntwortButton[i] = true;
    });
  }

//
  Widget zeichneAntwortButton(buchstabe, ix) {
    return ElevatedButton(
      onPressed: () {
        //hier wird überprüft, ob der Buchstabe des Buttons
        //gleich dem nächsten korrekt,anzuklickendem Buchstaben ist
        if (buchstabenListe[stringIndex] == buchstabe) {
          // && ergebnisIndex == ix) {  //vorablösung
          ergebnisBuchstabe = buchstabe;
          hideWidget(
              ix); //ix stand davor da , dies ersetzt die Vorablösung, sodass nun immer der richtige Buchstabe der Reihe nach eingetragen wird.
          showWidget(stringIndex);
          stringIndex++;
          buchstabenListe[ergebnisIndex] = buchstabe;
          ergebnisIndex++;
        } else {
          fehlerZaehler++;
          if (fehlerZaehler > maxFehlerAnzahl) {
            Future.delayed(const Duration(milliseconds: 500), () {
              setState(() {
                BlocProvider.of<TaskBloc>(context)
                    .add(AnswerTaskEvent.initBuchstabieren(false));
              });
            });
          }
        }
      },
      style: ElevatedButton.styleFrom(
        shadowColor: Colors.black,
        elevation: 10,
      ),
      child: Text(buchstabe, style: LamaTextTheme.getStyle(fontSize: 30)),
    );
  }

//ein Container, welcher einen klickbaren Button mit einem Buchstaben beinhaltet
//wurde er in richtiger Reihenfolge angeklickt, wird er auf "null" gesetzt
//Falls seine größe im Zustand "null" nicht angepasst wird, so wird eine andere Lösung benötigt
  Widget zeichneContainerMitAntwortButton(x) {
    return Container(
      alignment: Alignment.center,
      // margin: EdgeInsets.all(10),
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
    return Expanded(
      flex: 1,
      child: Container(
        margin: EdgeInsets.all(8),
        decoration: BoxDecoration(
          border: Border(
              bottom: BorderSide(
            color: Colors.black,
          )),
        ),
      ),
    );
  }

  Widget gefuelltesFeld(buchstabe) {
    return Expanded(
      flex: 1,
      child: Container(
        alignment: Alignment.bottomCenter,
        //margin: EdgeInsets.all(10),
        //height: 20.0,
        /* decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey,
          ),
        ), */
        child: Text(buchstabe,
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
      ),
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

    //hier wird die Menge an benötigter Buttons festgelegt, welche die Antwortbuchstaben beihalten
    _canShowButton = List<bool>.filled(wort.length, true, growable: false);

    _canShowAntwortButton =
        List<bool>.filled(wort.length, true, growable: false);

    for (int x = 0; x < wort.length; x++) {
      _canShowButton[x] = true;
      _canShowAntwortButton[x] = false;
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

  BuchstabierenTaskState(
      this.task, this.constraints, this.pictureFromNetwork, this.randomNummer);

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
            //decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
            padding: EdgeInsets.all(10),
            margin: EdgeInsets.fromLTRB(0, 30, 0, 0),
            height: MediaQuery.of(context).size.height / 5,
            width: MediaQuery.of(context).size.width / 2,
            child: pictureFromNetwork,
            // CachedNetworkImage(imageUrl: "https://github.com/handitosb/lamaapps/blob/main/Bilder_Test/Auto.png?raw=true",),
            //Image.network(wortURL), //Image.memory(byte), // //Image.asset()
            /* Image.network(
              wortURL,
              loadingBuilder: (BuildContext context, Widget child,
                  ImageChunkEvent loadingProgress) {
                if (loadingProgress == null) return child;
                return Center(
                  child: CircularProgressIndicator(
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                            loadingProgress.expectedTotalBytes
                        : null,
                  ),
                );
              },
            ),*/
          ),
          SizedBox(
              //  height: 20,
              ),

          Container(
            height: MediaQuery.of(context).size.height * 0.1,
            width: MediaQuery.of(context).size.width * 0.9,
            //color: Colors.green,
            child: Row(
              //crossAxisCount: wortLaenge,

              children: [
                for (int i = 0; i < wortLaenge; i++)
                  (!_canShowAntwortButton[i])
                      ? leeresFeld()
                      : gefuelltesFeld(buchstabenListe[i]),
              ],
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            // legt Größe des Grids fest
            height: MediaQuery.of(context).size.height * 0.35,
            width: MediaQuery.of(context).size.width * 0.9,
            //color: Colors.green,

            child: GridView.count(
              //maxCrossAxisExtent: MediaQuery.of(context).size.height * 0.25 / 2,
              // zeigt Buchstaben in nächster Zeile an, wenn crossAxisCount überschritten wird
              crossAxisCount: 5,

              //mainAxisSpacing: 10,
              children: [
                for (int i = 0; i < wortLaenge; i++)
                  zeichneContainerMitAntwortButton(i)
              ],
            ),
          ),

          Container(
            child: (() {
              //wenn der letzte Buchstabe richtig angeklickt und angezeigt wurde, soll ein grüner Haken auf dem Bildschirm angezeigt werden
              //ich anschluss folgt ein neuer Task für den User
              if (!_canShowButton[wortLaenge - 1] &&
                  buchstabenListe.join('') == wort) {
                Future.delayed(const Duration(milliseconds: 1500), () {
                  setState(() {
                    BlocProvider.of<TaskBloc>(context)
                        .add(AnswerTaskEvent.initBuchstabieren(true));
                  });
                });
              }
            }()),
          ),
        ],
      ),
    );
  }
}
