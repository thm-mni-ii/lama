import 'dart:ui';

import 'package:flame/components.dart';
import 'package:lama_app/game_snake_aus_iNet/snake/snake.dart';

import '../entity/food.dart';
import '../entity/snake_body.dart';
import '../newObstacleTry.dart';
import '../snakeTailAnimation.dart';
import '../snake_game.dart';
import '../snakeHeadAnimation.dart';
import '../snakeBodyAnimation.dart';

enum CellType { empty, snakeBody, food, snakeHead, snakeTail }

enum CellDirection { up, down, left, right }

class Cell extends PositionComponent with HasGameRef<SnakeGame> {
  var appleImage = 'png/apple.png';
  static Cell zero = Cell(Vector2(0, 0), 0);
  var test = 1;
  final Vector2 _index;
  final int _cellSize;
  CellType cellType;
  Vector2 _location = Vector2.zero();

  int counter = 0;

  late SpriteComponent appleSpriteComp;
  late AnimatedComponent snakeHead;
  late SnakeBodyy snakeBody;
  late SnakeTail snakeTail;
  late ObstacleCompNewTry testtest;

  CellDirection cellDirection = CellDirection.right;

  int get row => _index.x.toInt();

  int get column => _index.y.toInt();

  Vector2 get index => _index;

  Vector2 get location => _location;

  Cell(this._index, this._cellSize, {this.cellType = CellType.empty});

  @override
  Future<void> onLoad() async {
    super.onLoad();

    appleSpriteComp = SpriteComponent()
      ..sprite = await gameRef.loadSprite(appleImage)
      ..height = 30
      ..width = 30
      ..x = 50000
      ..y = 50000
      ..anchor = Anchor.topLeft;

    add(appleSpriteComp);

    snakeHead = AnimatedComponent(
      50,
      Vector2(0, 0),
      Vector2(150, 100),
      Vector2(150, 100),
    );
    add(snakeHead);

    snakeBody = SnakeBodyy(
      50,
      Vector2(0, 0),
      Vector2(150, 100),
      Vector2(150, 100),
    );
    add(snakeBody);

    snakeTail = SnakeTail(
      50,
      Vector2(0, 0),
      Vector2(150, 100),
      Vector2(150, 100),
    );
    add(snakeTail);

    var start = gameRef.offSets.start;
    _location =
        Vector2(column * _cellSize + start.x, row * _cellSize + start.y);
  }

  @override
  Future<void> update(double dt) async {
    super.update(dt);
  }

  void setDirectionSnakeHead(int a) {
    snakeHead.setDirectionOfAnimation(a);
  }

  void setDirectionSnakeTail(int a) {
    snakeTail.setDirectionOfAnimation(a);
  }

  @override
  void render(Canvas canvas) {
    // TODO get rid of switch by making the cell type an object and directly call render on it.
    switch (cellType) {
      case CellType.snakeHead:
        SnakeBody.render(canvas, _location, _cellSize);
        appleSpriteComp.x = 2000.0;
        appleSpriteComp.y = 2000.0;
        snakeHead.x = _location.x;
        snakeHead.y = _location.y;
        snakeBody.x = 2000.0;
        snakeBody.y = 2000.0;
        snakeTail.x = 2000.0;
        snakeTail.y = 2000.0;
        switch (cellDirection) {
          case CellDirection.up:
            snakeTail.setDirectionOfAnimation(2);
            snakeHead.setDirectionOfAnimation(2);

            // TODO: Handle this case.
            break;
          case CellDirection.down:
            snakeTail.setDirectionOfAnimation(1);
            snakeHead.setDirectionOfAnimation(1);

            // TODO: Handle this case.
            break;
          case CellDirection.left:
            snakeTail.setDirectionOfAnimation(3);
            snakeHead.setDirectionOfAnimation(3);

            // TODO: Handle this case.
            break;
          case CellDirection.right:
            snakeTail.setDirectionOfAnimation(4);
            snakeHead.setDirectionOfAnimation(4);

            // TODO: Handle this case.
            break;
        }
        break;

      case CellType.snakeBody:
        SnakeBody.render(canvas, _location, _cellSize);
        appleSpriteComp.x = 2000.0;
        appleSpriteComp.y = 2000.0;
        snakeHead.x = 2000.0;
        snakeHead.y = 2000.0;
        snakeBody.x = _location.x;
        snakeBody.y = _location.y;
        snakeTail.x = 2000.0;
        snakeTail.y = 2000.0;
        break;

      case CellType.food:
        Food.render(canvas, _location, _cellSize);
        appleSpriteComp.x = _location.x;
        appleSpriteComp.y = _location.y;
        snakeHead.x = 2000.0;
        snakeHead.y = 2000.0;
        snakeBody.x = 2000.0;
        snakeBody.y = 2000.0;
        snakeTail.x = 2000.0;
        snakeTail.y = 2000.0;
        break;

      case CellType.snakeTail:
        SnakeBody.render(canvas, _location, _cellSize);
        snakeTail.x = _location.x;
        snakeTail.y = _location.y;
        appleSpriteComp.x = 2000.0;
        appleSpriteComp.y = 2000.0;
        snakeHead.x = 2000.0;
        snakeHead.y = 2000.0;
        snakeBody.x = 2000.0;
        snakeBody.y = 2000.0;
        switch (cellDirection) {
          case CellDirection.up:
            snakeTail.setDirectionOfAnimation(2);
            snakeHead.setDirectionOfAnimation(2);

            // TODO: Handle this case.
            break;
          case CellDirection.down:
            snakeTail.setDirectionOfAnimation(1);
            snakeHead.setDirectionOfAnimation(1);

            // TODO: Handle this case.
            break;
          case CellDirection.left:
            snakeTail.setDirectionOfAnimation(3);
            snakeHead.setDirectionOfAnimation(3);

            // TODO: Handle this case.
            break;
          case CellDirection.right:
            snakeTail.setDirectionOfAnimation(4);
            snakeHead.setDirectionOfAnimation(4);

            // TODO: Handle this case.
            break;
        }
        break;

      case CellType.empty:
        appleSpriteComp.x = 2000.0;
        appleSpriteComp.y = 2000.0;
        snakeHead.x = 2000.0;
        snakeHead.y = 2000.0;
        snakeBody.x = 2000.0;
        snakeBody.y = 2000.0;
        snakeTail.x = 2000.0;
        snakeTail.y = 2000.0;
        break;
    }
  }
}
