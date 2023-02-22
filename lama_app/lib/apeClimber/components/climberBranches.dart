import 'dart:ui';
import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/palette.dart';

import 'package:flame/sprite.dart';
import 'package:lama_app/apeClimber/climberGame.dart';
import 'package:lama_app/apeClimber/components/climberBranch.dart';

import '../../apeClimberUpdate/climberGame2.dart';

/// This class is [Component] to display a [List] of [ClimberBranch]s.
class ClimberBranches extends PositionComponent {
  // SETTINGS
  // --------
  /// flag to show the branch on the display
  final bool _showCollisionBranch = false;
  // --------
  // SETTINGS

  /// reference to the BaseGame
  final ApeClimberGame _game;

  /// Random for generate random bools
  final Random _rnd = Random();

  /// Branch SpriteComponents
  late List<ClimberBranch> _branches;

  /// Number of branches on the display
  late double _branchCount;

  /// Offset of all branches to the middle of the screen on the x coordinate
  final double _offsetX;

  /// Distance of all branches to another on the y coordinate
  final double _branchDistance;

  /// last branch on the screen
  late SpriteComponent _lastBranch;

  /// flag if the components are moving
  bool _moving = false;

  /// pixel each component will move on the y coordinate
  double _moveWidth = 96;

  /// pixel left which the components has to move
  double _moveTimeLeft = 0;

  /// Time how long the movements takes
  final double _moveTime;

  /// This method gets called when the branches finished moving
  late Function onBranchesMoved;

  /// Branch for collision detection
  late ClimberBranch collisionBranch;

  /// This getter returns if the next branch which the monkey will hit is on the left side
  get isLeft {
    return collisionBranch != null &&
        collisionBranch.x < _game.screenSize.width / 2;
  }

  ClimberBranches(
      this._game, this._branchDistance, this._offsetX, this._moveTime) {
    _createBranches();
  }

  /// This method highlightes the branch which the monkey will hit.
  void highlightCollisionBranch() {
    collisionBranch.hit = false;
  }

  /// This method creates all branch SpriteComponents
  Future<void> _createBranches() async {
    _branchCount = (_game.screenSize.height / _branchDistance) + 1;
    // clear branches
    _branches = [];

    for (var i = 0; i < _branchCount; i++) {
      var branch = ClimberBranch()
        ..height = _game.branchSize
        ..width = _game.branchSize * 3
        ..y = _game.screenSize.height / 1.5 -
            (_branchDistance + i * _branchDistance)
        ..anchor = Anchor.topLeft;
      _branches.add(branch);

      if (_rnd.nextBool()) {
        branch.sprite = await _game
            .loadSprite('png/stick_3m.png'); //Sprite('png/stick_3m.png');
        branch.x =
            _game.screenSize.width / 2 - this._offsetX - 3 * _game.branchSize;
      } else {
        branch.sprite = await _game
            .loadSprite('png/stick_3.png'); //Sprite('png/stick_3.png');
        branch.x = _game.screenSize.width / 2 + this._offsetX;
      }

      _lastBranch = branch;
    }
    collisionBranch = _branches[0]; // das ist Neu!!!!!!!!!!!!
  }

  /// This method checks all branches if they are out of the screen and reset them to the start,
  Future<void> _updateBranches() async {
    for (ClimberBranch branchElement in _branches) {
      if (branchElement.y > _game.screenSize.height) {
        branchElement.y = _lastBranch.y - _branchDistance;
        branchElement.opacity = 1;

        if (_rnd.nextBool()) {
          branchElement.sprite = await _game
              .loadSprite('png/stick_3m.png'); //Sprite('png/stick_3m.png');
          branchElement.x =
              _game.screenSize.width / 2 - this._offsetX - 3 * _game.branchSize;
        } else {
          branchElement.sprite = await _game
              .loadSprite('png/stick_3.png'); //Sprite('png/stick_3.png');
          branchElement.x = _game.screenSize.width / 2 + this._offsetX;
        }
        _lastBranch = branchElement;
      }
    }
  }

  /// This method selectes the next branch after the current [collisionBranch] as [collisionBranch].
  void _selectNextCollisionDetectionBranch() {
    var index =
        collisionBranch == null ? 0 : _branches.indexOf(collisionBranch);

    if (collisionBranch == null || index >= _branches.length - 1) {
      collisionBranch = _branches[0];
    } else {
      collisionBranch = _branches[index + 1];
    }
  }

  /// This methods flag the movement of the tree by [y] to the bottom in [_moveTime].
  ///
  /// This will handle in [update]
  void move(double y) {
    if (_moving) {
      return;
    }

    _moveTimeLeft = _moveTime;
    _moving = true;
    _moveWidth = y;
    _selectNextCollisionDetectionBranch();
  }

  @override
  void update(double t) {
    // movement active?
    if (_moving && _game.screenSize != null) {
      // movement ongoing?
      if (_moveTimeLeft > 0) {
        var dtMoveWidth = (_moveWidth) *
            ((t < _moveTimeLeft ? t : _moveTimeLeft) / _moveTime);
        var percentOver = ((t < _moveTimeLeft ? t : _moveTimeLeft) / _moveTime);
        _branches.forEach((element) {
          element.y += dtMoveWidth;

          if (element == collisionBranch) {
            element.opacity = percentOver;
          }
        });

        _updateBranches();

        _moveTimeLeft -= t;
      }
      // movement finished = disable movement
      else {
        collisionBranch.opacity = 0;
        onBranchesMoved.call();
        _moving = false;
      }
    }
  }

  @override
  void render(Canvas c) {
    _branches.forEach((element) {
      c.save();
      element.render(c);

      // show the collision branch
      if (_showCollisionBranch) {
        c.restore();
        c.save();
        if (element == collisionBranch) {
          var rect = element.toRect();
          c.drawRect(rect, Paint()..color = Color.fromRGBO(255, 0, 0, 0.3));
        }
      }
      c.restore();
    });
  }
}
