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
  double _apemove;
  double _offsetX = 30;
  double _offsetY = 20;
  double _branchDistance = 200;
  int _firstBranchPosition;
  bool initialize = false;
  bool _flagLeft = false;


  ClimberBranches(this._game, this._firstBranchPosition, this._apemove, this._offsetX){
    _branches = [];
    var branch = SpriteComponent()
      ..height = _game.tileSize
      ..width = _game.tileSize*3
      ..x = _game.screenSize.width/2 + this._offsetX
      ..y = _game.screenSize.height/2
      ..anchor = Anchor.topLeft;
    _branches.add(branch);
    branch.sprite = Sprite('png/stick_3.png');

    branch = SpriteComponent()
      ..height = _game.tileSize
      ..width = _game.tileSize*3
      ..x = _game.screenSize.width/2 - this._offsetX - branch.width
      ..y = _game.screenSize.height/2 - _branchDistance
      ..anchor = Anchor.topLeft;
    _branches.add(branch);
    branch.sprite = Sprite('png/stick_3m.png');

    branch = SpriteComponent()
      ..height = _game.tileSize
      ..width = _game.tileSize*3
      ..x = _game.screenSize.width/2 + this._offsetX
      ..y = _game.screenSize.height/2 - _branchDistance*2
      ..anchor = Anchor.topLeft;
    _branches.add(branch);
    branch.sprite = Sprite('png/stick_3.png');
  }

  List<SpriteComponent> getBranches(){
    return _branches;
  }

  double getSide(){
    var tmp;
    //left
    if(_randomNumber.nextInt(2) == 0){
      tmp = _game.screenSize.width/2 - this._offsetX - 3*_game.tileSize;
      _flagLeft = true;
    }
    //right
    else{
      tmp = _game.screenSize.width/2 + this._offsetX;
      _flagLeft = false;
    } 
    return tmp;
  }

  void resetting(){
    var tmp;
    for (SpriteComponent branchElement in _branches){
      if (branchElement.y > _game.screenSize.height){
        tmp = getSide();
        if(_flagLeft){
          branchElement.sprite = Sprite('png/stick_3m.png');
        }
        else {
          branchElement.sprite = Sprite('png/stick_3.png');
        }
        branchElement.x = tmp;
        branchElement.y = 0 - _offsetY;
      }
    }
  }

  void onTapDown(){
    for (SpriteComponent branchElement in _branches){
      branchElement.y += this._apemove;
    }
    resetting();
  }

  void render(Canvas c){
  }

  void update(double t){
  }
}