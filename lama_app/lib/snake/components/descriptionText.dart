import 'package:flutter/cupertino.dart';
import 'package:flutter/painting.dart';
import 'package:lama_app/snake/snakeGame.dart';

class DescriptionText {
  final SnakeGame game;
  TextPainter _painter;
  Offset _position;
  Paint _textPaint;

  DescriptionText(this.game, double offsetY) {
    TextStyle _textStyle;

    // Style of the text
    _textStyle = TextStyle(
      color: Color(0xbb19721d),
      fontSize: this.game.screenSize.height * 0.05,
      shadows: <Shadow>[
        Shadow(
          blurRadius: 10,
          color: Color(0xff000000),
          offset: Offset(2, 2),
        ),
      ],
    );

    // Paint for the text
    _painter = TextPainter(
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
      maxLines: 10,
    );

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
      ((this.game.screenSize.height + offsetY) / 2) - _painter.width / 2,
    );

    _textPaint = Paint();
    _textPaint.color = Color(0xff6dff4a);
  }

  void render(Canvas c) {
    // draw text
    _painter.paint(c, _position);
  }

  void update(double t) {}
}