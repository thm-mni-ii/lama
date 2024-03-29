import 'package:flutter/material.dart';

import 'package:lama_app/app/repository/user_repository.dart';
import '../../../app/screens/game_list_screen.dart';

import 'package:lama_app/app/screens/tap_the_lama_game_screen.dart';

import 'package:lama_app/util/LamaColors.dart';

import '../app/screens/flappy_game_screen.dart';
import '../tapTheLama/buttons/menu_button.dart';

///a menu that pops up before playing the tap the lama game
///also this class has the purpose to pass specific user high score and all time high score to the game
class Menu extends StatefulWidget {
  var context;

  int? userHighScore;
  int? allTimeHighScore;
  UserRepository? userRepository;

  @override
  Menu(this.context, this.userHighScore, this.allTimeHighScore,
      this.userRepository);
  State<StatefulWidget> createState() =>
      _MenuState(userHighScore, allTimeHighScore, userRepository);
}

class _MenuState extends State<Menu> {
  UserRepository? userRepo;

  /// id of the game
  final gameId = 2;

  /// the personal highScore
  int? userHighScore;

  /// the all time highScore in this game
  int? allTimeHighScore;

  void initState() {
    super.initState();
    void loadHighScores() async {
      userHighScore = await userRepo?.getMyHighscore(2);
      print(userHighScore.toString());
      allTimeHighScore = await userRepo?.getHighscore(2);
    }
  }

  _MenuState(this.userHighScore, this.allTimeHighScore, this.userRepo);

  void onPlayClicked() {
    if (userRepo!.getLamaCoins()! < GameListScreen.games[gameId - 1].cost) {
      Navigator.pop(context, "NotEnoughCoins");
      return;
    }
    userRepo!.removeLamaCoins(GameListScreen.games[gameId - 1].cost);
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              FlappyGameScreen(userRepo, userHighScore, allTimeHighScore)),
    );
  }

  @override
  Widget build(BuildContext context) {
    ///global variables for responsiveness
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    return Container(
      child: Card(
        margin: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.04, vertical: screenHeight * 0.04),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(35.0)),
        color: Colors.white70,
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.02, vertical: screenHeight * 0.02),
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Container(
                  width: screenWidth * 0.2,
                  height: screenWidth * 0.2,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage(
                            'assets/images/png/plane-1598084_1280.png'),
                        fit: BoxFit.fill),
                  ),
                ),
                Text(
                  "Flappy Lama",
                  style: TextStyle(
                    fontSize: screenWidth * 0.08,
                    fontWeight: FontWeight.bold,
                    color: LamaColors.mainPink,
                  ),
                ),
                Text(
                  "\nDrücke auf den Bildschirm, um Anna ein wenig Auftrieb zu verleihen. Versuche dabei sowohl den Bildschirmrand, als auch die Kakteen zu meiden.\n",
                  style: TextStyle(
                      fontSize: screenWidth * 0.05, color: Color(0xffc283f5)),
                  textAlign: TextAlign.center,
                ),
                MenuButton(onPlayClicked),
                Text(
                  "Dein Rekord: $userHighScore\n",
                  style: TextStyle(
                      fontSize: screenWidth * 0.06,
                      fontWeight: FontWeight.bold,
                      color: LamaColors.blueAccent),
                  textAlign: TextAlign.center,
                ),
                Text(
                  "HighScore: $allTimeHighScore\n",
                  style: TextStyle(
                      fontSize: screenWidth * 0.06,
                      fontWeight: FontWeight.bold,
                      color: LamaColors.blueAccent),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
