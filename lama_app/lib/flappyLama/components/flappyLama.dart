import 'dart:ui';
import 'dart:developer' as developer;
import 'package:flame/components/component.dart';
import 'package:flutter/cupertino.dart';
import 'package:lama_app/flappyLama/flappyLamaGame.dart';
import 'package:flame/animation.dart';
import 'package:flame/components/animation_component.dart';
import 'package:flame/spritesheet.dart';

/// This class extends [AnimationComponent] and describes a flying lama.
/// It contains three different animations for idle, up and falling.
class FlappyLama extends AnimationComponent {
  Animation _idle;
  Animation _up;
  Animation _fall;
  double _size;

  /// Initialize the class with the given [_size].
  FlappyLama(this._size) : super.empty() {
    // size
    this.height = this._size;
    this.width = this._size;
  
  final FlappyLamaGame game;
  Rect lamaRect;
  Size screenSize;
  Paint lamaPaint;
  bool isGameStarted = false;

  double initY = 0.0;
  double speedY = 0.0;
  double x;
  double y;

  final relativeX = 0.05;
  final relativeY = 0.10;

  double _lamaHeight;
  double _lamaWidth;

  static const double GRAVITY = 1300;

  FlappyLama(this.game) : super.empty() {
    final spriteSheet = SpriteSheet(
        imageName: 'png/lama_animation.png',
        textureWidth: 24,
        textureHeight: 24,
        columns: 12,
        rows: 1,
    );
    
    // idle / hover animation
    _idle = spriteSheet.createAnimation(
        0,
        from: 0,
        to: 4,
        stepTime: 0.1
    );
    
    // up animation
    _up = spriteSheet.createAnimation(
        0,
        from: 5,
        to: 8,
        stepTime: 0.1
    );

    // fall animation
    _fall = spriteSheet.createAnimation(
        0,
        from: 9,
        to: 12,
        stepTime: 0.1
    );

    // start animation
    this.animation = _idle;
    
    _lamaHeight = game.tileSize;
    _lamaWidth = game.tileSize;
    resize(this.game.screenSize);
    lamaPaint = Paint();
    lamaPaint.color = Color(0xffffffff);
  }

  /// This method let the lama fly up with an impuls.
  void flap() {
    this.animation = _up;
  }

  /// This method let the lama fly steady on the actual height.
  void hover() {
    this.animation = _idle;
  }

  void render(Canvas c) {
    c.drawRect(lamaRect, lamaPaint);
  }

  void update(double t) {
    if (isGameStarted == true) {
      this.speedY += GRAVITY * t;
      this.y += this.speedY * t;

      if (this.y > game.flappyGround.groundY - _lamaHeight) {
        y = game.flappyGround.groundY - _lamaHeight;
        speedY = 0.0;
        isGameStarted = false;
      }

      if (this.y <= 0) {
        developer.log("[y=${this.y}, ymax=${initY} ");
        speedY = 0.0;
        this.speedY += GRAVITY * t;
        this.y += this.speedY * t;
      }
    }
    lamaRect = Rect.fromLTWH(x, y, _lamaWidth, _lamaHeight);
  }

  void jump() {
    this.speedY = -600;
  }

  void resize(Size size) {
    // start location
    this.x = (game.screenSize.width * relativeX);
    this.y = game.screenSize.height / 2 -
        (game.screenSize.height * relativeY) -
        _lamaHeight;
    lamaRect = Rect.fromLTWH(x, y, _lamaWidth, _lamaHeight);

    this.initY = this.y;
  }

  bool isFalling() {
    return (this.y >= this.initY);
  }

  void onTapDown() {
    isGameStarted = true;
    jump();
  }
}
