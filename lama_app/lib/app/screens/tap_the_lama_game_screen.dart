import 'package:flame/game.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lama_app/app/repository/user_repository.dart';

import '../../tapTheLama/tapTheLamaGame.dart';

class TapTheLamaScreen extends StatelessWidget{

  final UserRepository? userRepository;

  const TapTheLamaScreen(this.userRepository);

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