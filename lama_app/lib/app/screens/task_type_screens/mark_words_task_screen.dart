import 'package:bubble/bubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lama_app/app/bloc/task_bloc.dart';
import 'package:lama_app/app/event/task_events.dart';
import 'package:lama_app/app/task-system/task.dart';

class MarkWordsScreen extends StatelessWidget {
  final String subject;
  final TaskMarkWords task;
  final List<String> sentence = [];

  MarkWordsScreen(this.subject, this.task) {
    sentence.addAll(task.sentence);
    print(sentence.length);
  }

  @override
  Widget build(BuildContext context) {
    LinearGradient lg;
    switch(subject) {
      case "Englisch":
        lg = LinearGradient(colors: [Colors.orange, Colors.deepOrange]);
        break;
      case "Deutsch":
        lg = LinearGradient(colors: [Colors.pink, Colors.redAccent[400]]);
        break;
    }

    return Scaffold(
    body: Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          height: 90,
          decoration: BoxDecoration(
            gradient: lg,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(25),
              bottomRight: Radius.circular(25)
            )
          ),
          child: SafeArea(
            child: Stack(
              alignment: Alignment.center,
              children: [
                Positioned(
                    left: 10,
                    child: IconButton(
                      icon: Icon(
                        Icons.arrow_back,
                        size: 40,
                        color: Colors.white,
                      ),
                      onPressed: () => {Navigator.of(context).pop()},
                    )),
                Text(
                  subject,
                  style: TextStyle(
                      fontSize: 30,
                      color: Colors.white
                  ),
                )
              ],
            ),
          ),
        ),
        SizedBox(height: 100),
        Container(
          padding: EdgeInsets.only(left: 15, right: 15),
          height: 80,
          child: Stack(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  padding: EdgeInsets.only(left: 75),
                  height: 50,
                  width: MediaQuery.of(context).size.width,
                  child: Bubble(
                    nip: BubbleNip.leftCenter,
                    child: Center(
                      child: Text(
                        task.lamaText,
                        style: TextStyle(
                          fontSize: 15, fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: SvgPicture.asset(
                  "assets/images/svg/lama_head.svg",
                  semanticsLabel: "Lama Anna",
                  width: 75,
                ),
              )
            ],
          ),
        ),
        /* Es fehlen noch die Boxen des Satzes */
        Container(
          width: MediaQuery.of(context).size.width -200,
          height: 100,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            color: Colors.green,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 7,
                offset: Offset(0, 3)
              )
            ]
          ),
          child: InkWell(
            onTap: () => BlocProvider(create: ), /* Hier muss hin das der Prozess abgeschlossen ist mit dem Klicken der Fertigbox */
            child: Center(
              child: Text(
                "Fertig!",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 25),
              ),
            ),
          ),
        )
      ],
    )
    );

    throw UnimplementedError();
  }

}