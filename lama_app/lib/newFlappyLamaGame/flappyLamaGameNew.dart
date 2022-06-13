import 'dart:math';
import 'dart:ui';
import 'dart:developer' as developer;

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame/sprite.dart';

import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame/text.dart';
import 'package:flutter/material.dart' hide Image;
import 'package:flutter/services.dart';
import 'package:lama_app/trexGame/background/horizon.dart';
import 'package:lama_app/trexGame/game_over.dart';
import 'package:lama_app/trexGame/player.dart';

enum GameState { playing, intro, gameOver }

class NewFlappyGame extends FlameGame with TapDetector, HasCollisionDetection {
  late final Image spriteImage;

  @override
  Color backgroundColor() => const Color(0xFFFFFFFF);
  late final player = LamaPlayer();

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    spriteImage = await Flame.images.load('trex.png');
    add(player);
    const chars = '0123456789HI ';
    final renderer = SpriteFontRenderer(
      source: spriteImage,
      charWidth: 20,
      charHeight: 23,
      glyphs: {
        for (var i = 0; i < chars.length; i++)
          chars[i]: GlyphData(left: 954.0 + 20 * i, top: 0)
      },
      letterSpacing: 2,
    );
/*     add(
      scoreText = TextComponent(
        position: Vector2(20, 20),
        textRenderer: renderer,
      )..positionType = PositionType.viewport,
    ); */
    // score = 0;
  }

  GameState state = GameState.intro;
  double currentSpeed = 0.0;
  double timePlaying = 0.0;

  final double acceleration = 10;
  final double maxSpeed = 2500.0;
  final double startSpeed = 600;

  bool get isPlaying => state == GameState.playing;
  bool get isGameOver => state == GameState.gameOver;
  bool get isIntro => state == GameState.intro;

  @override
  void onTapDown(TapDownInfo info) {
    onAction();
  }

  void onAction() {
    if (isGameOver || isIntro) {
      //  restart();
      return;
    }
    player.jump(currentSpeed);
  }

  void gameOver() {
    // gameOverPanel.visible = true;
    state = GameState.gameOver;
    player.current = LamaState.idel;
    currentSpeed = 0.0;
  }

  void restart() {
    state = GameState.playing;
    player.reset();
    //  horizon.reset();
    currentSpeed = startSpeed;
    //  gameOverPanel.visible = false;
    timePlaying = 0.0;
/*     if (score > _highscore) {
      _highscore = score;
    }
    score = 0;
    _distanceTravelled = 0; */
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (isGameOver) {
      return;
    }

    if (isPlaying) {
      timePlaying += dt;
      //   _distanceTravelled += dt * currentSpeed;
      //  score = _distanceTravelled ~/ 50;

      if (currentSpeed < maxSpeed) {
        currentSpeed += acceleration * dt;
      }
    }
  }
}

/////////////////////////////////////////////////////
///
///
///
///
///
///
enum LamaState { idel, up, down }

class LamaPlayer extends SpriteAnimationGroupComponent<LamaState>
    with HasGameRef<NewFlappyGame>, CollisionCallbacks {
  LamaPlayer() : super(size: Vector2(90, 88));

  final double gravity = 1;

  final double initialJumpVelocity = -15.0;
  final double introDuration = 1500.0;
  final double startXPosition = 50;

  double _jumpVelocity = 0.0;

  double get groundYPos {
    return (gameRef.size.y / 2) - height / 2;
  }

  @override
  Future<void> onLoad() async {
////////////////////////

    ///////////////////////

    // Body hitbox
    add(
      RectangleHitbox.relative(
        Vector2(0.7, 0.6),
        position: Vector2(0, height / 3),
        parentSize: size,
      ),
    );
    // Head hitbox
    add(
      RectangleHitbox.relative(
        Vector2(0.45, 0.35),
        position: Vector2(width / 2, 0),
        parentSize: size,
      ),
    );
    animations = {
      LamaState.idel: _getAnimation(
        size: Vector2(88.0, 90.0),
        frames: [Vector2(1514.0, 4.0), Vector2(1602.0, 4.0)],
        stepTime: 0.2,
      ),
      LamaState.up: _getAnimation(
        size: Vector2(88.0, 90.0),
        frames: [Vector2(76.0, 6.0)],
      ),
      LamaState.down: _getAnimation(
        size: Vector2(88.0, 90.0),
        frames: [Vector2(1339.0, 6.0)],
      ),
    };
    current = LamaState.idel;
  }

  void jump(double speed) {
    if (current == LamaState.up) {
      return;
    }

    current = LamaState.up;
    _jumpVelocity = initialJumpVelocity - (speed / 500);
  }

  void reset() {
    y = groundYPos;
    _jumpVelocity = 0.0;
    current = LamaState.idel;
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (current == LamaState.up) {
      y += _jumpVelocity;
      _jumpVelocity += gravity;
      if (y > groundYPos) {
        reset();
      }
    } else {
      y = groundYPos;
    }

/*     if (gameRef.isIntro && x < startXPosition) {
      x += (startXPosition / introDuration) * dt * 5000;
    } */
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    y = groundYPos;
  }

  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    super.onCollisionStart(intersectionPoints, other);
    // gameRef.gameOver();
  }

  SpriteAnimation _getAnimation({
    required Vector2 size,
    required List<Vector2> frames,
    double stepTime = double.infinity,
  }) {
    return SpriteAnimation.spriteList(
      frames
          .map(
            (vector) => Sprite(
              gameRef.spriteImage,
              srcSize: size,
              srcPosition: vector,
            ),
          )
          .toList(),
      stepTime: stepTime,
    );
  }
}
