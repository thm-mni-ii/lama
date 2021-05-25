import 'dart:ui';
import 'package:flame/components/parallax_component.dart';
import 'package:flame/gestures.dart';
import 'package:flame/game.dart';
import 'package:flame/flame.dart';

import 'package:flutter/material.dart';
import 'package:lama_app/flappyLama/components/flappyGround.dart';
import 'package:lama_app/flappyLama/components/flappyObstacle.dart';
import 'package:lama_app/flappyLama/components/flappyScoreDisplay.dart';

class FlappyLamaGame extends BaseGame with TapDetector {
  Size screenSize;
  double tileSize;
  int score;

  BuildContext _context;

  FlappyLamaGame(this._context) {
    var back = ParallaxComponent(
        [
          ParallaxImage('png/himmel.png'),
          ParallaxImage('png/clouds_3.png'),
          ParallaxImage('png/clouds_2.png'),
          ParallaxImage('png/clouds.png'),
        ],
        baseSpeed: Offset(7, 0),
        layerDelta: Offset(10, 0)
    );
    add(back);
    initialize();
  }

  void initialize() async {
    resize(await Flame.util.initialDimensions());

    // add ground
    add(FlappyGround(this));
    // add obstacles
    add(FlappyObstacle(this));
    // add score
    add(FlappyScoreDisplay(this));
  }

  void resize(Size size) {
    screenSize = Size(
        MediaQuery.of(_context).size.width - MediaQuery.of(_context).padding.left - MediaQuery.of(_context).padding.right,
        MediaQuery.of(_context).size.height - MediaQuery.of(_context).padding.top - MediaQuery.of(_context).padding.bottom);
    tileSize = screenSize.width / 9;

    super.resize(size);
  }

  void onTapDown(TapDownDetails d) {
  }
}
