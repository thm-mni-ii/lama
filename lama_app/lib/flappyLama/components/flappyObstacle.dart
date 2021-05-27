import 'dart:ui';
import 'dart:math';
import 'package:flame/anchor.dart';
import 'package:flame/components/component.dart';
import 'package:flame/sprite.dart';
import 'package:lama_app/flappyLama/flappyLamaGame.dart';


class FlappyObstacle extends Component {
  final double _velocity = -70;
  int _holeSize;
  int _holePosition;
  int _number;
  List<SpriteComponent> _sprites;
  
  final FlappyLamaGame game;
  Paint _obstaclePaint;
  Rect _topObstacle;
  Rect _bottomObstacle;
  Rect _topObstacle2;
  Rect _bottomObstacle2;
  double _topObstacleLength;
  double _holeLength;
  int _score = 0;
  bool _isHandled = false;
  bool _isHandled2 = false;


//obstacle move and reset after they leave the screen (2 objects moving)
  Random _randomNumber = Random();

  FlappyObstacle(this.game, this._holePosition, this._holeSize, this._number) {
    
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

  void render(Canvas c) {

    /*c.drawRect(_topObstacle, _obstaclePaint);
    c.drawRect(_bottomObstacle, _obstaclePaint);
    c.drawRect(_topObstacle2, _obstaclePaint);
    c.drawRect(_bottomObstacle2, _obstaclePaint);*/

    // render each part of the snake
    for (SpriteComponent obstacle in _sprites) {
      c.save();
      obstacle.render(c);
      c.restore();
    }
  }

  void update(double t){
    //score increments when left side of lama passes right side of obstacle

    /*if (game.screenSize.width/4 >_bottomObstacle.right && _isHandled == false){
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
   
    _bottomObstacle = _bottomObstacle.translate(_velocity * t, 0);
    _topObstacle = _topObstacle.translate(_velocity * t, 0);
    _bottomObstacle2 = _bottomObstacle2.translate(_velocity * t, 0);
    _topObstacle2 = _topObstacle2.translate(_velocity * t, 0);*/

    if (_sprites.isNotEmpty) {
      _sprites?.forEach(
              (element) {
                element.x += element.x > -this.game.tileSize * 2 ? _velocity * t : this.game.screenSize.width + this.game.tileSize * 2;
              });
    }
  }

  void resize(Size size) {
    if (this.game.tileSize > 0) {
      _sprites = [];
      var h = 1;
      for (int i = 0; i < this.game.tilesY; i++) {
        if (this._holePosition == i + 1) {
          var tmp = SpriteComponent()
            ..height = this.game.tileSize * 2
            ..width = this.game.tileSize * 2
            ..sprite = Sprite('png/kaktus_end_top.png')
            ..x = this.game.screenSize.width + (this._number * 4 * this.game.tileSize)
            ..y = this.game.tileSize * i
            ..anchor = Anchor.topLeft;

          _sprites.add(tmp);
          h = 1;
        }
        else if (this._holePosition + this._holeSize + 1 == i) {
          var tmp = SpriteComponent()
            ..height = this.game.tileSize * 2
            ..width = this.game.tileSize * 2
            ..sprite = Sprite('png/kaktus_end_bottom.png')
            ..x = this.game.screenSize.width + (this._number * 4 * this.game.tileSize)
            ..y = this.game.tileSize * i
            ..anchor = Anchor.topLeft;

          _sprites.add(tmp);
          h = 1;
        }
        else if (!(i >= this._holePosition && i <= this._holePosition + this._holeSize)) {
          var tmp = SpriteComponent()
            ..height = this.game.tileSize * 2
            ..width = this.game.tileSize * 2
            ..sprite = Sprite('png/kaktus_body.png')
            ..x = this.game.screenSize.width + (this._number * 4 * this.game.tileSize)
            ..y = this.game.tileSize * i
            ..anchor = Anchor.topLeft;

          _sprites.add(tmp);
          h = 1;
        } else {
          h += 1;
        }
      }
    }
  }
}