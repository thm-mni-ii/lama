import 'package:flutter/material.dart';
import 'package:lama_app/util/LamaColors.dart';


class StartScreen extends StatelessWidget {
  final Function onStartPressed;
  final int highScore;
  final int alltimeHighScore;

  const StartScreen({
    this.highScore,
    this.alltimeHighScore,
    @required this.onStartPressed}
  );

  @override
  Widget build(BuildContext context){
    return Center(
      child: Container (
        height: MediaQuery.of(context).size.height*0.85,
        child: Card(
          margin: EdgeInsets.symmetric(
              horizontal: 25.0,
              vertical: 10.0
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(35.0)
          ),
          color: LamaColors.bluePrimary.withOpacity(0.8),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal:  40.0,
              vertical: 55.0
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center, 
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child:Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(
                          'assets/images/png/lama_head.png'//platzhalter
                        ),
                      )
                    ),
                  ),
                ),
                Text(
                  "Flappy Lama",
                  style: TextStyle(
                    color: LamaColors.redPrimary,
                    fontWeight: FontWeight.bold,
                    fontSize: 40.0,
                  ),
                ),
                Text(
                  "\nDrücke auf den Bildschirm, um Anna ein wenig Auftrieb zu verleihen. Versuche dabei sowohl den Bildschirmrand, als auch die Kakteen zu meiden.\n",
                  style: TextStyle(
                    fontSize: 20.0,
                    color: LamaColors.black,
                  )
                ),
                Flexible(
                  child: Text("Mein Rekord: ${highScore.toString()}\n",
                    style: TextStyle(
                      fontSize: 25.0,
                      fontWeight: FontWeight.bold,
                      color: LamaColors.redAccent,
                    )
                  ),
                ),
                Flexible(
                  child: Text("Rekord: ${alltimeHighScore.toString()}\n",
                      style: TextStyle(
                        fontSize: 25.0,
                        fontWeight: FontWeight.bold,
                        color: LamaColors.redAccent,
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
        )
      ),
    );
  }
}