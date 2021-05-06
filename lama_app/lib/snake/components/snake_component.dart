import 'dart:collection';
import 'dart:ui';
import 'dart:developer' as developer;

import 'package:lama_app/snake/models/position.dart';
import 'package:lama_app/snake/models/snake.dart';

class SnakeComponent {
  Queue<Snake> snakeParts = Queue();
  Position headPos;
  final double tileSize;
  final int fieldX;
  final int fieldY;

  SnakeComponent(Position startPos, this.tileSize, this.fieldX, this.fieldY) {
    snakeParts.add(Snake(startPos));
  }

  /// This method moves the snake by the given direction for 1 tile.
  /// [dir] 1 = north, 2 = west, 3 = east everything else = south
  void moveSnake(int dir, [bool grow = false]) {
    Position headPos = snakeParts.last.position;
    switch(dir) {
      case 3 : {
        headPos = headPos.x <= 1 ? Position(fieldX, headPos.y) : Position(headPos.x - 1, headPos.y);
        break;
      }
      case 2 : {
        headPos = headPos.x >= fieldX ? Position(1, headPos.y) : Position(headPos.x + 1, headPos.y);
        break;
      }
      case 1 : {
        headPos = headPos.y <= 1 ? Position(headPos.x, fieldY) : Position(headPos.x, headPos.y - 1);
        break;
      }
      default : {
        headPos = headPos.y >= fieldY ? Position(headPos.x, 1) : Position(headPos.x, headPos.y + 1);
        break;
      }
    }
    // only removes the tail when no growth
    if (!grow) {
      snakeParts.removeFirst();
    }

    // adds the new head
    snakeParts.add(Snake(headPos));
  }

  void render(Canvas c) {
    for (Snake tmpSnake in snakeParts) {
      // rectangle
      Rect bgRect = Rect.fromLTWH(
          (tmpSnake.position.x - 1) * tileSize,
          (tmpSnake.position.y - 1) * tileSize,
          tileSize,
          tileSize);

      // paint
      Paint bgPaint = Paint();
      // color the head different than the tail
      bgPaint.color = Color(tmpSnake == snakeParts.last ? 0xFF208421 : 0xFF200021);

      c.drawArc(bgRect, 0, 10, true, bgPaint);
    }
  }

  void update(double t) {}
}