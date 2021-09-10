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

/// [StatelessWidget] that contains the screen for the GridSelect TaskType.
///
/// This Screen still contains a lot of logic. This will need to be moved to its own BloC once developement continues.
///
/// Author: K.Binder
class GridSelectTaskScreen extends StatelessWidget {
  final TaskGridSelect task;
  final BoxConstraints constraints;

  final Map<Pair, String> characterPositions = Map();

  //some letter appear more often (loosely based on letter frequency) so they have a higher chance of being chosen
  final String letters = "AAABCDDEEEEFFGGHHIIIJKKLLMMNNNOOPPQRRSSSTTTUUVWXYZ";

  String actualLamaText;

  final Map<Pair, String> gridLayout = Map();

  final GridSelectTaskBloc gridSelectTaskBloc;

  GridSelectTaskScreen(this.task, this.constraints, this.gridSelectTaskBloc) {
    actualLamaText = task.lamaText;
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
              padding: EdgeInsets.fromLTRB(
                  (constraints.maxWidth / 100) * 5,
                  (constraints.maxHeight / 100) * 5,
                  (constraints.maxWidth / 100) * 5,
                  0),
              child: LayoutBuilder(
                builder: (context, BoxConstraints constraints) => Table(
                  border: TableBorder.all(color: LamaColors.white, width: 2),
                  defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                  children: _getTableRows(constraints),
                ),
              ),
            ),
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
                        actualLamaText,
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
            height: (constraints.maxHeight / 100) * 20,
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

  ///Generates all [TableRow]
  List<TableRow> _getTableRows(BoxConstraints constraints) {
    return List.generate(
        9, (index) => TableRow(children: _getRow(index, constraints)));
  }

  ///Generates a List of [TableItem] to fill a [TableRow].
  List<Widget> _getRow(int rowNumber, BoxConstraints constraints) {
    return List.generate(9, (columnNumber) {
      Pair cord = Pair(columnNumber, rowNumber);
      String char = "";
      if (characterPositions.containsKey(cord)) {
        char = characterPositions[cord];
      } else
        char = getTableItemLetter(cord);
      return TableItem(cord, constraints, char);
    });
  }

  ///Places the words that need to be found on the grid.
  void _generateWordPlacement() {
    var rnd = Random();
    int wordsPlaced = 0;
    task.wordsToFind.forEach((word) {
      int wordLength = word.length;
      if (wordLength > 9) return;
      int maxStartIndex = 10 - wordLength;

      bool succesfullyGenerated;
      bool wordAdded;
      Pair cords;
      List<Pair> cordList;
      int timeout = 0;

      int wordTimeout = 0;
      //Whether it will generate vertical or horizontal
      do {
        wordAdded = false;
        if (rnd.nextBool()) {
          //vertical
          do {
            print("trying vertical");
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
            gridLayout.putIfAbsent(cordList[i], () => word[i].toUpperCase());
          }
          wordAdded = true;
        } else {
          do {
            print("trying horizontal");
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
            timeout++;
          } while (!succesfullyGenerated && timeout < 20);
          if (timeout >= 20) {
            timeout = 0;
            continue;
          }
          for (int i = 0; i < wordLength; i++) {
            characterPositions.putIfAbsent(
                cordList[i], () => word[i].toUpperCase());
            gridLayout.putIfAbsent(cordList[i], () => word[i].toUpperCase());
          }
          wordAdded = true;
        }
        wordTimeout++;
        print("wordTimeout is now " +
            wordTimeout.toString() +
            " for word " +
            word);
        if (wordAdded) wordsPlaced++;
      } while (!wordAdded && wordTimeout < 20);
    });
    actualLamaText =
        actualLamaText.replaceAll(" X ", " " + wordsPlaced.toString() + " ");
  }

  ///Returns the character that will be placed at the [position] in the table.
  String getTableItemLetter(Pair position) {
    Pair left = Pair(position.a - 1, position.b);
    Pair right = Pair(position.a + 1, position.b);
    Pair up = Pair(position.a, position.b + 1);
    Pair down = Pair(position.a, position.b - 1);
    String char = getRandomLetter(left, up, right, down);
    gridLayout.putIfAbsent(position, () => char);
    return char;
  }

  ///Returns a random letter.
  ///
  ///This method prevents placing a character thats in one of the words that
  ///need to be found next to another character thats
  ///also in one of the words to find.
  ///
  ///This obviously doesnt happen when one of the characters is part of one of the placed words.
  ///It only prevents two random generated characters that are next to each other from both being in a word thats needs to be found.
  String getRandomLetter(Pair left, Pair up, Pair right, Pair down) {
    var rnd = Random();
    String char = "";

    int triesTillTimeout = 10;
    int curTries = 0;

    String leftValue, upValue, rightValue, downValue;
    leftValue = gridLayout[left];
    upValue = gridLayout[up];
    rightValue = gridLayout[right];
    downValue = gridLayout[down];

    bool shouldExcludeRightCharacters =
        characterPositions.containsValue(leftValue) ||
            characterPositions.containsValue(upValue) ||
            characterPositions.containsValue(rightValue) ||
            characterPositions.containsValue(downValue);

    if (shouldExcludeRightCharacters) {
      do {
        char = String.fromCharCode(
            letters.codeUnitAt(rnd.nextInt(letters.length)));
      } while (characterPositions.containsValue(char) &&
          curTries < triesTillTimeout);
    } else {
      char =
          String.fromCharCode(letters.codeUnitAt(rnd.nextInt(letters.length)));
    }
    return char;
  }
}

///[StatelessWidget] that contains a single Item in a TableRow
///
///This class exists to (albeit only slightly) improve the performance of
///the [GridSelectTaskScreen] by splitting the main build method into smaller ones.
///
///Author: K.Binder
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
        height: (constraints.maxHeight / 100) * 10,
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
