import 'dart:io';
import 'dart:math';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame/palette.dart';
import 'package:flutter/material.dart';
import 'package:lama_app/app/model/highscore_model.dart';
import 'package:lama_app/game_snake_aus_iNet/snakeBodyAnimation.dart';

import '../app/repository/user_repository.dart';
import '../util/LamaColors.dart';
import 'component/background.dart';
import 'component/world.dart';
import 'config/game_config.dart';

import 'snake/grid.dart';
import 'snake/offsets.dart';

class SnakeGame extends FlameGame with TapDetector {
  /// screensize of the game
  late Size _screenSize;

  /// the id of flappyLama game which is used in the database
  final int _gameId = 1;

  /// Getter of [_screenSize]
  Size get screenSize {
    return _screenSize;
  }

  /// pixel of the quadratic tiles
  late double _tileSize;

  /// amount of tiles on the y coordinate
  int? _tilesY;

  /// Getter of [_tilesY]
  int get tilesY {
    return _tilesY!;
  }

  /// Getter of [_tileSize]
  double get tileSize {
    return _tileSize;
  }

  /// amount of tiles on the x coordinate
  final int tilesX = 9;

  //#region Global Game Over Variables
  late TextPaint gameOverText;
  late TextPaint gameOverSuccessText;
  late TextPaint gameOverScoreText;
  late TextPaint gameOverAdditionalScoreText;
  var tempUserHighScore = 0;
  var tempAllTimeHighScore = 0;
  var tempSuccessText = "";
  //#endregion

  Grid grid = Grid(GameConfig.rows, GameConfig.columns, GameConfig.cellSize);
  World? world;
  OffSets offSets = OffSets(Vector2.zero());
  late PositionComponent testapfel;

  late SnakeBodyy snakebody;

  var duration = const Duration(seconds: 1);

  int score = 0;

  bool gameOver = false;

  /// necessary context for determine the actual screensize
  BuildContext _context;

  /// the [UserRepository] to interact with the database and get the user infos
  UserRepository _userRepo;

  int? userHighScore;
  int? allTimeHighScore;

  SnakeGame(this._context, this._userRepo, this.userHighScore,
      this.allTimeHighScore) {
    // load all obstacle pngs
/*     Flame.images.loadAll([
      'png/kaktus_body.png',
      'png/kaktus_end_bottom.png',
      'png/kaktus_end_top.png',
    ]);
    initializeAsync(); */
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    offSets = OffSets(canvasSize);

    add(BackGround(GameConfig.cellSize));

    // ignore: avoid_function_literals_in_foreach_calls
    grid.cells.forEach((rows) => rows.forEach((cell) => add(cell)));
    grid.generateFood();

    world = World(grid, this);
    add(world!);
  }

  @override
  void onTapUp(TapUpInfo info) {
    world!.onTapUp(info);
  }

  @override
  Future<void> update(double dt) async {
    super.update(dt);
  }

  void render(Canvas canvas) {
    super.render(canvas);
    if (gameOver == true) {
      print("GAEMOE OVER");
      saveHighScore();
      //openGameOverMenu;
      showGameOverText(canvas);
    }
  }

  void addPoint() {
    score++;
  }

  void saveHighScore() {
    ///total score sum is a sum of the regular score and the streak score

    if (score > userHighScore!) {
      _userRepo.addHighscore(Highscore(
          gameID: 1, //1 == gameID
          score: score,
          userID: _userRepo.authenticatedUser!.id));
    }
  }

  ///method to load the current hig scores from the user repo
  void loadHighScores() async {
    userHighScore = await _userRepo.getMyHighscore(_gameId);
    print(userHighScore.toString());
    allTimeHighScore = await _userRepo.getHighscore(_gameId);
  }
  //#endregion

  void onGameResize(Vector2 size) {
    // get the screensize fom [MediaQuery] because [size] is incorrect on some devices
    _screenSize = Size(
        MediaQuery.of(_context).size.width -
            MediaQuery.of(_context).padding.left -
            MediaQuery.of(_context).padding.right,
        MediaQuery.of(_context).size.height -
            MediaQuery.of(_context).padding.top -
            MediaQuery.of(_context).padding.bottom);
    // calculates by the width of the screen
    _tileSize = screenSize.width / tilesX;
    _tilesY = screenSize.height ~/ tileSize;
    print("_tilesY = $_tilesY");
    print("_tilesY = $_tilesY");

    super.onGameResize(size);
    //  super.resize(size);
  }

  Future<void> openGameOverMenu() async {
/*     if (!removedone) {
      remove(obst1);
      remove(obst2);
      remove(userLama);
      removedone = true;
    } */
    saveHighScore();
    RectangleComponent gameOverBackground = RectangleComponent(
        position: Vector2(0, 0),
        anchor: Anchor.topLeft,
        size: Vector2(screenSize.width, screenSize.height),
        paint: PaletteEntry(Color(0xeaeceaea)).paint(),
        priority: 5);
    add(gameOverBackground);
    createGameOverTextAndGameOverButtons();
  }

  Future<void> createGameOverTextAndGameOverButtons() async {
    ///initialise TextPaint Objects for relevant text parts in the game over menu

    gameOverText = TextPaint(
        style: TextStyle(
            fontSize: screenSize.width * 0.15,
            fontWeight: FontWeight.bold,
            color: score >= userHighScore! && score != 0
                ? LamaColors.greenAccent
                : LamaColors.redAccent));

    gameOverSuccessText = TextPaint(
        style: TextStyle(
            fontSize: screenSize.width * 0.06,
            fontWeight: FontWeight.bold,
            color: score >= userHighScore! && score != 0
                ? LamaColors.greenAccent
                : LamaColors.redAccent));

    gameOverScoreText = TextPaint(
        style: TextStyle(
            fontSize: screenSize.width * 0.08,
            fontWeight: FontWeight.bold,
            color: LamaColors.blueAccent));

    gameOverAdditionalScoreText = TextPaint(
        style: TextStyle(
            fontSize: screenSize.width * 0.04, color: LamaColors.bluePrimary));

    ///temporal variables to get a create a correct score text
    tempUserHighScore = userHighScore!;
    tempAllTimeHighScore = allTimeHighScore!;
    tempSuccessText = "";

    ///creating individual text depending on the score of the player
    if (score > userHighScore!) {
      tempSuccessText = "Super, dein bestes Spiel bisher!";
      userHighScore = score;
      tempUserHighScore = score;
      if (score > allTimeHighScore!) {
        tempSuccessText = "Wow, ein neuer Highscore!";
        userHighScore = score;
        allTimeHighScore = score;
        tempAllTimeHighScore = score;
      }
    } else if (score == 0) {
      tempSuccessText = "Das war wohl nichts :(";
    } else if (score == userHighScore) {
      tempSuccessText = "Fast!";
    } else {
      tempSuccessText = "Das war wohl nichts :(";
    }
  }

  void showGameOverText(Canvas canvas) {
    openGameOverMenu();
    //  createGameOverTextAndGameOverButtons();

    gameOverText.render(canvas, "Game Over!",
        Vector2(screenSize.width * 0.5, screenSize.height * 1 / 10),
        anchor: Anchor.center);

    gameOverSuccessText.render(canvas, tempSuccessText,
        Vector2(screenSize.width * 0.5, screenSize.height * 2 / 10),
        anchor: Anchor.center);

    /// set height of additional game text depending on the height/width ratio of the device
    var yPosAdditionalText;
    screenSize.height / screenSize.width >= (16 / 9)
        ? yPosAdditionalText = screenSize.height * 0.345
        : yPosAdditionalText = screenSize.height * 0.325;

/*     gameOverAdditionalScoreText.render(canvas, "(Score: $score )",
        Vector2(screenSize.width * 0.15, yPosAdditionalText),
        anchor: Anchor.centerLeft); */

    gameOverScoreText.render(
        canvas,
        "Rekord:  $tempUserHighScore\n\nHigh-Score:    $tempAllTimeHighScore",
        Vector2(screenSize.width * 0.15, screenSize.height * 4 / 10),
        anchor: Anchor.centerLeft);
  }
}
