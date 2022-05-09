// ignore_for_file: constant_identifier_names
import 'dart:developer' as developer;

import 'dart:async';

import 'package:flutter/material.dart';

import 'blocks/alive_point.dart';
import 'userinput.dart';
import 'helper.dart';
import 'blocks/block.dart';
import 'score_display.dart';

import 'package:lama_app/app/model/highscore_model.dart';
import 'package:lama_app/app/repository/user_repository.dart';

enum LastButtonPressed { LEFT, RIGHT, ROTATE_LEFT, ROTATE_RIGHT, NONE }
enum MoveDir { LEFT, RIGHT, DOWN }

double WIDTH = 200;
double HEIGHT = 400;

double BOARD_WIDTH = 10; //vorher int
double BOARD_HEIGHT = 20;
double POINT_SIZE = 20; //angabe in Px

const int GAME_SPEED = 500; // spielgeschwindigkeit
Timer timer = Timer(const Duration(milliseconds: 1), () {});

class Game extends StatefulWidget {
  /// context of the game to allow access to the navigator
  BuildContext context;

  /// the personal highScore
  int userHighScore;

  /// the all time highScore in this game
  int allTimeHighScore;

  var userRepo;

  // const Game({Key? key}) : super(key: key);
  Game(this.context, this.userRepo) {
    developer.log("${MediaQuery.of(context).size.width}");
    developer.log("${MediaQuery.of(context).size.height}");
    developer.log("${MediaQuery.of(context).padding}");
  }
  @override
  State<StatefulWidget> createState() => _Game(userRepo, context);
}

class _Game extends State<Game> {
  //LastButtonPressed soll sich ändern können, bzw der State soll sich hier ändern können
  LastButtonPressed performAction = LastButtonPressed.NONE; //anfangs State
  Block currentBlock;
  List<AlivePoint> alivePoints = [];
  int score = 0;
  UserRepository _userRepo;
  BuildContext context;

  _Game(this._userRepo, this.context) {
    //das macht es fast!!! responsible
    final mediaQueryData = MediaQuery.of(context);
    WIDTH = (mediaQueryData.size.height - 250) / 2;

    POINT_SIZE = WIDTH / 10;
    HEIGHT = WIDTH * 2;
  }
  bool _savedHighscore = false;

  ////////////////////////////////////////////////////////
  /// id of the game
  final gameId = 4;

  /// the personal highScore
  int userHighScore;

  /// the all time highScore in this game
  int allTimeHighScore;

  void ladeHighScores() async {
    userHighScore = await _userRepo.getMyHighscore(gameId);
    allTimeHighScore = await _userRepo.getHighscore(gameId);
  }

  @override
  void initState() {
    super.initState();
    ladeHighScores();
    startGame();
  }

  void onActionButtonPressed(LastButtonPressed newAction) {
    setState(() {
      performAction = newAction;
    });
  }

  void startGame() {
    setState(() {
      currentBlock = getRamdomBlock();
    });
    timer = Timer.periodic(
      const Duration(milliseconds: GAME_SPEED),
      onTimeTick,
    );
  }

  void checkForUserInput() {
    if (performAction != LastButtonPressed.NONE) {
      setState(() {
        switch (performAction) {
          case LastButtonPressed.LEFT:
            currentBlock.move(MoveDir.LEFT);
            if (isInOldBlock()) currentBlock.move(MoveDir.RIGHT);
            break;
          case LastButtonPressed.RIGHT:
            currentBlock.move(MoveDir.RIGHT);
            if (isInOldBlock()) currentBlock.move(MoveDir.LEFT);
            break;
          case LastButtonPressed.ROTATE_LEFT:
            currentBlock.rotateLeft();
            if (isInOldBlock()) currentBlock.rotateRight();
            break;
          case LastButtonPressed.ROTATE_RIGHT:
            currentBlock.rotateRight();
            if (isInOldBlock()) currentBlock.rotateLeft();
            break;
          default:
            break;
        }

        performAction = LastButtonPressed.NONE;
      });
    }
  }

  void safeOldBlock() {
    for (var point in currentBlock.fixed_length_list_of_points) {
      AlivePoint newPoint = AlivePoint(point.x, point.y, currentBlock.color);
      setState(() {
        alivePoints.add(newPoint);
      });
    }
  }

//oder auch ist ein Block
  bool isAboveOldBlock() {
    bool retVal = false;

    for (var oldPoint in alivePoints) {
      if (oldPoint
          .checkIfPointsCollide(currentBlock.fixed_length_list_of_points)) {
        retVal = true;
      }
    }

    return retVal;
  }

  bool isInOldBlock() {
    bool retVal = false;

    for (var oldPoint in alivePoints) {
      if (oldPoint.checkIfPointsCollideCollide(
          currentBlock.fixed_length_list_of_points)) {
        retVal = true;
      }
    }

    return retVal;
  }

  void removeRow(int row) {
    setState(() {
      alivePoints.removeWhere((point) => point.y == row);

      for (var point in alivePoints) {
        if (point.y < row) {
          point.y += 1;
        }
      }
      score += 1;
    });
  }

  void removeFullRows() {
    for (int currentRow = 0; currentRow < BOARD_HEIGHT; currentRow++) {
      //kontrolliert alle Reichen von oben nach unten
      int counter = 0;

      for (var point in alivePoints) {
        if (point.y == currentRow) {
          counter++;
        }
      }
      if (counter >= BOARD_WIDTH) {
        //entferne currentRow
        removeRow(currentRow);
      }
    }
  }

  bool playerLost() {
    bool retVal = false;

    for (var element in alivePoints) {
      if (element.y <= 0) {
        retVal = true;
        //hier wird der Highscore gespeichert
        if (score > userHighScore) {
          if (!_savedHighscore) {
            _savedHighscore = true;
            _userRepo.addHighscore(Highscore(
                gameID: gameId,
                score: score,
                userID: _userRepo.authenticatedUser.id));
          }
        }
      }
    }
    return retVal;
  }

  void onTimeTick(Timer time) {
    if (currentBlock == null || playerLost()) {
      timer.cancel();
      return;
    }

//entferne volle Reihe
    removeFullRows();
    //prüfe, ob der block schon auf dem Boden ist
    if (currentBlock.isAtBottom() || isAboveOldBlock()) {
      //safe Block
      safeOldBlock();
      //neuer random Block
      setState(() {
        currentBlock = getRamdomBlock();
      });
    } else {
      setState(() {
        //if game is running noch hinzufügen, sollte probleme beheben
        currentBlock.move(MoveDir.DOWN);
      });
      checkForUserInput();
    }
  }

  Widget drawTetrisBlocks() {
    List<Positioned> visiblePoints = [];

    //aktueller BLock
    for (var point in currentBlock.fixed_length_list_of_points) {
      Positioned newPoint = Positioned(
        child: getTetrisPoint(currentBlock.color),
        left: point.x * POINT_SIZE,
        top: point.y * POINT_SIZE,
      );
      visiblePoints.add(newPoint);
    }

//oldBlock
    for (var point in alivePoints) {
      visiblePoints.add(
        Positioned(
          child: getTetrisPoint(point.color),
          left: point.x * POINT_SIZE,
          top: point.y * POINT_SIZE,
        ),
      );
    }

    return Stack(
      children: visiblePoints,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Expanded(
          child: Center(
            child: Container(
              width: WIDTH,
              height: HEIGHT,
              decoration: BoxDecoration(
                border: Border.all(color: Color.fromARGB(255, 227, 223, 223)),
              ),
              child: (playerLost() == false)
                  ? drawTetrisBlocks()
                  : getGameOverText(score, userHighScore, allTimeHighScore),
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  ScoreDisplayTetris(allTimeHighScore, "Highscore"),
                  ScoreDisplayTetris(userHighScore, "dein Rekord"),
                  ScoreDisplayTetris(score, "Score"),
                ],
              ),
            ),
            Expanded(
              child: (playerLost() == false)
                  ? UserInput(onActionButtonPressed)
                  : getGameOverButton(context),
            ),
          ],
        )
      ],
    );
  }
}
