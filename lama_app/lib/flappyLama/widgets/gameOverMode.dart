import 'package:flutter/material.dart';
import 'package:lama_app/util/LamaColors.dart';

/// This class is a [StatelessWidget] for displaying the game over Mode Hud of Flappy lama

class GameOverMode extends StatelessWidget {
  // Score to display on game over menu.
  final int score;
  final int lifes;

  // This function will be called when quit button is pressed.
  final Function onQuitPressed;
  final Function onRetryPressed;

  const GameOverMode({
    Key key,
    @required this.score,
    @required this.lifes,
    @required this.onQuitPressed,
    @required this.onRetryPressed,
  })  : assert(score != null),
        assert(onQuitPressed != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(35.0),
        ),
        color: LamaColors.bluePrimary.withOpacity(0.8),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 40.0,
            vertical: 20.0,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Punkte',
                style: TextStyle(fontSize: 25.0, color: LamaColors.white),
              ),
              Text(
                '$score',
                style: TextStyle(fontSize: 50.0, color: LamaColors.white),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: LamaColors.redAccent,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0)
                      ),
                      padding: EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5
                      ),
                    ),
                    child: Text(
                      'Beenden',
                      style: TextStyle(
                        color: LamaColors.white,
                        fontSize: 20,
                      ),
                    ),
                    onPressed: () {
                      onQuitPressed.call();
                    },
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: LamaColors.redAccent,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0)
                      ),
                      padding: EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5
                      ),
                    ),

                    child: Text(
                      'Neuer Versuch (noch $lifes)',
                      style: TextStyle(
                        color: LamaColors.white,
                        fontSize: 20,
                      ),
                    ),
                    onPressed: () {
                      if (lifes > 0) {
                        onRetryPressed?.call();
                      }
                    },
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
