import 'dart:core';
import 'dart:math';
import 'dart:ui';
import 'dart:ui';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

import 'package:flame/events.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame/palette.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/animation.dart';

import 'baseFlappy.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/flame.dart';
import 'package:flame/input.dart';
import 'package:flame/parallax.dart';
import 'package:flutter/material.dart';

import 'package:flutter/services.dart';

class ObstacleCompTest extends Component with HasGameRef {
  late Sprite kaktusTopComponent;
  late Sprite kaktusBodyComponent;
  late Sprite kaktusBottomComponent;

  var obstacleTopEndImage = 'png/kaktus_end_top.png';
  var obstacleBottomEndImage = 'png/kaktus_end_bottom.png';
  var obstacleBodyImage = 'png/kaktus_body.png';
  // SETTINGS
  // --------
  /// velocity of the obstacles [negative = right to left; positive = left to right]
  final double _velocity = -70;

  /// amount of tiles = size of the sprites / width of the obstacle
  final double _sizeInTiles = 1.5;

  /// minimum size of the hole = multiples by [_sizeInTiles] {[minHoleSize] * [_sizeInTiles]}
  double minHoleSize = 2;

  /// maximum size of the hole = multiples by [_sizeInTiles] {[maxHoleSize] * [_sizeInTiles]}
  double maxHoleSize = 3;

  /// maximum distance between the different holes
  final int _maxHoleDistance = 3;
  // --------
  // SETTINGS

  //FUNCTIONS
  // --------
  /// This function gets called when [_passingObjectX] passes this obstacles X coordinate
  Function(ObstacleCompTest)? onPassing;

  /// This function gets called when an [Rect] collides with this obstacle in [collides]
  Function? onCollide;

  /// This function gets called when the obstacle gets reset (holeIndex, holeSize).
  Function(int, int)? onResetting;

  int? _refHoleIndex;
  int? _refHoleSize;

  // --------
  //FUNCTIONS

  /// actual size of the hole = multiples by [_sizeInTiles] {[_holeSize] * [_sizeInTiles]}
  int? _holeSize;

  /// hole Index (index of the start of the hole)
  int? _holeIndex;

  /// the x Coordinate of the object which will gets checked for passing in [_checkPassingObject]
  late final double _passingObjectX;

  /// alter start location (true = starts at 1.5 screenwidth; false = start at 1.0 screenwidth)
  bool? _alter;

  /// indicates if the [_passingObjectX] already passed the obstacle (resets after [resetObstacle] has called
  bool _objectPassed = false;

  /// list of all the single sprites of the component
  List<SpriteComponent>? _sprites;
  SpriteComponent? _first;

  final FlappyLamaGame2 _game;
  //final Vector2 velocity;

  final Random _randomNumber = Random();
  get holeIndex {
    return _holeIndex;
  }

  get holeSize {
    return _holeSize;
  }

  ObstacleCompTest(this._game, this._alter, this._passingObjectX,
      this.onPassing, this.onCollide, this.minHoleSize, this.maxHoleSize) {
    SpriteComponent tmp = SpriteComponent()
      ..height = _game.tileSize * _sizeInTiles
      ..width = _game.tileSize * _sizeInTiles
      ..x = _game.screenSize.width +
          (_alter!
              ? (_game.tilesX ~/ 2) * _game.tileSize +
                  _game.tileSize * _sizeInTiles
              : 0)
      ..y = (_game.tileSize * _sizeInTiles) * 0
      ..anchor = Anchor.topRight;

    final fixedLengthList = new List<SpriteComponent>.filled(20, tmp);
  }

  /// This method will generate the obstacle [_sprites] for the rendering.
  ///
  /// sideeffects:
  ///   [_sprites]
  Future<void> _createObstacleParts() async {
    // reset the sprites
    if (_sprites != null) {
      //  removeAll(_sprites!);
    }

    _sprites = [];
    SpriteComponent tmp = SpriteComponent()
      ..height = _game.tileSize * _sizeInTiles
      ..width = _game.tileSize * _sizeInTiles
      ..x = _game.screenSize.width +
          (_alter!
              ? (_game.tilesX ~/ 2) * _game.tileSize +
                  _game.tileSize * _sizeInTiles
              : 0)
      ..y = (_game.tileSize * _sizeInTiles) * 0
      ..anchor = Anchor.topRight;

    final fixedLengthList = new List<SpriteComponent>.filled(20, tmp);

    for (int i = 0; i < (this._game.tilesY / this._sizeInTiles); i++) {
      // common sprite component

      var tmp = SpriteComponent()
        ..height = _game.tileSize * _sizeInTiles
        ..width = _game.tileSize * _sizeInTiles
        ..x = _game.screenSize.width +
            (_alter!
                ? (_game.tilesX ~/ 2) * _game.tileSize +
                    _game.tileSize * _sizeInTiles
                : 0)
        ..y = (_game.tileSize * _sizeInTiles) * i
        ..anchor = Anchor.topRight;

      // start of the hole
      if (_holeIndex == i + 1) {
        tmp.sprite = await gameRef.loadSprite(obstacleTopEndImage);
        fixedLengthList[i] = tmp;
        if (fixedLengthList[i].isLoaded) {
          remove(fixedLengthList[i]);
        }
        add(fixedLengthList[i]);
      }
      // end of the hole
      else if (_holeIndex! + _holeSize! == i) {
        tmp.sprite = await gameRef.loadSprite(obstacleBottomEndImage);
        fixedLengthList[i] = tmp;
        if (fixedLengthList[i].isLoaded) {
          remove(fixedLengthList[i]);
        }
        add(fixedLengthList[i]);
      }
      // body of the obstacle
      else if (!(i >= _holeIndex! && i <= _holeIndex! + _holeSize!)) {
        tmp.sprite = await gameRef.loadSprite(obstacleBodyImage);
        fixedLengthList[i] = tmp;
        if (fixedLengthList[i].isLoaded) {
          remove(fixedLengthList[i]);
        }
        add(fixedLengthList[i]);
      }
    }

    // sets the first part of the obstacle
    _first = _sprites![0];
  }

  void setConstraints(int alterHoleIndex, int alterHoleSize) {
    _refHoleIndex = alterHoleIndex;
    _refHoleSize = alterHoleIndex;
  }

  /// This method generate a new hole depending on the [minHoleSize], [maxHoleSize] and [_sizeInTiles].
  ///
  /// sideeffects:
  ///   [_holeIndex]
  ///   [_holeSize]
  void _generateHole() {
    // size of the hole
    _holeSize = _randomNumber
            .nextInt(((maxHoleSize - minHoleSize) / _sizeInTiles).ceil() + 1) +
        (minHoleSize / _sizeInTiles).ceil();

    // index of the position of the hole
    _holeIndex =
        _randomNumber.nextInt((_game.tilesY ~/ _sizeInTiles) - _holeSize!);

    if (_refHoleIndex != null && _refHoleSize != null) {
      // new hole lower ref && Distance to large
      if ((_holeIndex! > _refHoleIndex!) &&
          _holeIndex! - (_refHoleIndex! + _refHoleSize!) > _maxHoleDistance) {
        _holeIndex = (_refHoleIndex! + _refHoleSize!) + _maxHoleDistance > 0
            ? (_refHoleIndex! + _refHoleSize!) + _maxHoleDistance
            : 0;
      }
      // new hole higher ref && Distance to large
      else if ((_holeIndex! < _refHoleIndex!) &&
          _refHoleIndex! - (_holeIndex! + _holeSize!) > _maxHoleDistance) {
        _holeIndex = _refHoleIndex! - _maxHoleDistance > 0
            ? _refHoleIndex! - _holeSize! - _maxHoleDistance
            : 0;
      }
    }

    print("holeSize = $_holeSize");
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
        _sprites!.isEmpty ||
        _sprites!.length <= 0) {
      return false;
    }

    // X
    if ((object.left > _first!.x && object.left < _first!.x + _first!.width) ||
        (object.right > _first!.x &&
            object.right < _first!.x + _first!.width)) {
      var holeTop = _holeIndex! * _game.tileSize * _sizeInTiles;
      var holeBot = holeTop + (_holeSize! * _game.tileSize * _sizeInTiles);
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
  ///   [_holeIndex] = random depending on [maxHoleSize]and [minHoleSize]
  ///   [_sprites]
  ///   [_objectPassed] = false
  ///   [_alter] = false (removes the initial offset)
  void resetObstacle() {
    _generateHole();
    _createObstacleParts();
    // run callback
    //   onResetting?.call(_holeIndex, _holeSize);
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
        _passingObjectX > _first!.x + _first!.width) {
      onPassing?.call(this);
      _objectPassed = true;
    }
  }

  @override
  Future<void> onLoad() async {
/*     add(kaktusBodyComponent);
    ////////////////////////////////////////////////////////////
    ///
    ///
    final hitboxPaint = BasicPalette.white.paint();
    // ..style = PaintingStyle.stroke;
    add(
      PolygonHitbox.relative(
        [
          Vector2(-1.0, 0.0),
          Vector2(-1.0, -1.0),
          Vector2(0.0, -1.0),
          Vector2(0.0, 0.0),
        ],
        position: Vector2(kaktusBodyComponent.x, kaktusBodyComponent.y),
        parentSize: kaktusBodyComponent.size,
      )
        ..paint = hitboxPaint
        ..renderShape = true,
    );
    add(kaktusBottomComponent);
    ////////////////////////////////////////////////////////////
    ///
    ///

    add(
      PolygonHitbox.relative(
        [
          Vector2(-1.0, 0.0),
          Vector2(-1.0, -1.0),
          Vector2(0.0, -1.0),
          Vector2(0.0, 0.0),
        ],
        position: Vector2(kaktusBottomComponent.x, kaktusBottomComponent.y),
        parentSize: kaktusBottomComponent.size,
      )
        ..paint = hitboxPaint
        ..renderShape = true,
    );
    add(kaktusTopComponent);
    add(
      PolygonHitbox.relative(
        [
          Vector2(-1.0, 0.0),
          Vector2(-1.0, -1.0),
          Vector2(0.0, -1.0),
          Vector2(0.0, 0.0),
        ],
        position: Vector2(kaktusTopComponent.x, kaktusTopComponent.y),
        parentSize: kaktusTopComponent.size,
      )
        ..paint = hitboxPaint
        ..renderShape = true,
    ); */
  }

  @override
  Future<void> update(double dt) async {
    super.update(dt);

    if (_sprites!.isNotEmpty) {
      // generate new holeSize and position and all parts when moving out of the screen
      if (_sprites![0].x <= -(_game.tileSize * _sizeInTiles)) {
        // remove the initial offset
        _alter = false;
        resetObstacle();
      }

      // check if the [_passingObjectX] passes the obstacle
      // _checkPassingObject();

      // moves the obstacles by [_velocity]
      _sprites!.forEach((element) => element.x += _velocity * dt);
    }
  }

  void render(Canvas c) {
    // render each part of the obstacle
    for (SpriteComponent obstaclePart in _sprites!) {
      // has to save the canvas because otherwise it will lead to a render problem by adding up the x and y fields
      c.save();
      // render the part of the obstacle
      obstaclePart.render(c);
      // restore the canvas to the original data
      c.restore();
    }
  }

  @mustCallSuper
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    if (this._game.tileSize > 0) {
      // generates the hole and all the obstacle parts
      _generateHole();
      _createObstacleParts();
      // run callback

      onResetting?.call(_holeIndex!, _holeSize!);
    }
  }

/*   @override
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    super.onCollisionStart(intersectionPoints, other);
  } */
}
