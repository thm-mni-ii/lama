import "package:flutter/material.dart";
import "package:introduction_screen/introduction_screen.dart";
import 'package:lama_app/app/bloc/check_screen_bloc.dart';
import 'package:lama_app/app/screens/check_Screen.dart';

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: IntroductionScreen(
      pages: [
        PageViewModel(
          title: "Placeholder Pagetitle 1",
          body: "Placeholder bodytext 1",
          footer: Text(
            "Footer Placeholder",
          ),
          image: Image.asset("assets/images/png/sunrise.png"),
        ),
        PageViewModel(
          title: "Placeholder Pagetitle 1",
          body: "Placeholder bodytext 2",
          footer: ElevatedButton(
            child: Text("Placeholder Button"),
            onPressed: () {}, //do something when pressed
          ),
          image: Image.asset("assets/images/png/sun.png"),
        ),
        PageViewModel(
          title: "Placeholder Pagetitle 3",
          body: "Placeholder bodytext 3",
          image: Image.asset("assets/images/png/sunset.png"),
        ),
      ],
      done: Text("Los geht's"),
      skip: Text("skip"),
      showSkipButton: true,
      next: Icon(Icons.navigate_next),
      onDone: () {
        create:
        (BuildContext context) => CheckScreenBloc();
        child:
        CheckScreen(); //uncomment for regular use
      }, //TO-DO what happens when clicking "done"
    ));
  }
}
