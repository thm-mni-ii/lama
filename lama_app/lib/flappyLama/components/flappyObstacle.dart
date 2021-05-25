import 'dart:ui';
import 'dart:math';
import 'package:flame/components/component.dart';
import 'package:lama_app/flappyLama/flappyLamaGame.dart';


class FlappyObstacle extends Component{
  
  final FlappyLamaGame game;
  Paint _obstaclePaint;
  Rect _topObstacle;
  Rect _bottomObstacle;
  Rect _topObstacle2;
  Rect _bottomObstacle2;
  double _topObstacleLength;
  double _holeLength;
  double _movespeed = -30;
  int _score = 0;
  bool _isHandled = false;
  bool _isHandled2 = false;


//obstacle move and reset after they leave the screen (2 objects moving)
  Random _randomNumber = Random();

  FlappyObstacle(this.game){
    
    _obstaclePaint = Paint();
    _obstaclePaint.color = Color(0xFF654321);


    _holeLength = game.screenSize.height/6;
    _topObstacleLength = 0.1 + (0.7 * game.screenSize.height - _holeLength) * _randomNumber.nextDouble();

    _topObstacle = Rect.fromLTWH(game.screenSize.width/2, 0, game.screenSize.width/5,
      _topObstacleLength);
//3rd Parameter of the bottom obstacles is equal to the beginning of the ground(if we implement positions)
    _bottomObstacle = Rect.fromLTWH(game.screenSize.width/2, _topObstacleLength + _holeLength, game.screenSize.width/5, 
      0.65*game.screenSize.height - (_topObstacleLength + _holeLength));

    _topObstacleLength = 0.1 + (0.7 * game.screenSize.height - _holeLength) * _randomNumber.nextDouble();

    _topObstacle2 = Rect.fromLTWH(game.screenSize.width*1.2, 0, game.screenSize.width/5,
      _topObstacleLength);

    _bottomObstacle2 = Rect.fromLTWH(game.screenSize.width*1.2, _topObstacleLength + _holeLength, game.screenSize.width/5, 
      0.65*game.screenSize.height - (_topObstacleLength + _holeLength));
  }

  int get score => _score;

  void render(Canvas c){

    c.drawRect(_topObstacle, _obstaclePaint);
    c.drawRect(_bottomObstacle, _obstaclePaint);
    c.drawRect(_topObstacle2, _obstaclePaint);
    c.drawRect(_bottomObstacle2, _obstaclePaint);
  }

  void update(double t){

    //score increments when left side of lama passes right side of obstacle

    if (game.screenSize.width/4 >_bottomObstacle.right && _isHandled == false){
      ++this.game.score;
      _isHandled = true;
    }
    if (game.screenSize.width/4 > _bottomObstacle2.right && _isHandled2 == false){
      ++this.game.score;
      _isHandled2 = true;
    }
    if(_bottomObstacle.right < 0){
      _isHandled = false;
      _topObstacleLength = 0.1 + (0.7 * game.screenSize.height - _holeLength) * _randomNumber.nextDouble();

      _topObstacle = Rect.fromLTWH(game.screenSize.width*1.2, 0, game.screenSize.width/5,
        _topObstacleLength);

      _bottomObstacle = Rect.fromLTWH(game.screenSize.width*1.2, _topObstacleLength + _holeLength, game.screenSize.width/5, 
        0.65*game.screenSize.height - (_topObstacleLength + _holeLength));

    }

    if(_bottomObstacle2.right < 0){
      _isHandled2 = false;
      _topObstacleLength = 0.1 + (0.7 * game.screenSize.height - _holeLength) * _randomNumber.nextDouble();

      _topObstacle2 = Rect.fromLTWH(game.screenSize.width*1.2, 0, game.screenSize.width/5,
        _topObstacleLength);

      _bottomObstacle2 = Rect.fromLTWH(game.screenSize.width*1.2, _topObstacleLength + _holeLength, game.screenSize.width/5, 
        0.65*game.screenSize.height - (_topObstacleLength + _holeLength));
    }
   
    _bottomObstacle = _bottomObstacle.translate(_movespeed * t, 0);
    _topObstacle = _topObstacle.translate(_movespeed * t, 0);
    _bottomObstacle2 = _bottomObstacle2.translate(_movespeed * t, 0);
    _topObstacle2 = _topObstacle2.translate(_movespeed * t, 0);
    
  }
}