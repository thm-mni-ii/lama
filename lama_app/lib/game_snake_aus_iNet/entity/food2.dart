import 'dart:ui';

import 'package:flame/components.dart';

import '../config/game_config.dart';
import '../config/styles.dart';
import '../snake_game.dart';

class Food2 extends PositionComponent with HasGameRef<SnakeGame> {
  var obstacleTopEndImage = 'png/kaktus_end_top.png';
  late SpriteComponent tmp;
  var x = 0;
  var y = 0;

  @override
  Future<void> onLoad() async {
    super.onLoad();

    tmp = SpriteComponent()
      ..sprite = await gameRef.loadSprite(obstacleTopEndImage)
      ..height = 50
      ..width = 50
      ..x = 50000
      ..y = 50000
      ..anchor = Anchor.topLeft;

    add(tmp);
  }

  @override
  void render(Canvas canvase) {
    tmp.x = x;
    tmp.y = y;
  }

  void setXandY(double x, double y) {
    this.x = x;
    this.y = y;
  }

  static Offset findMiddle(Vector2 location, int cellSize) {
    return Offset(location.x + cellSize / 2, location.y + cellSize / 2);
  }

  static double findRadius(int cellSize) {
    return cellSize / 2 - GameConfig.foodRadius;
  }
}
