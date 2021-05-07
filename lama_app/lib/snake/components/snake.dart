import 'dart:collection';
import 'dart:math';
import 'dart:ui';
import 'dart:developer' as developer;

import 'package:lama_app/snake/models/position.dart';
import 'package:lama_app/snake/snake_game.dart';

class SnakeComponent {
  final bool debugMovement = true;
  final bool log = true;

  Random rnd = Random();
  Queue<Position> snakeParts = Queue();
  double velocity = 5;

  final SnakeGame game;

  double _deltaCounter = 0;
  int _direction = 1;

  SnakeComponent(Position startPos, this.game) {
    snakeParts.add(Position(startPos.x, startPos.y + this.game.fieldOffsetY));
  }

  /// This method moves the snake by the given direction for 1 tile.
  /// [dir] 1 = north, 2 = west, 3 = east everything else = south
  void moveSnake(int dir, [bool grow = false]) {
    Position headPos = snakeParts.last;
    switch(dir) {
      case 3 : {
        headPos = headPos.x <= 1 ? Position(this.game.maxFieldX, headPos.y) : Position(headPos.x - 1, headPos.y);
        break;
      }
      case 2 : {
        headPos = headPos.x >= this.game.maxFieldX ? Position(1, headPos.y) : Position(headPos.x + 1, headPos.y);
        break;
      }
      case 1 : {
        headPos = headPos.y <= this.game.fieldOffsetY + 1 ? Position(headPos.x, this.game.maxFieldY + this.game.fieldOffsetY) : Position(headPos.x, headPos.y - 1);
        break;
      }
      default : {
        headPos = headPos.y >= this.game.maxFieldY + this.game.fieldOffsetY ? Position(headPos.x, this.game.fieldOffsetY + 1) : Position(headPos.x, headPos.y + 1);
        break;
      }
    }

    // only removes the tail when no growth
    if (!grow) {
      snakeParts.removeFirst();
    }

    // adds the new head
    snakeParts.add(headPos);
  }

  void render(Canvas c) {
    // render each part of the snake
    for (Position tmpSnake in snakeParts) {
      // rectangle for each part
      Rect bgRect = Rect.fromLTWH(
          (tmpSnake.x - 1) * this.game.tileSize,
          (tmpSnake.y - 1) * this.game.tileSize,
          this.game.tileSize,
          this.game.tileSize);

      Paint bgPaint = Paint();
      // color the head different than the tail
      bgPaint.color = Color(tmpSnake == snakeParts.last ? 0xFF208421 : 0xFF200021);

      c.drawArc(bgRect, 0, 10, true, bgPaint);
    }
  }

  void update(double t) {
    // measures the time which has past
    _deltaCounter += t;

    // moves the snake depending on its velocity
    if (_deltaCounter / (1 / velocity) > 1.0) {
      // debug_movement = snake moves towards an random direction
      if (debugMovement) {
        _direction = rnd.nextInt(4);
      }

      // debug_movement = snake growths with 10% chance
      moveSnake(_direction, debugMovement ? rnd.nextInt(100) > 90 : false);

      if (log) {
        developer.log("[Snake][Movement] time past = $_deltaCounter");
        developer.log("[Snake][Movement] direction = $_direction");
      }

      // resets the deltaCounter
      _deltaCounter = 0;
    }
  }
}