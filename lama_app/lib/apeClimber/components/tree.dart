import 'dart:collection';
import 'dart:ui';

import 'package:flame/components.dart';

import 'package:lama_app/apeClimber/components/treeSprite.dart';

import '../../apeClimberUpdate/climberGame2.dart';

/// This class is [PositionComponent] to display a complete tree.
class Tree extends PositionComponent {
  // SETTINGS
  // --------
  /// Time how long the movements takes
  final double _moveTime;
  // --------
  // SETTINGS

  /// reference to the BaseGame
  final ApeClimberGame _game;

  /// height of each components (constraints: [componentCount] and [_screenSize]
  late double _individualHeight;

  /// size of the screen
  Size _screenSize;

  /// flag if the components are moving
  bool _moving = false;

  /// pixel each component will move on the y coordinate
  double _moveWidth = 96;

  /// pixel left which the components has to move
  double _moveTimeLeft = 0;

  /// number of components
  final int componentCount;

  /// all components of the tree
  Queue<TreeSprite> _treeComponents = Queue<TreeSprite>();

  /// The constructor need the amount [componentCount] of components the tree should consists of
  /// and the time [_moveTime] it needs to move the tree.
  Tree(this._game, this._screenSize, this.componentCount, this._moveTime);

  /// This method adds all components depending on the [componentCount].
  void _addTreeParts() {
    for (int i = 0; i < componentCount + 1; i++) {
      _treeComponents.addFirst(TreeSprite(
          width,
          _individualHeight,
          _screenSize.width / 2 - width / 2,
          (i - 1) * _individualHeight,
          i.isEven));
    }
    addAll(_treeComponents);
  }

  /// This methods flag the movement of the tree by [y] to the bottom in [_moveTime].
  ///
  /// This will handle in [update]
  int test = 0;
  void move(double y) {
    test += 1;
    if (_moving) {
      return;
    }

    _moveTimeLeft = _moveTime;
    _moving = true;
    _moveWidth = y;
  }

  @override
  void update(double dt) {
    // movement active?
    //neu: _screenSize wurde zu _game.screensize
    if (_moving && _game.screenSize != null) {
      // movement ongoing?
      if (_moveTimeLeft > 0) {
        var dtMoveWidth = (_moveWidth) *
            ((dt < _moveTimeLeft ? dt : _moveTimeLeft) / _moveTime);
        _treeComponents.forEach((element) {
          element.y += dtMoveWidth;
        });

        // remove the part which moves out of the screen and add one on the top
        if (test ==
            2 /* _treeComponents.first.y > _screenSize.height */ /* /5 */) {
          test = 0;
          _treeComponents.removeFirst();
          _treeComponents.add(TreeSprite(
              width,
              _individualHeight,
              _screenSize.width / 2 - width / 2,
              _treeComponents.last.y -
                  _individualHeight * 2, //*2 wurde hinzugefügt
              (_treeComponents.isNotEmpty
                  ? !_treeComponents.last.alterSprite
                  : false)));
          add(_treeComponents.last);
        }
        _moveTimeLeft -= dt;
      }
      // movement finished = disable movement
      else {
        _moving = false;
      }
    }

    super.update(dt);
  }

  @override
  void render(Canvas c) {
    // render each sprite of the tree
    _treeComponents.forEach((element) {
      c.save();
      element.render(c);
      c.restore();
    });
  }

  @override
  void onGameResize(Vector2 canvasSize) {
    //_individualHeight = 50;
    //_addTreeParts();
    // set the screensize
    // _screenSize = size;
    print("thats the canvas Size");
    print(canvasSize.y);
    if (canvasSize.y > 0) {
      // calculate the individual height
      _individualHeight = _screenSize.height / (componentCount - 1);
      // add all tree components
      _addTreeParts();
    }
    super.onGameResize(canvasSize);
  }
}
