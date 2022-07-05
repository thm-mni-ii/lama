import 'package:flame/game.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lama_app/app/repository/user_repository.dart';

import '../../tapTheLama/screens/tapTheLamaMenu.dart';
import '../../tapTheLama/tapTheLamaGame.dart';

///class that is a screen to open the tap the lama game and initialise a Navigator for the tap the lama gama so that the player can return in the game
class TapTheLamaScreen extends StatelessWidget {
  final UserRepository? userRepository;
  final int? userHighScore;
  final int? allTimeHighScore;

//Main Menu
  const TapTheLamaScreen(
      this.userRepository, this.userHighScore, this.allTimeHighScore);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: const Text('Tap the Lama'),
      ),
      backgroundColor:Colors.white,
      body: Menu(context, userHighScore, allTimeHighScore, userRepository),
    );
  }
}


class TapTheLamaGameScreen extends StatelessWidget{

  final UserRepository? userRepository;
  final int? userHighScore;
  final int? allTimeHighScore;

  const TapTheLamaGameScreen(this.userRepository, this.userHighScore, this.allTimeHighScore);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Tap the Lama"),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              //two pop's so user can reach the game_list_screen
              Navigator.pop(context);
              Navigator.pop(context);
            },
          ),
        ),
        body: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Expanded(
                      child: Container(
                          color: Colors.white,
                          child: GameWidget(
                            game: TapTheLamaGame(context, userRepository, userHighScore, allTimeHighScore),
                          )
                      )
                  )
                ]
            )
        )
    );
  }

}