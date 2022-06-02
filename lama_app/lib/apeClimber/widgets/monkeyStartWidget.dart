import 'package:flutter/material.dart';
import 'package:lama_app/util/LamaColors.dart';

/// This class is a [StatelessWidget] for displaying the start screen of Flappy lama
class MonkeyStartWidget extends StatelessWidget {
  final int userHighScore;
  final int alltimeHighScore;
  // This function will be called when start button is pressed.
  final Function onStartPressed;

  const MonkeyStartWidget({
    this.userHighScore,
    this.alltimeHighScore,
    @required this.onStartPressed});

  @override
  Widget build(BuildContext context){
    return Center(
      child: Container (
          height: MediaQuery.of(context).size.height * 0.75,
          width: MediaQuery.of(context).size.width * 0.9,
          child: Card(
            margin: EdgeInsets.symmetric(
                horizontal: 25.0,
                vertical: 10.0
            ),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(35.0)
            ),
            color: LamaColors.greenPrimary.withOpacity(0.8),
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: 10.0,
                  vertical: 15.0
              ),
              child: SafeArea(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Text(
                      "Affenleiter",
                      style: TextStyle(
                        shadows: [
                          Shadow(
                              color: LamaColors.black.withOpacity(0.3),
                              offset: Offset(2,2)
                          ),
                        ],
                        color: LamaColors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 35.0,
                      ),
                    ),
                    Text(
                      "Klettere mit dem Affen in 2 Minuten so hoch du kannst ohne einen Ast zu berühren. Berühre dafür entweder die linke oder rechte Bildschirmhälfte. Berührst du einen Ast ist das Spiel beendet.",
                      style: TextStyle(
                        fontSize: 20.0,
                        fontStyle: FontStyle.italic,
                        color: LamaColors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Flexible(
                      child: Text("Mein Rekord: ${userHighScore.toString()}",
                          style: TextStyle(
                            shadows: [
                              Shadow(
                                  color: LamaColors.black.withOpacity(0.3),
                                  offset: Offset(2,2)
                              ),
                            ],
                            fontSize: 25.0,
                            fontWeight: FontWeight.bold,
                            color: LamaColors.white,
                          )
                      ),
                    ),
                    Flexible(
                      child: Text("Rekord: ${alltimeHighScore.toString()}",
                          style: TextStyle(
                            shadows: [
                              Shadow(
                                  color: LamaColors.black.withOpacity(0.3),
                                  offset: Offset(2,2)
                              ),
                            ],
                            fontSize: 25.0,
                            fontWeight: FontWeight.bold,
                            color: LamaColors.white,
                          )
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: LamaColors.bluePrimary,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0)
                        ),
                        shadowColor: LamaColors.black.withOpacity(0.8),
                        padding: EdgeInsets.symmetric(
                            horizontal: 35,
                            vertical: 8
                        ),
                      ),
                      child: Text(
                        "Start",
                        style: TextStyle(fontSize: 35.0),
                      ),
                      onPressed: () {
                        onStartPressed.call();
                      },
                    ),
                  ],
                ),
              ),
            ),
          )
      ),
    );
  }
}