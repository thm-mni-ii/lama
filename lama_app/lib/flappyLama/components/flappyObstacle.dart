import 'dart:ui';
import 'dart:math';
import 'package:lama_app/flappyLama/flappyLamaGame.dart';


class FlappyObstacle{
  
  final FlappyLamaGame game;
  Paint _obstaclePaint;
  Rect _topObstacle;
  Rect _bottomObstacle;
  Rect _topObstacle2;
  Rect _bottomObstacle2;
  double _topObstacleLength;
  double _holeLength;

//obstacle move and reset after they leave the screen (2 objects moving)
  Random _randomNumber = Random();

  FlappyObstacle(this.game){
    
    _obstaclePaint = Paint();
    _obstaclePaint.color = Color(0xFF654321);

    _holeLength = game.screenSize.height/8;
    _topObstacleLength = 1 + (0.7 * game.screenSize.height - _holeLength) * _randomNumber.nextDouble();

    _topObstacle = Rect.fromLTWH(game.screenSize.width/2.8, 0, game.screenSize.width/5,
      _topObstacleLength);

    _bottomObstacle = Rect.fromLTWH(game.screenSize.width/2.8, _topObstacleLength + _holeLength, game.screenSize.width/5, 
      game.screenSize.height - (_topObstacleLength + _holeLength));

    _topObstacleLength = 1 + (0.7 * game.screenSize.height - _holeLength) * _randomNumber.nextDouble();

    _topObstacle2 = Rect.fromLTWH(game.screenSize.width, 0, game.screenSize.width/5,
    _topObstacleLength);

    _bottomObstacle2 = Rect.fromLTWH(game.screenSize.width/1, _topObstacleLength + _holeLength, game.screenSize.width/5, 
      game.screenSize.height - (_topObstacleLength + _holeLength));
  }

  void render(Canvas c){

    c.drawRect(_topObstacle, _obstaclePaint);
    c.drawRect(_bottomObstacle, _obstaclePaint);
    c.drawRect(_topObstacle2, _obstaclePaint);
    c.drawRect(_bottomObstacle2, _obstaclePaint);
  }
}