import 'dart:math';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:lama_app/snake/snake_game.dart';
import 'package:lama_app/snake/models/position.dart';

class Apple {
  final SnakeGame game;

  Position position;

  Rect _appleRect;
  Paint _applePaint;
  Random _rnd = Random();

  Apple(this.game) {
    setRandomPosition();

    _applePaint = Paint();
    _applePaint.color = Color(0xe9ea0000);
  }

  /// This method sets a new random [Position] of the Apple.
  /// [excludePositions] = this Positions will get ignored when finding a new one
  void setRandomPosition([List<Position> excludePositions]) {
    // new random Position
    var newPosition = Position(_rnd.nextInt(this.game.maxFieldX + 1), _rnd.nextInt(this.game.maxFieldY) + this.game.fieldOffsetY + 1);

    // exclude a list of Positions
    if (excludePositions != null) {
      while (excludePositions.any((pos) => pos.x == newPosition.x && pos.y == newPosition.y)) {
        newPosition = Position(_rnd.nextInt(this.game.maxFieldX + 1), _rnd.nextInt(this.game.maxFieldY + 1));
      }
    }

    position = newPosition;

    // calculate the new rectangle
    _appleRect = Rect.fromLTWH(
        (newPosition.x - 1) * this.game.tileSize,
        (newPosition.y - 1) * this.game.tileSize,
        this.game.tileSize,
        this.game.tileSize);
  }

  void render(Canvas c) {
    c.drawArc(_appleRect, 0, 10, true, _applePaint);
  }

  void update(double timeDelta) {}
}