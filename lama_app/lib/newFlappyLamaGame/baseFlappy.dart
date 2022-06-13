import 'dart:ui';
import 'dart:developer' as developer;

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/flame.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';

import 'package:lama_app/app/model/game_model.dart';
import 'package:lama_app/app/model/highscore_model.dart';
import 'package:lama_app/app/repository/user_repository.dart';
import 'package:lama_app/flappyLama/components/flappyLama.dart';
import 'package:lama_app/flappyLama/components/flappyObstacle.dart';
import 'package:lama_app/flappyLama/components/flappyScoreDisplay.dart';
import 'package:lama_app/flappyLama/widgets/playModeWidget.dart';
import 'package:lama_app/flappyLama/widgets/startScreen.dart';

import '../app/screens/game_list_screen.dart';
import 'package:flame/events.dart';
//import 'package:lama_app/newFlappyLamaGame/lamaSpriteAnimation.dart';

import 'dart:math';
import 'dart:ui';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/palette.dart';

import 'CollidableAnimationComponent.dart';
import 'baseAnimationComponent.dart';

class FlappyLamaGame2 extends FlameGame with HasTappables {
  double y = 120;

  /// size of the lama
  final double _lamaSize = 48;

  /// screensize of the game
  late Size _screenSize;

  /// Getter of [_screenSize]
  Size get screenSize {
    return _screenSize;
  }

  /// gravity of the lama = falling speed
  static const double GRAVITY = 1000;
  double _speedY = 0.0;
  @override
  Color backgroundColor() => const Color(0xFFFFFFFF);

  /// a bool flag which indicates if the game has started
  bool _started = true;
  bool get started {
    return _started;
  }

  /// the lama [AnimationComponent]
  late LamaAnimationComponent _lama;
  late AnimatedComponent _lama2;

  /// necessary context for determine the actual screensize
  BuildContext _context;

  /// the [UserRepository] to interact with the database and get the user infos
  UserRepository _userRepo;

  FlappyLamaGame2(this._context, this._userRepo) {
    initializeAsync();
  }

  void loadStartScreenAsync() async {
    _lama = LamaAnimationComponent(this, _lamaSize); //..onHitGround = gameOver;
    add(_lama);
  }

  /// This method load the [Size] of the screen and loads the StartScreen
  void initializeAsync() async {
    // resize
    //  resize(await Flame.util.initialDimensions());

    loadStartScreenAsync();
  }
/* @override
  void onTapDown(TapDownInfo info) {
    if (_started) {
      _lama.onTapDown(info);
    }
  } */

  void resize(Size size) {
    // get the screensize fom [MediaQuery] because [size] is incorrect on some devices
    _screenSize = Size(
        MediaQuery.of(_context).size.width -
            MediaQuery.of(_context).padding.left -
            MediaQuery.of(_context).padding.right,
        MediaQuery.of(_context).size.height -
            MediaQuery.of(_context).padding.top -
            MediaQuery.of(_context).padding.bottom);
    // calculates by the width of the screen
    // _tileSize = screenSize.width / tilesX;
    //_tilesY = screenSize.height ~/ tileSize;

    //  super.resize(size);
  }

  void update(double t) {
    super.update(t);
    //  _lama.y += 150;
  }

  void render(Canvas canvas) {
    // draw the hitboxframe

    super.render(canvas);
  }

  @override
  Future<void> onLoad() async {
    add(ScreenHitbox());
    final componentSize = Vector2(80.0, 90.0);
    add(
      AnimatedComponent(
        _lamaSize,
        this,
        Vector2(0, 0),
        Vector2(150, y),
        componentSize,
      ),
    );
  }
}
