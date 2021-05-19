import 'dart:ui';
import 'package:flame/gestures.dart';
import 'package:flame/game.dart';
import 'package:flame/flame.dart';

import 'package:flutter/material.dart';
import 'package:lama_app/flappyLama/components/flappyBackground.dart';
import 'package:lama_app/flappyLama/components/flappyGround.dart';

class FlappyLamaGame extends Game with TapDetector {
  Size screenSize;
  double tileSize;

  FlappyBackground background;
  FlappyGround ground;
  BuildContext _context;

  FlappyLamaGame(this._context) {
    initialize();
  }

  void initialize() async {
    resize(await Flame.util.initialDimensions());
    background = FlappyBackground(this);
    ground = FlappyGround(this);
  }

  @override
  void render(Canvas canvas) {
    background.render(canvas);
    ground.render(canvas);
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
