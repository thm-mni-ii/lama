import 'dart:collection';
import 'dart:math';
import 'dart:ui';
import 'dart:developer' as developer;

import 'package:lama_app/snake/components/snakeSpriteComponent.dart';
import 'package:lama_app/snake/models/position.dart';
import 'package:lama_app/snake/snakeGame.dart';

import 'apple.dart';

class SnakeComponent {
  final bool debugMovement = false;
  final bool log = true;

  Random rnd = Random();
  Queue<SnakeSpriteComponent> snakeParts = Queue();
  double velocity = 3;
  /// callback when the snake bites itself
  Function callbackBiteItSelf;
  /// callback when the snake hits the border
  Function callbackCollideWithBorder;
  /// callback when the snake hits the border
  Function(Apple) callbackEatsApple;

  final SnakeGame game;

  double _deltaCounter = 0;
  int _direction = 1;
  int _lastDirection = 1;
  double _maxVelocity = 15;

  SnakeComponent(this.game, Position startPos, this.velocity) {
    snakeParts.addFirst(SnakeSpriteComponent(
        SnakePart.Tail,
        this.game.tileSize,
        1)
      ..fieldX = (startPos.x)
      ..fieldY = (startPos.y + this.game.fieldOffsetY + 1));
    snakeParts.addFirst(SnakeSpriteComponent(
      SnakePart.Head,
      this.game.tileSize,
      1)
      ..fieldX = (startPos.x)
      ..fieldY = (startPos.y + this.game.fieldOffsetY));
  }

  /// This is the setter of [_direction]
  /// [dir] could be: 1 = north, 2 = west, 3 = south, 4 = east, else = not valid / ignored
  /// You cant move in the opposite direction so this will gets ignored.
  set direction(int dir) {
    if (dir != _lastDirection && dir <= 5 && dir > 0) {
      if (!(_lastDirection.isOdd && dir.isOdd || _lastDirection.isEven && dir.isEven)) {
        _direction = dir;
      }
    }
  }

  /// This method moves the snake by the given direction for 1 tile.
  /// [dir] 1 = north, 2 = west, 3 = south everything else = east
  void moveSnake(int dir, List<Apple> apples) {
    var newPart = getNewSnakeComponent(dir);

    // no movement in between the field possible
    if (newPart == null) {
      if (log) {
        developer.log("[Snake][moveSnake] collide with the border");
      }

      if (callbackCollideWithBorder != null) {
        callbackCollideWithBorder();
      }
    }
    else if (collideWithSnake(newPart)) {
      if (log) {
        developer.log("[Snake][moveSnake] biteItSelf");
      }

      if (callbackBiteItSelf != null) {
        callbackBiteItSelf();
      }
    } else {
      if (_lastDirection != _direction) {
        snakeParts.first.part = SnakePart.BodyCorner;

        if ((_lastDirection == 1 && _direction == 2) || (_lastDirection == 4 && _direction == 3)) {
          snakeParts.first.setDirection(2);
        }
        else if ((_lastDirection == 3 && _direction == 4) || (_lastDirection == 2 && _direction == 1)) {
          snakeParts.first.setDirection(4);
        }
        else if ((_lastDirection == 3 && _direction == 2) || (_lastDirection == 4 && _direction == 1)) {
          snakeParts.first.setDirection(1);
        }
        else if ((_lastDirection == 1 && _direction == 4) || (_lastDirection == 2 && _direction == 3)) {
          snakeParts.first.setDirection(3);
        }
      } else {
        snakeParts.first.part = SnakePart.Body;
      }

      developer.log("[SnakeComponent][moveSnake] x=${newPart.fieldX},y=${newPart.fieldY}");
      snakeParts.addFirst(newPart);
      _lastDirection = _direction;
      
      growOnHittingApple(apples);
    }
  }

  void growOnHittingApple(List<Apple> apples) {
    if (apples != null) {
      for (Apple apple in apples) {
        if (collideWithHead(apple.position)) {
          if (callbackEatsApple != null) {
            callbackEatsApple(apple);
          }
          developer.log("[SnakeComponent][eatApples] eat an apple");

          return;
        }
      }
    }

    snakeParts.removeLast();
    var tmp = snakeParts.removeLast();
    tmp.setDirection(getDirection(Position(tmp.fieldX, tmp.fieldY), Position(snakeParts.last.fieldX, snakeParts.last.fieldY)));
    tmp.part = SnakePart.Tail;
    snakeParts.addLast(tmp);
  }

  /// This method checks if the head is on the given [position]
  bool collideWithHead(Position position) {
    return position != null &&
        snakeParts.first.fieldX == position.x &&
        snakeParts.first.fieldY == position.y;
  }

  /// This method checks if there is an snakepart on the given [position]
  bool collideWithSnake(SnakeSpriteComponent part) {
    return part != null &&
        snakeParts.where((it) => it.fieldX == part.fieldX && it.fieldY == part.fieldY).isNotEmpty;
  }

  SnakeSpriteComponent getNewSnakeComponent(int dir) {
    SnakeSpriteComponent headPart = snakeParts.first;

    switch(dir) {
      case 3 : {
        if (headPart.fieldY >= (this.game.maxFieldY + this.game.fieldOffsetY)) {
          return null;
        }

        return SnakeSpriteComponent(
            SnakePart.Head,
            this.game.tileSize,
            dir)
          ..fieldX = headPart.fieldX
          ..fieldY = headPart.fieldY + 1;
      }
      case 2 : {
        if (headPart.fieldX <= 1) {
          return null;
        }

        return SnakeSpriteComponent(
            SnakePart.Head,
            this.game.tileSize,
            dir)
          ..fieldX = headPart.fieldX - 1
          ..fieldY = headPart.fieldY;
      }
      case 1 : {
        if (headPart.fieldY <= (this.game.fieldOffsetY + 1)) {
          return null;
        }

        return SnakeSpriteComponent(
            SnakePart.Head,
            this.game.tileSize,
            dir)
          ..fieldX = headPart.fieldX
          ..fieldY = headPart.fieldY - 1;
      }
      default : {
        if (headPart.fieldX >= this.game.maxFieldX) {
          return null;
        }

        return SnakeSpriteComponent(
            SnakePart.Head,
            this.game.tileSize,
            dir)
          ..fieldX = headPart.fieldX + 1
          ..fieldY = headPart.fieldY;
      }
    }
  }

  int getDirection(Position from, Position to) {
    if (to.x > from.x) {
      return 4;
    }
    if (to.x < from.x) {
      return 2;
    }
    if (to.y > from.y) {
      return 3;
    }
    if (to.y < from.y) {
      return 1;
    }
    return 0;
  }

  void render(Canvas c) {
    // render each part of the snake
    for (SnakeSpriteComponent tmpSnake in snakeParts) {
      tmpSnake.render(c);
    }
  }

  void update(double t, List<Apple> apples) {
    // measures the time which has past
    _deltaCounter += t;

    // moves the snake depending on its velocity
    if (_deltaCounter / (1 / (velocity > _maxVelocity ? _maxVelocity : velocity)) > 1.0) {
      moveSnake(_direction, apples);

      // resets the deltaCounter
      _deltaCounter = 0;
    }
  }
}