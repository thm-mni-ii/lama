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
  //obstacle move and reset after they leave the screen (2 objects moving)
  Random _randomNumber = Random();

  FlappyObstacle(this.game, this._holePosition, this._holeSize, this._number);

  void render(Canvas c) {
    // render each part of the snake
    for (SpriteComponent obstacle in _sprites) {
      c.save();
      obstacle.render(c);
      c.restore();
    }
  }

  void createObstacleParts() {
    _sprites = [];
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
      }
    }
  }

  void update(double t) {
    if (_sprites.isNotEmpty) {
      if (_sprites[0].x <= -this.game.tileSize * 2) {
        this._holePosition = _randomNumber.nextInt(this.game.tilesX);
        this._holeSize = _randomNumber.nextInt(3) + 2;
        this._number = 0;
        createObstacleParts();
      }

      _sprites?.forEach(
              (element) {
                element.x += _velocity * t;
              });
    }
  }

  void resize(Size size) {
    if (this.game.tileSize > 0) {
      createObstacleParts();
    }
  }
}