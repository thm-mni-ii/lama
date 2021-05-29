import 'package:flutter/material.dart';
import 'package:lama_app/util/LamaColors.dart';

/// This class is a [StatelessWidget] for displaying the game over Mode Hud of Flappy lama

class GameOverMode extends StatelessWidget {
  // Score to display on game over menu.
  final int score;

  // This function will be called when restart button is pressed.
  final Function onRestartPressed;

  const GameOverMode({
    Key key,
    @required this.score,
    @required this.onRestartPressed,
  })  : assert(score != null),
        assert(onRestartPressed != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        color: LamaColors.orangePrimary.withOpacity(0.5),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 100.0,
            vertical: 50.0,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Game Over',
                style: TextStyle(fontSize: 30.0, color: LamaColors.white),
              ),
              Text(
                'Score: $score ',
                style: TextStyle(fontSize: 20.0, color: LamaColors.white),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 2),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: LamaColors.white,
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 15)),
                      child: Text(
                        'Restart',
                        style: TextStyle(
                          color: LamaColors.black,
                          fontSize: 15,
                        ),
                      ),
                      onPressed: () {
                        onRestartPressed.call();
                      },
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
