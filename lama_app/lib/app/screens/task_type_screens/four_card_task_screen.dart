import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lama_app/app/bloc/task_bloc.dart';
import 'package:lama_app/app/event/task_events.dart';
import 'package:lama_app/app/task-system/task.dart';

class FourCardTaskScreen extends StatelessWidget {
  final String subject;
  final Task4Cards task;
  final List<String> answers = [];
  FourCardTaskScreen(this.subject, this.task) {
    answers.addAll(task.wrongAnswers);
    answers.add(task.rightAnswer);
    print(answers.length);
    answers.shuffle();
  }

  @override
  Widget build(BuildContext context) {
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
            child: Center(child: Text(task.lamaText)),
          ),
          SizedBox(height: 25),
          Expanded(
              child: Padding(
                  padding: const EdgeInsets.only(
                    left: 5,
                    right: 5,
                  ),
                  child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 1.6 / 1,
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10,
                      ),
                      itemCount: 4,
                      itemBuilder: (context, index) =>
                          _buildCards(context, index))))
        ],
      ),
    );
  }

  Widget _buildCards(context, index) {
    Color color = index % 3 == 0 ? Colors.lightGreen : Colors.lightBlue;
    return Container(
      height: 50,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          color: color,
          boxShadow: [
            BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 1,
                blurRadius: 7,
                offset: Offset(0, 3))
          ]),
      child: InkWell(
        onTap: () => BlocProvider.of<TaskBloc>(context)
            .add(AnswerTaskEvent(answers[index])),
        child: Padding(
          padding: EdgeInsets.all(5),
          child: Center(
            child: Text(
              answers[index],
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 25),
            ),
          ),
        ),
      ),
    );
  }
}
