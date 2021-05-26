import 'dart:ui';
import 'dart:developer' as developer;
import 'package:flame/components/component.dart';
import 'package:flutter/cupertino.dart';
import 'package:lama_app/flappyLama/flappyLamaGame.dart';

class FlappyLama extends Component {
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

  FlappyLama(this.game) {
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
