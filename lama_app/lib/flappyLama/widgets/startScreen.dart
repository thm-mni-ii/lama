import 'package:flutter/material.dart';
import 'package:lama_app/util/LamaColors.dart';

/// This class is a [StatelessWidget] for displaying the start screen of Flappy lama
class StartScreen extends StatelessWidget {
  final int userHighScore;
  final int alltimeHighScore;
  // This function will be called when start button is pressed.
  final Function onStartPressed;

  const StartScreen({
    this.userHighScore,
    this.alltimeHighScore,
    @required this.onStartPressed}
  );

  @override
  Widget build(BuildContext context){
    return Center(
      child: Container (
        height: MediaQuery.of(context).size.height * 0.85,
        width: MediaQuery.of(context).size.width * 0.95,
        child: Card(
          margin: EdgeInsets.symmetric(
              horizontal: 25.0,
              vertical: 10.0
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(35.0)
          ),
          color: Color(0xFFd3d3d3).withOpacity(0.4),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 10.0,
              vertical: 15.0
            ),
            child: SafeArea(
              child:  Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Flexible(
                    child:Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(
                            'assets/images/png/plane-1598084_1280.png'//platzhalter
                          ),
                        )
                      ),
                    ),
                  ),
                  Text(
                    "Flappy Lama",
                    style: TextStyle(
                      color: LamaColors.mainPink,
                      fontWeight: FontWeight.bold,
                      fontSize: 35.0,
                    ),
                  ),
                  Text(
                    "\nDrücke auf den Bildschirm, um Anna ein wenig Auftrieb zu verleihen. Versuche dabei sowohl den Bildschirmrand, als auch die Kakteen zu meiden.\n",
                    style: TextStyle(
                      fontSize: 20.0,
                      color: LamaColors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Flexible(
                    child: Text("Mein Rekord: ${userHighScore.toString()}\n",
                      style: TextStyle(
                        fontSize: 25.0,
                        fontWeight: FontWeight.bold,
                        color: LamaColors.mainPink,
                      )
                    ),
                  ),
                  Flexible(
                    child: Text("Rekord: ${alltimeHighScore.toString()}\n",
                        style: TextStyle(
                          fontSize: 25.0,
                          fontWeight: FontWeight.bold,
                          color: LamaColors.mainPink,
                        )
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: LamaColors.redAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0)
                      ),
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