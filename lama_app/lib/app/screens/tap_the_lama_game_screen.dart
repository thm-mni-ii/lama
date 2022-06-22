import 'package:flame/game.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lama_app/app/repository/user_repository.dart';

import '../../tapTheLama/screens/tapTheLamaMenu.dart';
import '../../tapTheLama/tapTheLamaGame.dart';



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
        title: const Text('Wilkommen bei Tap the Lama'),
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
                            game: TapTheLamaGame(),


                          )

                      )
                  )
                ]
            )
        )
    );
  }

}