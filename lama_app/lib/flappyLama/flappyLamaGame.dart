import 'dart:ui';
import 'package:flame/gestures.dart';
import 'package:flame/game.dart';
import 'package:flame/flame.dart';

import 'package:flutter/material.dart';
import 'package:lama_app/flappyLama/components/flappyBackground.dart';
import 'package:lama_app/flappyLama/components/flappyGround.dart';
import 'package:lama_app/flappyLama/components/flappyObstacle.dart';
import 'package:lama_app/flappyLama/components/flappyScoreDisplay.dart';
import 'package:lama_app/flappyLama/components/flappyScoreDisplay.dart';

class FlappyLamaGame extends Game with TapDetector {
  Size screenSize;
  double tileSize;
  int score;

  FlappyBackground background;
  FlappyGround ground;
  BuildContext _context;
  FlappyObstacle obstacle;
  FlappyScoreDisplay scoreDisplay;

  bool _initialized = false;

  FlappyLamaGame(this._context) {
    initialize();
  }

  void initialize() async {
    resize(await Flame.util.initialDimensions());
    background = FlappyBackground(this);
    ground = FlappyGround(this);
    obstacle = FlappyObstacle(this);
    scoreDisplay = FlappyScoreDisplay(this);
    _initialized = true;
  }

  @override
  void render(Canvas canvas) {
    if(_initialized){
      background.render(canvas);
      ground.render(canvas);
      obstacle.render(canvas);
      scoreDisplay.render(canvas);
    }
  }

  @override
  void update(double t) {
    // TODO: implement update
     if(_initialized){
      obstacle.update(t);
      scoreDisplay.update(t);
      score = obstacle.score;
    }
  }

  @override
  void resize(Size size) {
    screenSize = Size( MediaQuery.of(_context).size.width - MediaQuery.of(_context).padding.left - MediaQuery.of(_context).padding.right,
        MediaQuery.of(_context).size.height - MediaQuery.of(_context).padding.top - MediaQuery.of(_context).padding.bottom);
    tileSize = screenSize.width / 9;

    
  }

  void onTapDown(TapDownDetails d) {
    //if pauseButton pause
    //else jump
  }
}
