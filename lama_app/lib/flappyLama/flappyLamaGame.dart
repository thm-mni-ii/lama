import 'dart:ui';
import 'package:flame/gestures.dart';
import 'package:flame/game.dart';
import 'package:flame/flame.dart';

import 'package:flutter/material.dart';
import 'package:lama_app/flappyLama/components/flappyBackground.dart';
import 'package:lama_app/flappyLama/components/flappyGround.dart';
import 'package:lama_app/flappyLama/components/flappyObstacle.dart';

class FlappyLamaGame extends Game with TapDetector {
  Size screenSize;
  double tileSize;

  FlappyBackground background;
  FlappyGround ground;
  BuildContext _context;
  FlappyObstacle obstacle;

  bool _initialized = false;

  FlappyLamaGame(this._context) {
    initialize();
  }

  void initialize() async {
    resize(await Flame.util.initialDimensions());
    background = FlappyBackground(this);
    ground = FlappyGround(this);
    obstacle = FlappyObstacle(this);
    _initialized = true;
  }

  @override
  void render(Canvas canvas) {
    if(_initialized){
      background.render(canvas);
      ground.render(canvas);
      obstacle.render(canvas);
    }
  }

  @override
  void update(double t) {
    // TODO: implement update
  }

  @override
  void resize(Size size) {
    screenSize = size;
    tileSize = screenSize.width / 9;
  }

  void onTapDown(TapDownDetails d) {
    //if pauseButton pause
    //else jump
  }
}
