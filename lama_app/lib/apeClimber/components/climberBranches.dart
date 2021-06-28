import 'dart:ui';
import 'dart:math';

import 'package:flame/anchor.dart';
import 'package:flame/components/component.dart';
import 'package:flame/sprite.dart';
import 'package:lama_app/apeClimber/climberGame.dart';

class ClimberBranches extends Component {
  final ClimberGame _game;
  final Random _randomNumber = Random();
  List<SpriteComponent> _branches;
  double _branchCount;
  double _offsetX = 30;
  double _branchDistance;
  SpriteComponent _lastBranch;

  ClimberBranches(this._game, this._branchDistance, this._offsetX) {
    _branchCount = ((_game.screenSize.height / 1.5 - _branchDistance) / _branchDistance) + 1;

    _createBranches();
  }

  void _createBranches() {
    _branches = [];

    for(var i = 0; i < 2 * _branchCount; i++){
      var branch = SpriteComponent()
        ..height = _game.tileSize
        ..width = _game.tileSize * 3
        ..y = _game.screenSize.height / 1.5 - (_branchDistance + i*_branchDistance)
        ..anchor = Anchor.topLeft;
      _branches.add(branch);

      if (_randomNumber.nextBool()) {
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

  void _checkBranches() {
    for (SpriteComponent branchElement in _branches) {
      if (branchElement.y > _game.screenSize.height) {
        branchElement.y = _lastBranch.y - _branchDistance;

        if (_randomNumber.nextBool()) {
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

  void onTapDown() {
    for (SpriteComponent branchElement in _branches){
      branchElement.y += this._branchDistance;
    }
    _checkBranches();
  }

  @override
  void update(double t) {
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