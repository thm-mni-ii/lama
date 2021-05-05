import 'dart:ui';

import 'package:lama_app/snake/snake_game.dart';

class Background {
  final SnakeGame game;
  Rect bgRect;
  Paint bgPaint;

  /// Constructor of this class
  ///
  /// Needs an instance of [SnakeGame] to determine the corresponding size of the screen.
  Background(this.game) {
    // background rectangle
    bgRect = Rect.fromLTWH(
      0,
      game.screenSize.height - (game.tileSize * 23),
      game.tileSize * 9,
      game.tileSize * 23,
    );

    // background color
    bgPaint = Paint();
    bgPaint.color = Color(0xFFF9FBB6);
  }

  void render(Canvas c) {
    c.drawRect(bgRect, bgPaint);
  }

  void update(double t) {}
}