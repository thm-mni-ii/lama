import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/input.dart';
import 'package:flame/palette.dart';

import '../config/game_config.dart';
import '../config/styles.dart';
import '../snake/command_queue.dart';
import '../snake/grid.dart';
import '../snake/snake.dart';
import '../snake_game.dart';
import 'cell.dart';
import 'dynamic_fps_position_component.dart';

class World extends DynamicFpsPositionComponent with HasGameRef<SnakeGame> {
  final Grid _grid;
  final Snake _snake = Snake();
  final CommandQueue _commandQueue = CommandQueue();

  bool gameOver = false;

  World(this._grid) : super(GameConfig.fps) {
    _initializeSnake();
  }

  @override
  void updateDynamic(double dt) {
    if (!gameOver) {
      _commandQueue.evaluateNextInput(_snake);

      var nextCell = _getNextCell();

      if (nextCell != Grid.border) {
        if (_snake.checkCrash(nextCell)) {
          gameOver = true;
        } else {
          if (nextCell.cellType == CellType.food) {
            _snake.grow(nextCell);
            _grid.generateFood();
          } else {
            _snake.move(
                nextCell); //ich brauche die current Cell und die letzte Cell
          }
        }
      } else {
        gameOver = true;
      }
    }
  }

  @override
  void render(Canvas canvas) {
    if (gameOver) {
      canvas.drawRect(
          Rect.fromLTRB(
              2, 2, gameRef.canvasSize.x - 2, gameRef.canvasSize.y - 2),
          Styles.gameOver);
    }
  }

  void onTapUp(TapUpInfo info) {
    final touchPoint = info.eventPosition.game;
    _commandQueue.add(touchPoint);
  }

  void _initializeSnake() {
    var headIndex = GameConfig.headIndex;
    var snakeLength = GameConfig.initialSnakeLength;

    for (int i = 0; i < snakeLength; i++) {
      var snakePart =
          _grid.findCell(headIndex.x.toInt() - i, headIndex.y.toInt());
      _snake.addCell(snakePart);
      if (i == 0) {
        _snake.setHead(snakePart);
      }
    }
  }

  //TODO use vector addition instead of a switch
  Cell _getNextCell() {
    var row = _snake.head.row;
    var column = _snake.head.column;

    switch (_snake.direction) {
      case Direction.up:
        row--;
        break;
      case Direction.right:
        column++;
        break;
      case Direction.down:
        row++;
        break;
      case Direction.left:
        column--;
        break;
    }
    return _grid.findCell(column, row);
  }

  Cell _getCurrentCell() {
    //hierauf wird drauf aufgebaut -> dann wird ein sankeHead an dieser sStelle zu, SnakeBody
    var row = _snake.head.row;
    var column = _snake.head.column;

    switch (_snake.direction) {
      case Direction.up:
        row--;
        break;
      case Direction.right:
        column++;
        break;
      case Direction.down:
        row++;
        break;
      case Direction.left:
        column--;
        break;
    }
    return _grid.findCell(column, row);
  }
}
