import 'package:bubble/bubble.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lama_app/app/bloc/task_bloc.dart';
import 'package:lama_app/app/event/task_events.dart';

import '../../../util/LamaColors.dart';
import '../../../util/LamaTextTheme.dart';
import '../../bloc/taskBloc/buchstabieren_bloc.dart';
import '../../task-system/task.dart';

import 'buchstabieren_task_helper.dart';

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
int maxFehlerAnzahl = 1;
String zufallsChar = getRandomLiteral(1);
String zufallsChar2 = getRandomLiteral(1);
int zufallsCharCounter = 0;
Color testFarbe = Colors.black;
int flagForCorrectingModus = 0; //  1->represent left   /   2->represents right

//Der Buchstabieren Task kann auf zwei verschiedene Arten erzeugt werden, welche Art es sein soll wird in der JSON beim CorrectionModus abgefragt
//ist der CorrectionModus auf fals(bzw. 0), so wir ein Bild aufgerufen, und zu dem Begriff auf dem Bild unsortiere Buchstaben erstellt, welche es anzuklicken gilt, um das Wort zu buchstabieren.
//ist der CorrectionModus aktiv, wird vom User verlang lediglich einen Buchstaben für eine Lücke auszuwählen, sodass das Wort komplett wird-- zur Auswahl stehen dann natürlich auch falsche Buchstaben

class BuchstabierenTaskScreen extends StatefulWidget {
  final TaskBuchstabieren task;
  final BoxConstraints constraints;
  Image pictureFromNetwork;
  int randomNummer;
  int userGrade;

  BuchstabierenTaskScreen(
      this.task, this.constraints, this.pictureFromNetwork, this.randomNummer,
      [this.userGrade]);

  @override
  State<StatefulWidget> createState() {
    return BuchstabierenTaskState(
        task, constraints, pictureFromNetwork, randomNummer, userGrade);
  }
}

class BuchstabierenTaskState extends State<BuchstabierenTaskScreen> {
  // task infos and constraints handed over by tasktypeScreen
  final TaskBuchstabieren task;
  final BoxConstraints constraints;
  Image pictureFromNetwork;
  int randomNummer;
  int userGrade;
  int multiplePoints;
  // Value which is checked after pressing the "fertig" Button
  int i = 0;
  bool answer;
  Color testFarbe2 = Colors.blue;
  BuchstabierenBloc bloc;

  BuchstabierenTaskState(this.task, this.constraints, this.pictureFromNetwork,
      this.randomNummer, this.userGrade);

//hier beginnt der erste State der Aufgabe "Buchstabieren"
//zufalls Nummer wird generiert und das erste Wort wird aus eine json gezogen
//außerdem werden einige Variablen wieder auf ihren ursprünglichen Zustand gestellt-> wichtig für neue Aufgaben
  void initState() {
    super.initState();
    zufallsChar = getRandomLiteral(1);
    zufallsChar2 = getRandomLiteral(1);
    testFarbe = Colors.black;
    List<String> woerterKeys = task.woerter.keys.toList();
    List<String> woerterURLs = task.woerter.values.toList();
    stringIndex = 0;
    i = 0;
    ergebnisIndex = 0;
    fehlerZaehler = 0;
    multiplePoints = task.multiplePoints;
    calculateAllowedMistakes();
    debugPrint("UserGrade:  " + userGrade.toString());

    messeLaengeVomWort(
        holeEinWortAusJSON(randomNummer, woerterKeys, woerterURLs));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<BuchstabierenBloc>(
      create: (context) {
        bloc = BuchstabierenBloc(task);
        bloc.add(BuchstabierenInitEvent());
        return bloc;
      },
      child: Builder(builder: (context) {
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
                              setTaskMessageAccordingToTaskModus(),
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
                    ),
                  ],
                ),
              ),

              BlocBuilder<BuchstabierenBloc, BuchstabierenState>(
                builder: (context, state) {
                  return Container(
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
                  );
                },
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.1,
                width: MediaQuery.of(context).size.width * 0.9,
                //color: Colors.green,
                child: BlocBuilder<BuchstabierenBloc, BuchstabierenState>(
                  builder: (context, state) {
                    return Row(
                      //crossAxisCount: wortLaenge,

                      children: [
                        for (int i = 0; i < wortLaenge; i++)
                          (!_canShowAntwortButton[i])
                              ? leeresFeld()
                              : gefuelltesFeld(buchstabenListe[i]),
                      ],
                    );
                  },
                ),
              ),
              Container(
                // legt Größe des Grids fest
                height: MediaQuery.of(context).size.height * 0.3,
                width: MediaQuery.of(context).size.width * 0.9,
                //color: Colors.green,

                child: BlocBuilder<BuchstabierenBloc, BuchstabierenState>(
                  builder: (context, state) {
                    return GridView.count(
                      //maxCrossAxisExtent: MediaQuery.of(context).size.height * 0.25 / 2,
                      // zeigt Buchstaben in nächster Zeile an, wenn crossAxisCount überschritten wird
                      crossAxisCount: 5,

                      //mainAxisSpacing: 10,
                      children: [
                        for (int i = 0; i < wortLaenge; i++)
                          zeichneContainerMitAntwortButton(i)
                      ],
                    );
                  },
                ),
              ),
              Container(
                alignment: Alignment.center,
                height: MediaQuery.of(context).size.height * 0.1,
                width: MediaQuery.of(context).size.width * 0.9,
                child: BlocBuilder<BuchstabierenBloc, BuchstabierenState>(
                  builder: (context, state) {
                    return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          for (int i = 0; i < task.multiplePoints; i++)
                            CircleAvatar(
                              backgroundColor: state.getColor(),
                            )
                        ]);
                  },
                ),
              ),
              Container(
                child: (() {
                  //wenn der letzte Buchstabe richtig angeklickt und angezeigt wurde, soll ein grüner Haken auf dem Bildschirm angezeigt werden
                  //ich anschluss folgt ein neuer Task für den User
                  /* if (wortLaenge == ergebnisIndex && multiplePoints > 0) {
                    rightOrWrongAnswerEvent(true);
                  } */
                }()),
              ),
            ],
          ),
        );
      }),
    );
  }

//depends on given bool
  void rightOrWrongAnswerEvent(bool isRightOrWrong) {
    Future.delayed(const Duration(milliseconds: 1500), () {
      setState(() {
        BlocProvider.of<TaskBloc>(context)
            .add(AnswerTaskEvent.initBuchstabieren(isRightOrWrong));
      });
    });
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

  String setTaskMessageAccordingToTaskModus() {
    if (task.correctingModus == 1) {
      return "Wähle den richtigen Buchstaben, um die Lücke im Wort korrekt auszufüllen";
    } else {
      return "Buchstabiere das Wort, indem du auf die Buchstaben in der richtigen Reihenfolge drückst";
    }
  }

//zur Zeit soll nur einem Schüler der ersten Klasse erlaubt sein, einen Fehler zu machen
//TODO: man könnte noch die länge des Wortes mit in die Berechnung mit einbeziehen
  calculateAllowedMistakes() {
    if (userGrade == 1) {
      maxFehlerAnzahl = 1;
    }
  }

//
  Widget zeichneAntwortButton(buchstabe, ix) {
    return BlocBuilder<BuchstabierenBloc, BuchstabierenState>(
      builder: (context, state) {
        return ElevatedButton(
          onPressed: () {
            bloc.add(BuchstabierenClickedLetter());
            //task im normalmodus
            //hier wird überprüft, ob der Buchstabe des Buttons
            //gleich dem nächsten korrekt,anzuklickendem Buchstaben ist
            if (task.correctingModus == 0) {
              if (buchstabenListe[stringIndex] == buchstabe) {
                ergebnisBuchstabe = buchstabe;
                hideWidget(ix);
                showWidget(stringIndex);
                stringIndex++;
                buchstabenListe[ergebnisIndex] = buchstabe;
                ergebnisIndex++;
              } else {
                fehlerZaehler++;
                if (fehlerZaehler >= maxFehlerAnzahl) {
                  testFarbe2 = Colors.red;

                  for (int i = stringIndex; i < wort.length; i++) {
                    showWidget(i);
                  }
                  if (state is BuchstabierenFinishedState) {
                    rightOrWrongAnswerEvent(false);
                  } else
                    bloc.add(BuchstabierenGaveAnswer(false));
                }
              }
            }
            //task im correkting Modus
            if (task.correctingModus == 1) {
              if (buchstabenListe[zufallsZahl] == buchstabe) {
                hideWidget(zufallsZahl);
                showWidget(zufallsZahl);
                if (state is BuchstabierenFinishedState) {
                  rightOrWrongAnswerEvent(true);
                } else
                  bloc.add(BuchstabierenGaveAnswer(true));
              } else {
                testFarbe2 = Colors.red;
                if (flagForCorrectingModus == 1) {
                  showWidget(zufallsZahl);

                  hideWidget(zufallsZahl - 1);
                  hideWidget(zufallsZahl - 2);
                }
                if (flagForCorrectingModus == 2) {
                  showWidget(zufallsZahl);

                  hideWidget(zufallsZahl + 1);
                  hideWidget(zufallsZahl + 2);
                }

                if (state is BuchstabierenFinishedState) {
                  rightOrWrongAnswerEvent(false);
                } else
                  bloc.add(BuchstabierenGaveAnswer(false));
              }
            }
          },
          style: ElevatedButton.styleFrom(
            primary: testFarbe2,
            shadowColor: Colors.black,
            elevation: 10,
          ),
          child: Text(buchstabe, style: LamaTextTheme.getStyle(fontSize: 30)),
        );
      },
    );
  }

//ein Container, welcher einen klickbaren Button mit einem Buchstaben beinhaltet
//wurde er in richtiger Reihenfolge angeklickt, wird er auf "null" gesetzt
//Falls seine größe im Zustand "null" nicht angepasst wird, so wird eine andere Lösung benötigt
  Widget zeichneContainerMitAntwortButton(x) {
    //Task im Buchstabier Modus
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
            style: TextStyle(
                fontSize: 30, fontWeight: FontWeight.bold, color: testFarbe)),
      ),
    );
  }

  String holeEinWortAusJSON(i, wortkey, worturl) {
    wort = "test";
    wort = wortkey[i];
    ;
    if (task.first_Letter_Caps == 0 || task.correctingModus == 1) {
      wort = wort.toLowerCase();
    }
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

    if (task.correctingModus == 0) {
      for (int x = 0; x < wort.length; x++) {
        _canShowButton[x] = true;
        _canShowAntwortButton[x] = false;
      }
    }
    //set Task in correcting Modus
    if (task.correctingModus == 1) {
      zufallsZahl = bestimmeEinZufallsZahlFuerWort(wort);
      for (int x = 0; x < wort.length; x++) {
        _canShowButton[x] = false;
        _canShowAntwortButton[x] = true;
      }
      _canShowButton[zufallsZahl] = true;
      _canShowAntwortButton[zufallsZahl] = false;
      //Setze ein paar falsche Antwortmöglichkeiten
      if (zufallsZahl > wort.length - 3) {
        flagForCorrectingModus = 1;
        _canShowButton[zufallsZahl - 1] = true;
        //_canShowAntwortButton[zufallsZahl - 1] = false;
        _canShowButton[zufallsZahl - 2] = true;
        //_canShowAntwortButton[zufallsZahl - 2] = false;
        //buchstabenListe[zufallsZahl - 1] = "x";
        //buchstabenListe[zufallsZahl - 2] = "x";
      } else {
        flagForCorrectingModus = 2;

        _canShowButton[zufallsZahl + 1] = true;
        //_canShowAntwortButton[zufallsZahl + 1] = false;
        _canShowButton[zufallsZahl + 2] = true;
        //_canShowAntwortButton[zufallsZahl + 2] = false;
        //buchstabenListe[zufallsZahl + 1] = "x";
        //buchstabenListe[zufallsZahl + 2] = "x";
      }
    }
    ///////////////////////////////////////////////

    return wort;
  }

  int messeLaengeVomWort(i) {
    wortLaenge = i.length;
    return 0;
  }

  String holeBuchstabe(i) {
    if (task.correctingModus == 0) {
      var losungsWort = "Auto"; //default wort
      losungsWort = wort;
      String test1 = losungsWort[i];
      return test1;
    }
    if (task.correctingModus == 1 && i == zufallsZahl) {
      return wort[zufallsZahl];
    } else if (task.correctingModus == 1 && i != zufallsZahl) {
      if (zufallsCharCounter == 0) {
        zufallsCharCounter++;
        return zufallsChar;
      } else {
        zufallsCharCounter--;

        return zufallsChar2;
      }
    }
  }
}
