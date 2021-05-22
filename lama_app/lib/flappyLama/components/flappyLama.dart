import 'dart:ui';
import 'dart:developer' as developer;
import 'package:flutter/cupertino.dart';
import 'package:lama_app/flappyLama/flappyLamaGame.dart';

class FlappyLama {
  final FlappyLamaGame game;
  Rect lamaRect;
  Size screenSize;
  Paint lamaPaint;
  bool isJumping = false;

  double maxY = 0.0;
  double speedY = 0.0;
  double x;
  double y;

  static const double GRAVITY = 1000;

  FlappyLama(this.game) {
    resize();
    lamaPaint = Paint();
    lamaPaint.color = Color(0xffffffff);
  }

  void render(Canvas c) {
    c.drawRect(lamaRect, lamaPaint);
  }

  void update(double t) {
    this.speedY += GRAVITY * t;
    this.y += this.speedY * t;

    if (isFalling()) {
      this.y = this.maxY;

      this.speedY = 0.0;
    }
    lamaRect = Rect.fromLTWH(x, y, game.tileSize, game.tileSize);
    //TODO:Make lama fall below from the starting point
  }

  void jump() {
    this.speedY = -600;
  }

  void resize() {
    this.x = game.tileSize * 0.5;
    this.y = game.tileSize * 4;
    lamaRect = Rect.fromLTWH(x, y, game.tileSize, game.tileSize);

    this.maxY = this.y;
  }

  bool isFalling() {
    developer.log("[y=${this.y}, maxY=${maxY} ");
    return (this.y >= this.maxY);
  }

  void onTapDown() {
    isJumping = true;
    //developer.log("[y=${this.y}, ymax=${maxY} ");
    if (isFalling()) {
      jump();
    }
  }
}
