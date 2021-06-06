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
        fontSize: this.game.screenSize.height * 0.05,
        color: Color(0xbb19721d),
      ),
      children: <TextSpan>[
        TextSpan(
          text: 'Versuche soviele Äpfel wie\nmöglich zu essen ohne\ndich selber zu beißen oder\ndie Wand zu berühren!',
          style: TextStyle(
              fontSize: this.game.screenSize.height * 0.03,
              fontFamily: 'Serif'
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