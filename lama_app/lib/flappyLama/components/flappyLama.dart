import 'dart:ui';
import 'dart:developer' as developer;
import 'package:flame/components/component.dart';
import 'package:flutter/cupertino.dart';
import 'package:lama_app/flappyLama/flappyLamaGame.dart';
import 'package:flame/animation.dart';
import 'package:flame/components/animation_component.dart';
import 'package:flame/spritesheet.dart';

class FlappyLama extends AnimationComponent {
  Animation _idle;
  Animation _up;
  
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
        columns: 8,
        rows: 1,
    );
    
    _idle = spriteSheet.createAnimation(
        0,
        from: 0,
        to: 4,
        stepTime: 0.1
    );
    
    _up = spriteSheet.createAnimation(
        0,
        from: 5,
        to: 8,
        stepTime: 0.1
    );

    this.animation = _up;
    
    _lamaHeight = game.tileSize;
    _lamaWidth = game.tileSize;
    resize(this.game.screenSize);
    lamaPaint = Paint();
    lamaPaint.color = Color(0xffffffff);
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
    this.height = 48;
    this.width = 48;
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
