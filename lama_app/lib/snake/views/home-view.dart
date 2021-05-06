import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:lama_app/snake/snake_game.dart';

class HomeView {
  final SnakeGame game;
  Rect titleRect;
  Paint titlePaint;

  HomeView(this.game) {
    titleRect = Rect.fromLTWH(
      game.tileSize,
      (game.screenSize.height / 2) - (game.tileSize * 5),
      game.tileSize * 7,
      game.tileSize * 5,
    );
    titlePaint = Paint();
    titlePaint.color = Color(0xFFFFFFF);
  }

  void render(Canvas c) {
    c.drawRect(titleRect, titlePaint);
  }

  void update(double t) {}
}
