import 'dart:ui';
import 'dart:math';

import 'package:flame/anchor.dart';
import 'package:flame/components/component.dart';
import 'package:flame/sprite.dart';
import 'package:lama_app/flappyLama/flappyLamaGame.dart';

/// This class extends [Component] and describes an obstacle.
/// It will move from the right end to the start and will generate a random hole at a random position each time.
class FlappyObstacle extends Component {
  // SETTINGS
  // --------
  /// velocity of the obstacles [negative = right to left; positive = left to right]
  final double _velocity = -70;
  /// amount of tiles = size of the sprites / width of the obstacle
  final double _size = 1.5;
  /// minimum size of the hole = multiples by [_size] {[_minHoleSize] * [_size]}
  final double _minHoleSize = 2;
  /// maximum size of the hole = multiples by [_size] {[_maxHoleSize] * [_size]}
  final double _maxHoleSize = 3;
  // --------
  // SETTINGS

  /// This function gets called when [_passingObjectX] passes this obstacles X coordinate
  Function onPassing;
  /// This function gets called when an [Rect] collides with this obstacle in [collides]
  Function onCollide;

  /// actual size of the hole = multiples by [_size] {[_holeSize] * [_size]}
  int _holeSize;
  /// hole Index (index of the start of the hole)
  int _holeIndex;
  /// the x Coordinate of the object which will gets checked for passing in [_checkPassingObject]
  final double _passingObjectX;
  /// alter start location (true = starts at 1.5 screenwidth; false = start at 1.0 screenwidth)
  bool _alter;
  /// indicates if the [_passingObjectX] already passed the obstacle (resets after [_resetObstacle] has called
  bool _objectPassed = false;
  /// list of all the single sprites of the component
  List<SpriteComponent> _sprites;
  /// first component to get the position data
  SpriteComponent _first;
  final FlappyLamaGame _game;
  final Random _randomNumber = Random();

  FlappyObstacle(this._game, this._alter, this._passingObjectX, this.onPassing,
      [this.onCollide]);

  /// This method will generate the obstacle [_sprites] for the rendering.
  ///
  /// sideeffects:
  ///   [_sprites]
  void _createObstacleParts() {
    // reset the sprites
    _sprites = [];

    for (int i = 0; i < (this._game.tilesY / this._size); i++) {
      // common sprite component
      var tmp = SpriteComponent()
        ..height = _game.tileSize * _size
        ..width = _game.tileSize * _size
        ..x = _game.screenSize.width +
            (_alter ?
              (_game.tilesX ~/ 2) * _game.tileSize + _game.tileSize * _size :
              0)
        ..y = (_game.tileSize * _size) * i
        ..anchor = Anchor.topLeft;

      // start of the hole
      if (_holeIndex == i + 1) {
        tmp.sprite = Sprite('png/kaktus_end_top.png');
        _sprites.add(tmp);
      }
      // end of the hole
      else if (_holeIndex + _holeSize == i) {
        tmp.sprite = Sprite('png/kaktus_end_bottom.png');
        _sprites.add(tmp);
      }
      // body of the obstacle
      else if (!(i >= _holeIndex &&
          i <= _holeIndex + _holeSize)) {
        tmp.sprite = Sprite('png/kaktus_body.png');
        _sprites.add(tmp);
      }
    }

    // sets the first part of the obstacle
    _first = _sprites[0];
  }

  /// This method generate a new hole depending on the [_minHoleSize], [_maxHoleSize] and [_size].
  ///
  /// sideeffects:
  ///   [_holeIndex]
  ///   [_holeSize]
  void _generateHole() {
    // index of the position of the hole
    _holeIndex = _randomNumber.nextInt((_game.tilesY ~/ _size) - 1);
    // size of the hole
    _holeSize = _randomNumber.nextInt(
        ((_maxHoleSize - _minHoleSize) / _size).ceil() + 1) +
        (_minHoleSize / _size).ceil();
  }

  /// This method checks if the [object] hits the obstacle.
  ///
  /// It will call the [onCollide] function when a hit gets detected.
  /// return:
  ///   true = collides
  ///   false = no collision
  bool collides(Rect object) {
    if (object == null ||
        _sprites == null ||
        _sprites.isEmpty ||
        _sprites.length <= 0) {
      return false;
    }

    // X
    if ((object.left > _first.x &&
        object.left < _first.x + _first.width) ||
        (object.right > _first.x &&
        object.right < _first.x + _first.width)) {
      var holeTop = _holeIndex * _game.tileSize * _size;
      var holeBot =
          holeTop + (_holeSize * _game.tileSize * _size);
      // Y
      if (!((object.top >= holeTop || _holeIndex == 0) &&
          object.bottom <= holeBot)) {
        // callback
        onCollide?.call();
        return true;
      }
    }

    return false;
  }

  /// This method resets this obstacle and generates a new hole position and size as well as all the sprites.
  ///
  /// sideeffects:
  ///   [_holeSize] = random
  ///   [_holeIndex] = random depending on [_maxHoleSize]and [_minHoleSize]
  ///   [_sprites]
  ///   [_objectPassed] = false
  ///   [_alter] = false (removes the initial offset)
  void _resetObstacle() {
    // remove the initial offset
    _alter = false;
    _generateHole();
    _createObstacleParts();
    _objectPassed = false;
  }

  /// This method checks if the [_passingObjectX] passed the [right] x coordinate of this obstacle.
  ///
  /// When it passed than [onPassing] gets called.
  /// sideeffects:
  ///   [_objectPassed] = true when the object passed the obstacle
  void _checkPassingObject() {
    if (_passingObjectX != null &&
        !_objectPassed &&
        _passingObjectX > _first.x + _first.width) {
      onPassing?.call();
      _objectPassed = true;
    }
  }

  void update(double t) {
    if (_sprites.isNotEmpty) {
      // generate new holeSize and position and all parts when moving out of the screen
      if (_sprites[0].x <= -(_game.tileSize * _size)) {
        _resetObstacle();
      }

      // check if the [_passingObjectX] passes the obstacle
      _checkPassingObject();

      // moves the obstacles by [_velocity]
      _sprites?.forEach((element) => element.x += _velocity * t);
    }
  }

  void render(Canvas c) {
    // render each part of the snake
    for (SpriteComponent obstaclePart in _sprites) {
      // has so save the canvas because else it will lead to a render problem by adding up the x and y fields
      c.save();
      // render the part of the obstacle
      obstaclePart.render(c);
      // restore the canvas to the original data
      c.restore();
    }
  }

  void resize(Size size) {
    if (this._game.tileSize > 0) {
      // generates the hole and all the obstacle parts
      _generateHole();
      _createObstacleParts();
    }
  }
}
