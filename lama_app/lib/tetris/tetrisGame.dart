import 'dart:developer' as developer;
import 'dart:async';
import 'package:flutter/material.dart';

import 'block_objects/alive_point.dart';
import 'userinput.dart';
import 'tetrisHelper.dart';
import 'block_objects/block.dart';
import 'screens/score_display.dart';

import 'package:lama_app/app/model/highscore_model.dart';
import 'package:lama_app/app/repository/user_repository.dart';

// This class contains most of the Tetris game logic
// Author: Artur Pusch
// some parts of the code are taken from:
// https://github.com/DennisLovesCoffee/Flutter_Tetris
// wich was written by DennisLovesCoffee -- see also https://github.com/DennisLovesCoffee

enum LastButtonPressed { LEFT, RIGHT, ROTATE_LEFT, ROTATE_RIGHT, NONE }
enum MoveDir { LEFT, RIGHT, DOWN }

double WIDTH = 200;
double HEIGHT = 400;

double BOARD_WIDTH = 10;
double BOARD_HEIGHT = 20;
double POINT_SIZE = 20;

int GAME_SPEED =
    600; //less means faster //increses every time "score" reaches "amountOfPointsUserHasToReachSoHeBecomesFaster"
Timer timer = Timer(const Duration(milliseconds: 1), () {});
int amountOfPointsUserHasToReachSoHeBecomesFaster =
    2; //increses every time the game becomes faster

class Game extends StatefulWidget {
  /// context of the game to allow access to the navigator
  BuildContext context;

  /// the personal highScore
  int userHighScore;

  /// the all time highScore in this game
  int allTimeHighScore;

  var userRepo;

  Game(this.context, this.userRepo, this.userHighScore, this.allTimeHighScore) {
    developer.log("${MediaQuery.of(context).size.width}");
    developer.log("${MediaQuery.of(context).size.height}");
    developer.log("${MediaQuery.of(context).padding}");
  }
  @override
  State<StatefulWidget> createState() =>
      _Game(userRepo, context, userHighScore, allTimeHighScore);
}

class _Game extends State<Game> {
  LastButtonPressed performAction = LastButtonPressed.NONE; //start State
  Block currentBlock;
  List<AlivePoint> alivePoints =
      []; //used Blocks, which are already on the ground or in other blocks
  int score = 0;
  UserRepository _userRepo;
  BuildContext context;

  _Game(
      this._userRepo, this.context, this.userHighScore, this.allTimeHighScore) {
    //this makes the game screen responsible
    final mediaQueryData = MediaQuery.of(context);
    WIDTH = (mediaQueryData.size.height - 250) / 2;
    POINT_SIZE = WIDTH / 10;
    HEIGHT = WIDTH * 2;
  }
  bool _savedHighscore = false;

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
    //  ladeHighScores();
    GAME_SPEED = 600;
    amountOfPointsUserHasToReachSoHeBecomesFaster = 2;
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
      Duration(milliseconds: GAME_SPEED),
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
        safeHighScore();
        retVal = true;
      }
    }
    return retVal;
  }

  void safeHighScore() {
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

  void onTimeTick(Timer time) {
    if (currentBlock == null || playerLost()) {
      timer.cancel();
      return;
    }
    removeFullRows(); //score++ is in here
    increaseSpeedIfNecessary();

    if (currentBlock.isAtBottom() || isAboveOldBlock()) {
      safeOldBlock();
      setState(() {
        currentBlock = getRamdomBlock();
      });
    } else {
      setState(() {
        currentBlock.move(MoveDir.DOWN);
      });
      checkForUserInput();
    }
  }

  void increaseSpeedIfNecessary() {
    if (score > amountOfPointsUserHasToReachSoHeBecomesFaster) {
      amountOfPointsUserHasToReachSoHeBecomesFaster =
          score + amountOfPointsUserHasToReachSoHeBecomesFaster;
      GAME_SPEED -= 50;
    }
  }

  Widget drawTetrisBlocks() {
    List<Positioned> visiblePoints = [];
//current Block
    for (var point in currentBlock.fixed_length_list_of_points) {
      Positioned newPoint = Positioned(
        child: getTetrisPoint(currentBlock.color),
        left: point.x * POINT_SIZE,
        top: point.y * POINT_SIZE,
      );
      visiblePoints.add(newPoint);
    }

//oldBlock's
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
        ScoreDisplayTetris(score, "Score"),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            /* Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  ScoreDisplayTetris(allTimeHighScore, "Highscore"),
                  ScoreDisplayTetris(userHighScore, "dein Rekord"),
                  ScoreDisplayTetris(score, "Score"),
                ],
              ),
            ),*/
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
