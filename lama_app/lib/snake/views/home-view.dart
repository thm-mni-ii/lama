import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:lama_app/snake/components/start-button.dart';
import 'package:lama_app/snake/snake_game.dart';

class HomeView {
  final SnakeGame game;

  Rect bgRect;
  Paint bgPaint;
  Paint borderPaint;

  StartButton startButton;
  double _borderThickness = 3;

  HomeView(this.game) {
    this.startButton = StartButton(game);
    
    bgRect = Rect.fromLTWH(
      this.game.screenSize.width * 0.05,
      this.game.screenSize.height * 0.05,
      this.game.screenSize.width * 0.9,
      this.game.screenSize.height * 0.8,
    );

    bgPaint = Paint();
    bgPaint.color = Color(0xFFFFFFFF);
    borderPaint = Paint();
    borderPaint.color = Color(0xFF000000);
  }

  void render(Canvas c) {
    c.drawRect(bgRect.inflate(_borderThickness), borderPaint);
    c.drawRect(bgRect, bgPaint);
  }

  void update(double t) {}
}
