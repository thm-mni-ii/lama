import 'package:flutter/material.dart';
import 'package:lama_app/flappyLama/flappyLamaGame.dart';

class FlappyGameScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Flappy Lama"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              child: Container(
                color: Colors.green,
                child: FlappyLamaGame(context).widget,
              )
            )
          ]
        )
      )
    );
  }
}
