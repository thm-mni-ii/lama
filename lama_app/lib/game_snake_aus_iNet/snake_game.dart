import 'dart:io';
import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:lama_app/game_snake_aus_iNet/snakeBodyAnimation.dart';

import 'component/background.dart';
import 'component/world.dart';
import 'config/game_config.dart';
import 'entity/food2.dart';
import 'entity/snake_body.dart';
import 'snake/grid.dart';
import 'snake/offsets.dart';

import 'snakeHeadAnimation.dart';

class SnakeGame extends FlameGame with TapDetector {
  Grid grid = Grid(GameConfig.rows, GameConfig.columns, GameConfig.cellSize);
  World? world;
  OffSets offSets = OffSets(Vector2.zero());
  late PositionComponent testapfel;
  late AnimatedComponent userLama;
  late SnakeBodyy snakebody;

  var duration = const Duration(seconds: 1);

  int a = 1;

  static int counter = 0;

  get screenSize => null;

  get userHighScore => null;

  get allTimeHighScore => null;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    offSets = OffSets(canvasSize);

    add(BackGround(GameConfig.cellSize));
    testapfel = Food2();
    add(testapfel);
    // ignore: avoid_function_literals_in_foreach_calls
    grid.cells.forEach((rows) => rows.forEach((cell) => add(cell)));
    grid.generateFood(/* testapfel */);

    world = World(grid);
    add(world!);

    /*  userLama = AnimatedComponent(
      50,
      this,
      Vector2(0, 0),
      Vector2(150, 100),
      Vector2(150, 100),
    );
    add(userLama); */

/*     snakebody = SnakeBodyy(
      50,
      this,
      Vector2(0, 0),
      Vector2(150, 150),
      Vector2(150, 100),
    );
    add(snakebody); */
  }

  @override
  void onTapUp(TapUpInfo info) {
    world!.onTapUp(info);

    // userLama.setDirectionOfAnimation(a);
    //snakebody.setDirectionOfAnimation(a);
    a++;
    if (a > 4) a = 0;
  }

  @override
  Future<void> update(double dt) async {
    super.update(dt);
  }
}
