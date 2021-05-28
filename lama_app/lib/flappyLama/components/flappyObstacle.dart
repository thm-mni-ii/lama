import 'dart:ui';
import 'dart:math';
import 'package:flame/anchor.dart';
import 'package:flame/components/component.dart';
import 'package:flame/sprite.dart';
import 'package:lama_app/flappyLama/flappyLamaGame.dart';

/// This class extends [Component] and describes an obstacle.
/// It will move from the right end to the start and will generate a random hole at a random position each time.
class FlappyObstacle extends Component {
  final double _velocity = -70;
  // count of the tiles
  final double _size = 1.5;
  // will be multiplied by the _size
  final double _minHoleTiles = 2;
  // will be multiplied by the _size
  final double _maxHoleTiles = 3;
  // will be multiplied by the _size
  int _holeSize;
  int _holePosition;
  // alter start location
  bool _alter;
  List<SpriteComponent> _sprites;
  Function onObstacleResets;
  
  final FlappyLamaGame game;
  //obstacle move and reset after they leave the screen (2 objects moving)
  Random _randomNumber = Random();

  FlappyObstacle(this.game, this._alter, this.onObstacleResets);

  void render(Canvas c) {
    // render each part of the snake
    for (SpriteComponent obstacle in _sprites) {
      c.save();
      obstacle.render(c);
      c.restore();
    }
  }

  /// This method will generate the obstacle [_sprites] for the rendering.
  /// sideeffects:
  ///   [_sprites]
  void createObstacleParts() {
    _sprites = [];
    for (int i = 0; i < (this.game.tilesY / this._size); i++) {
      var tmp = SpriteComponent()
        ..height = this.game.tileSize * this._size
        ..width = this.game.tileSize * this._size
        ..x = this.game.screenSize.width + (this._alter ? (this.game.tilesX ~/ 2) * this.game.tileSize + this.game.tileSize * this._size : 0)
        ..y = (this.game.tileSize * this._size) * i
        ..anchor = Anchor.topLeft;

      if (this._holePosition == i + 1) {
        tmp.sprite = Sprite('png/kaktus_end_top.png');
        _sprites.add(tmp);
      }
      else if (this._holePosition + this._holeSize == i) {
        tmp.sprite = Sprite('png/kaktus_end_bottom.png');
        _sprites.add(tmp);
      }
      else if (!(i >= this._holePosition && i <= this._holePosition + this._holeSize)) {
        tmp.sprite = Sprite('png/kaktus_body.png');
        _sprites.add(tmp);
      }
    }
  }

  /// This method generate a new hole depending on the [_minHoleTiles], [_maxHoleTiles] and [_size].
  /// sideeffects:
  ///   [_holePosition]
  ///   [_holeSize]
  void generateHole() {
    this._holePosition = _randomNumber.nextInt((this.game.tilesY ~/ this._size) - 1);
    this._holeSize =
        _randomNumber.nextInt(((this._maxHoleTiles - this._minHoleTiles) / this._size).ceil() + 1) +
            (_minHoleTiles / this._size).ceil();
  }

  void update(double t) {
    if (_sprites.isNotEmpty) {
      // reset the obstacle when moving out of the screen
      if (_sprites[0].x <= -(this.game.tileSize * this._size)) {
        // remove the initial offset
        this._alter = false;
        generateHole();
        createObstacleParts();
        // run callback
        onObstacleResets?.call();
      }

      // moves the obstacles
      _sprites?.forEach((element) => element.x += _velocity * t);
    }
  }

  void resize(Size size) {
    if (this.game.tileSize > 0) {
      generateHole();
      createObstacleParts();
    }
  }
}