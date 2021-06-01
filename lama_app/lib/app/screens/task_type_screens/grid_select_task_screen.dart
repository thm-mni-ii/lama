import 'dart:math';

import 'package:bubble/bubble.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lama_app/app/bloc/taskBloc/gridselecttask_bloc.dart';
import 'package:lama_app/app/bloc/task_bloc.dart';
import 'package:lama_app/app/event/task_events.dart';
import 'package:lama_app/app/task-system/task.dart';
import 'package:lama_app/util/LamaColors.dart';
import 'package:lama_app/util/LamaTextTheme.dart';
import 'package:lama_app/util/pair.dart';

class GridSelectTaskScreen extends StatelessWidget {
  TaskGridSelect task;
  BoxConstraints constraints;

  Map<Pair, String> characterPositions = Map();
  String letters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";

  GridSelectTaskBloc gridSelectTaskBloc;

  GridSelectTaskScreen(this.task, this.constraints) {
    gridSelectTaskBloc = GridSelectTaskBloc();
    _generateWordPlacement();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<GridSelectTaskBloc>(
      create: (context) => gridSelectTaskBloc,
      child: Column(
        children: [
          Container(
            height: (constraints.maxHeight / 100) * 65,
            child: Padding(
              padding: EdgeInsets.all((constraints.maxWidth / 100) * 5),
              child: Table(
                border: TableBorder.all(color: LamaColors.white, width: 2),
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                children: _getTableRows(),
              ),
            ),
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
                            fontSize: 15, fontWeight: FontWeight.bold),
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
            height: (constraints.maxHeight / 100) * 15,
            child: Center(
              child: InkWell(
                child: Container(
                  height: (constraints.maxHeight / 100) * 10,
                  width: (constraints.maxWidth / 100) * 70,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(25),
                    ),
                    color: LamaColors.greenAccent,
                    boxShadow: [
                      BoxShadow(
                          offset: Offset(0, 2),
                          color: LamaColors.black.withOpacity(0.5))
                    ],
                  ),
                  child: Center(
                    child: Text(
                      "Fertig",
                      style: LamaTextTheme.getStyle(
                        fontSize: 30,
                      ),
                    ),
                  ),
                ),
                onTap: () => {
                  BlocProvider.of<TaskBloc>(context).add(
                      AnswerTaskEvent.initGridSelect(
                          characterPositions.keys.toList(),
                          gridSelectTaskBloc.selectedTableItems))
                },
              ),
            ),
          )
        ],
      ),
    );
  }

//Entweder same index oder same rowNumber

  List<TableRow> _getTableRows() {
    return List.generate(9, (index) => TableRow(children: _getRow(index)));
  }

  List<Widget> _getRow(int rowNumber) {
    return List.generate(9, (columnNumber) {
      Pair cord = Pair(columnNumber, rowNumber);
      String char = "";
      if (characterPositions.containsKey(cord))
        char = characterPositions[cord];
      else
        char = getTableItemLetter(cord);
      return TableItem(cord, constraints, char);
    });
  }

  _generateWordPlacement() {
    var rnd = Random();
    task.wordsToFind.forEach((word) {
      int wordLength = word.length;

      int maxStartIndex = 10 - wordLength;

      bool succesfullyGenerated;
      bool wordAdded;
      Pair cords;
      List<Pair> cordList;
      int timeout = 0;
      //Whether it will generate vertical or horizontal
      do {
        wordAdded = false;
        if (rnd.nextBool()) {
          //vertical
          do {
            succesfullyGenerated = true;
            int start = rnd.nextInt(maxStartIndex);
            cordList = [];
            int x = rnd.nextInt(9);
            for (int y = start; y < start + wordLength; y++) {
              cords = Pair(x, y);
              cordList.add(cords);
            }
            cordList.forEach((element) {
              if (characterPositions.containsKey(element)) {
                succesfullyGenerated = false;
              }
            });
            timeout++;
          } while (!succesfullyGenerated && timeout < 20);
          if (timeout >= 20) {
            timeout = 0;
            continue;
          }
          for (int i = 0; i < wordLength; i++) {
            characterPositions.putIfAbsent(
                cordList[i], () => word[i].toUpperCase());
          }
          wordAdded = true;
        } else {
          do {
            succesfullyGenerated = true;
            int start = rnd.nextInt(maxStartIndex);
            cordList = [];
            int y = rnd.nextInt(9);
            for (int x = start; x < start + wordLength; x++) {
              cords = Pair(x, y);
              cordList.add(cords);
            }
            cordList.forEach((element) {
              if (characterPositions.containsKey(element))
                succesfullyGenerated = false;
            });
          } while (!succesfullyGenerated && timeout < 20);
          if (timeout >= 20) {
            timeout = 0;
            continue;
          }
          for (int i = 0; i < wordLength; i++) {
            characterPositions.putIfAbsent(
                cordList[i], () => word[i].toUpperCase());
          }
          wordAdded = true;
        }
      } while (!wordAdded);
    });
  }

  String getTableItemLetter(Pair position) {
    Pair left = Pair(position.a - 1, position.b);
    Pair right = Pair(position.a + 1, position.b);
    Pair up = Pair(position.a, position.b + 1);
    Pair down = Pair(position.a, position.b - 1);

    return getRandomLetter(characterPositions.containsKey(left) ||
        characterPositions.containsKey(up) ||
        characterPositions.containsKey(right) ||
        characterPositions.containsKey(down));
  }

  String getRandomLetter(bool excludeLettersInWordsToFind) {
    var rnd = Random();
    String char = "";
    if (!excludeLettersInWordsToFind) {
      char =
          String.fromCharCode(letters.codeUnitAt(rnd.nextInt(letters.length)));
    } else {
      do {
        char = String.fromCharCode(
            letters.codeUnitAt(rnd.nextInt(letters.length)));
      } while (characterPositions.containsValue(char));
    }
    return char;
  }
}

class TableItem extends StatelessWidget {
  final BoxConstraints constraints;
  final Pair cord;
  final String char;
  TableItem(this.cord, this.constraints, this.char);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GridSelectTaskBloc, GridSelectTaskState>(
      builder: (context, state) => Container(
        color: state.selectedWords.contains(cord)
            ? LamaColors.greenAccent
            : LamaColors.blueAccent,
        width: (constraints.maxWidth / 100) * 10,
        height: (constraints.maxWidth / 100) * 10,
        child: InkWell(
          onTap: () => BlocProvider.of<GridSelectTaskBloc>(context)
              .add(SelectGridLetterEvent(cord)),
          child: Center(
            child: Text(
              char,
              style: LamaTextTheme.getStyle(
                fontSize: 20,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
