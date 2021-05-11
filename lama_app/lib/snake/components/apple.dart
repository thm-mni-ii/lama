import 'dart:ui';

import 'package:lama_app/snake/snake_game.dart';
import 'package:lama_app/snake/models/position.dart';

class Apple {
  final SnakeGame game;
  Rect appleRect;
  Paint applePaint;
  bool isEaten = false;

  Apple(this.game, double x, double y) {
    appleRect = Rect.fromLTWH(x, y + this.game.fieldOffsetY, game.tileSize, game.tileSize);
    applePaint = Paint();
    applePaint.color = Color(0xe914ec15);
  }

  void render(Canvas c) {
    c.drawRect(appleRect, applePaint);
  }

  void update(double timeDelta) {
    // If the apple got hit by the snake, the apple spawns randomly on a free
    // place on the game board.
    if (isEaten) {
      appleRect = appleRect.translate(0, game.tileSize * 12 * timeDelta);
    }
  }
}