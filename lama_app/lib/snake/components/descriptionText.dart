import 'package:flutter/cupertino.dart';
import 'package:flutter/painting.dart';
import 'package:lama_app/snake/snakeGame.dart';

class DescriptionText {
  final SnakeGame game;
  TextPainter _painter = TextPainter(
    textAlign: TextAlign.center,
    textDirection: TextDirection.ltr,
    maxLines: 10,
  );
  Offset _position;
  double _offsetY;

  DescriptionText(this.game, this._offsetY) {
    resize();
  }

  void resize() {
    _painter.text = TextSpan(
      text: "Snake\n",
      style: TextStyle(
        fontSize: this.game.screenSize.height * 0.03,
        color: Color(0xbb19721d),
      ),
      children: <TextSpan>[
        TextSpan(
          text: 'Versuche soviele Äpfel wiemöglich\nzu essen ohnedich selber zu beißen\noder die Wand zu berühren!',
          style: TextStyle(
              fontSize: this.game.screenSize.height * 0.03,
              fontFamily: 'Serif'
          ),
        ),
        TextSpan(
          text: '\nMein Highscore: ${game.userHighScore}\nHighscore: ${game.allTimeHighScore}',
          style: TextStyle(
              fontSize: this.game.screenSize.height * 0.03,
              fontFamily: 'Serif',
              fontWeight: FontWeight.bold
          ),
        ),
      ],
    );

    _painter.layout();

    // set new offset depending on the text width
    _position = Offset(
      (this.game.screenSize.width / 2) - _painter.width / 2,
      ((this.game.screenSize.height + this._offsetY) / 2) - _painter.width / 2,
    );
  }

  void render(Canvas c) {
    // draw text
    _painter.paint(c, _position);
  }

  void update(double t) {}
}