import 'dart:ui';
import 'dart:developer' as developer;
import 'package:flutter/cupertino.dart';
import 'package:lama_app/flappyLama/flappyLamaGame.dart';

class FlappyLama {
  final FlappyLamaGame game;
  Rect lamaRect;
  Size screenSize;
  Paint lamaPaint;
  bool isGameStarted = false;

  double initY = 0.0;
  double speedY = 0.0;
  double x;
  double y;

  static const double GRAVITY = 100;

  FlappyLama(this.game) {
    resize();
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

      if (this.y > game.tileSize * 7) {
        y = game.tileSize * 7;
        speedY = 0.0;
        isGameStarted = false;
      }

      if (this.y < 0) {
        isGameStarted = false;
        developer.log("[y=${this.y}, ymax=${initY} ");
        this.y = initY;
        speedY = 0.0;
      }
    }
    lamaRect = Rect.fromLTWH(x, y, game.tileSize, game.tileSize);
  }

  void jump() {
    this.speedY = -100;
  }

  void resize() {
    this.x = game.tileSize * 0.5;
    this.y = game.tileSize * 4;
    lamaRect = Rect.fromLTWH(x, y, game.tileSize, game.tileSize);

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
