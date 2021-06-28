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
  bool initialize = false;
  bool _flagLeft = false;
  SpriteComponent _lastBranch;

  ClimberBranches(this._game, this._branchDistance, this._offsetX){
    _branchCount = ((_game.screenSize.height/1.5 - _branchDistance) / _branchDistance) + 1;
    initializing();
  }

  List<SpriteComponent> getBranches(){
    return _branches;
  }

  void initializing(){
    
    _branches = [];
    for(var i = 0; i < 2*_branchCount; i++){
      var tmp = getSide();
      var branch = SpriteComponent()
        ..height = _game.tileSize
        ..width = _game.tileSize*3
        ..x = tmp
        ..y = _game.screenSize.height/1.5 - (_branchDistance + i*_branchDistance)
        ..anchor = Anchor.topLeft;
      _branches.add(branch);
      if(_flagLeft) branch.sprite = Sprite('png/stick_3m.png');
      
      else branch.sprite = Sprite('png/stick_3.png');
      
      _lastBranch = branch;
    }
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
        branchElement.y = _lastBranch.y - _branchDistance;
        _lastBranch = branchElement;
      }
    }
  }

  void onTapDown(){
    for (SpriteComponent branchElement in _branches){
      branchElement.y += this._branchDistance;
    }
    resetting();
  }

  void render(Canvas c){
  }

  void update(double t){
  }
}