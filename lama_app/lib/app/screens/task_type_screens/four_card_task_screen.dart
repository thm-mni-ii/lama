import 'package:flutter/material.dart';
import 'package:lama_app/app/task-system/task.dart';

class FourCardTaskScreen extends StatelessWidget {
  final String subject;
  final Task4Cards task;
  FourCardTaskScreen(this.subject, this.task);

  @override
  Widget build(BuildContext context) {
    List<String> answers = [];
    answers.addAll(task.wrongAnswers);
    answers.add(task.rightAnswer);
    print(answers.length);
    answers.shuffle();
    LinearGradient lg;
    switch (subject) {
      case "Mathe":
        lg = LinearGradient(colors: [Colors.lightBlue, Colors.blue]);
        break;
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
                  bottomRight: Radius.circular(25))),
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
                ),
              ),
              Text(
                subject,
                style: TextStyle(fontSize: 30, color: Colors.white),
              ),
            ],
          )),
        ),
        SizedBox(height: 25),
        Container(
          width: MediaQuery.of(context).size.width - 75,
          height: 200,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(50)),
              gradient: LinearGradient(
                  colors: [Colors.orangeAccent, Colors.deepOrange]),
              boxShadow: [
                BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3))
              ]),
          child: Align(
            child: Text(
              task.question,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 30,
                color: Colors.white,
              ),
            ),
          ),
        ),
        SizedBox(height: 30),
        Container(
          color: Colors.green,
          height: 75,
          child: Center(child: Text(task.lama_text)),
        ),
        SizedBox(height: 25),
        Expanded(
            child: Padding(
          padding: const EdgeInsets.only(
            left: 5,
            right: 5,
          ),
          child: GridView.count(
            crossAxisCount: 2,
            childAspectRatio: 1.6 / 1,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            children: [
              Container(
                height: 50,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    color: Colors.lightGreen,
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 1,
                          blurRadius: 7,
                          offset: Offset(0, 3))
                    ]),
                child: Center(
                  child: Text(
                    answers[0],
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontSize: 25),
                  ),
                ),
              ),
              Container(
                height: 50,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    color: Colors.lightBlue,
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 1,
                          blurRadius: 7,
                          offset: Offset(0, 3))
                    ]),
                child: Center(
                  child: Text(
                    answers[1],
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontSize: 25),
                  ),
                ),
              ),
              Container(
                height: 50,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    color: Colors.lightBlue,
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 1,
                          blurRadius: 7,
                          offset: Offset(0, 3))
                    ]),
                child: Center(
                  child: Text(
                    answers[2],
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontSize: 25),
                  ),
                ),
              ),
              Container(
                height: 50,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    color: Colors.lightGreen,
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 1,
                          blurRadius: 7,
                          offset: Offset(0, 3))
                    ]),
                child: Padding(
                  padding: EdgeInsets.all(5),
                  child: Center(
                    child: Text(
                      answers[3],
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white, fontSize: 25),
                    ),
                  ),
                ),
              )
            ],
          ),
        ))
      ],
    ));
  }
}
