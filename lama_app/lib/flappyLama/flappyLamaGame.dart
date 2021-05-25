import 'dart:ui';
import 'package:flame/components/parallax_component.dart';
import 'package:flame/gestures.dart';
import 'package:flame/game.dart';
import 'package:flame/flame.dart';

import 'package:flutter/material.dart';
import 'package:lama_app/flappyLama/components/flappyGround.dart';
import 'package:lama_app/flappyLama/components/flappyLama.dart';
import 'package:lama_app/flappyLama/components/flappyObstacle.dart';
import 'package:lama_app/flappyLama/components/flappyScoreDisplay.dart';
import 'package:lama_app/flappyLama/widgets/pauseMode.dart';
import 'package:lama_app/flappyLama/widgets/playMode.dart';

class FlappyLamaGame extends BaseGame with TapDetector, HasWidgetsOverlay {
  Size screenSize;
  double tileSize;
  int score = 0;
  FlappyLama flappyLama;

  BuildContext _context;
  bool _paused = false;
  // name of the pauseMode widget
  String _pauseMode = "PauseMode";
  // name of the playMode widget
  String _playMode = "PlayMode";

  FlappyLamaGame(this._context) {
    var back = ParallaxComponent([
      ParallaxImage('png/himmel.png'),
      ParallaxImage('png/clouds_3.png'),
      ParallaxImage('png/clouds_2.png'),
      ParallaxImage('png/clouds.png'),
    ], baseSpeed: Offset(7, 0), layerDelta: Offset(10, 0));
    // add background
    add(back);

    // add PlayMode widget
    addWidgetOverlay(_playMode, PlayMode(onPausePressed: pauseGame));

    initialize();
  }

  void initialize() async {
    resize(await Flame.util.initialDimensions());
    // add ground
    add(FlappyGround(this));
    flappyLama = FlappyLama(this);
    // add obstacles
    add(FlappyObstacle(this));
    // add score
    add(FlappyScoreDisplay(this));
  }

  void resize(Size size) {
    screenSize = Size(
        MediaQuery.of(_context).size.width -
            MediaQuery.of(_context).padding.left -
            MediaQuery.of(_context).padding.right,
        MediaQuery.of(_context).size.height -
            MediaQuery.of(_context).padding.top -
            MediaQuery.of(_context).padding.bottom);
    tileSize = screenSize.width / 9;

    super.resize(size);
  }

  /// This method pauses the game.
  void pauseGame() {
    pauseEngine();
    _paused = true;

    // removed the playMode widget
    removeWidgetOverlay(_playMode);
    addWidgetOverlay(_pauseMode, PauseMode(onPlayPressed: resumeGame));
  }

  /// This method resumes the game.
  void resumeGame() {
    resumeEngine();
    _paused = false;

    // removed the pauseMode widget
    removeWidgetOverlay(_pauseMode);
    addWidgetOverlay(_playMode, PlayMode(onPausePressed: pauseGame));
  }

  void onTapDown(TapDownDetails d) {
    flappyLama.onTapDown();
  }
}
