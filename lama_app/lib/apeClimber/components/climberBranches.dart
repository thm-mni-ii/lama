import 'dart:ui';
import 'dart:math';

import 'package:flame/anchor.dart';
import 'package:flame/components/component.dart';
import 'package:flame/sprite.dart';
import 'package:lama_app/apeClimber/climberGame.dart';

class ClimberBranches extends Component {
  /// reference to the BaseGame
  final ClimberGame _game;
  /// Random for generate random bools
  final Random _rnd = Random();
  /// Branch SpriteComponents
  List<SpriteComponent> _branches;
  /// Number of branches on the display
  double _branchCount;
  /// Offset of all branches to the middle of the screen on the x coordinate
  final double _offsetX;
  /// Distance of all branches to another on the y coordinate
  final double _branchDistance;
  /// last branch on the screen
  SpriteComponent _lastBranch;
  /// flag if the components are moving
  bool _moving = false;
  /// pixel each component will move on the y coordinate
  double _moveWidth = 96;
  /// pixel left which the components has to move
  double _moveTimeLeft = 0;
  /// Time how long the movements takes
  final double _moveTime;

  ClimberBranches(this._game, this._branchDistance, this._offsetX, this._moveTime) {
    _createBranches();
  }

  /// This method creates all branch SpriteComponents
  void _createBranches() {
    _branchCount = (_game.screenSize.height / _branchDistance) + 1;
    // clear branches
    _branches = [];

    for(var i = 0; i < _branchCount; i++){
      var branch = SpriteComponent()
        ..height = _game.tileSize
        ..width = _game.tileSize * 3
        ..y = _game.screenSize.height / 1.5 - (_branchDistance + i*_branchDistance)
        ..anchor = Anchor.topLeft;
      _branches.add(branch);

      if (_rnd.nextBool()) {
        branch.sprite = Sprite('png/stick_3m.png');
        branch.x = _game.screenSize.width / 2 - this._offsetX - 3 * _game.tileSize;
      }
      else {
        branch.sprite = Sprite('png/stick_3.png');
        branch.x = _game.screenSize.width / 2 + this._offsetX;
      }
      
      _lastBranch = branch;
    }
  }

  /// This method checks all branches if they are out of the screen and reset them to the start,
  void _updateBranches() {
    for (SpriteComponent branchElement in _branches) {
      if (branchElement.y > _game.screenSize.height) {
        branchElement.y = _lastBranch.y - _branchDistance;

        if (_rnd.nextBool()) {
          branchElement.sprite = Sprite('png/stick_3m.png');
          branchElement.x = _game.screenSize.width / 2 - this._offsetX - 3 * _game.tileSize;
        }
        else {
          branchElement.sprite = Sprite('png/stick_3.png');
          branchElement.x = _game.screenSize.width / 2 + this._offsetX;
        }
        _lastBranch = branchElement;
      }
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
  }

  @override
  void update(double t) {
    // movement active?
    if (_moving && _game.screenSize != null) {
      // movement ongoing?
      if (_moveTimeLeft > 0) {
        var dtMoveWidth = (_moveWidth) * ((t < _moveTimeLeft ? t : _moveTimeLeft) / _moveTime);
        _branches?.forEach((element) {
          element.y += dtMoveWidth;
        });

        _updateBranches();

        _moveTimeLeft -= t;
      }
      // movement finished = disable movement
      else {
        _game.increaseScore();
        _moving = false;
      }
    }
  }

  @override
  void render(Canvas c) {
    _branches?.forEach((element) {
      c.save();
      element.render(c);
      c.restore();
    });
  }
}