import 'package:bubble/bubble.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lama_app/app/bloc/taskBloc/vocabletesttask_bloc.dart';
import 'package:lama_app/app/task-system/task.dart';
import 'package:lama_app/util/LamaColors.dart';
import 'package:lama_app/util/LamaTextTheme.dart';

class VocableTestTaskScreen extends StatefulWidget {
  final TaskVocableTest task;
  final BoxConstraints constraints;

  VocableTestTaskScreen(this.task, this.constraints);

  @override
  State<StatefulWidget> createState() {
    return VocableTestTaskScreenState(task, constraints);
  }
}

class VocableTestTaskScreenState extends State<VocableTestTaskScreen> {
  final TaskVocableTest task;
  final BoxConstraints constraints;
  final TextEditingController controller = TextEditingController();

  VocableTestTaskBloc bloc;
  VocableTestTaskScreenState(this.task, this.constraints) {
    bloc = VocableTestTaskBloc(task);
  }

  void initState() {
    super.initState();
    bloc.add(VocableTestTaskGetWordEvent());
  }

  Widget build(BuildContext context) {
    return BlocProvider<VocableTestTaskBloc>(
      create: (context) => bloc,
      child: Column(
        children: [
          Container(
            height: (constraints.maxHeight / 100) * 35,
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: (constraints.maxWidth / 100) * 10,
                vertical: (constraints.maxHeight / 100) * 5,
              ),
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(25)),
                    gradient: LinearGradient(colors: [
                      LamaColors.orangePrimary,
                      LamaColors.orangeAccent
                    ])),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Center(
                    child:
                        BlocBuilder<VocableTestTaskBloc, VocableTestTaskState>(
                            builder: (context, state) {
                      if (state is VocableTestTaskTranslationState)
                        return Text(
                          state.wordToTranslate,
                          textAlign: TextAlign.center,
                          style: LamaTextTheme.getStyle(fontSize: 35),
                        );
                      else
                        return Text("Error!");
                    }),
                  ),
                ),
              ),
            ),
          ),
          Container(
              height: (constraints.maxHeight / 100) * 15,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: TextField(
                    autocorrect: false,
                    enableSuggestions: false,
                    cursorColor: Colors.white,
                    controller: controller,
                    decoration: InputDecoration(
                        fillColor: LamaColors.blueAccent,
                        hintStyle: LamaTextTheme.getStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            color: LamaColors.white.withOpacity(0.5)),
                        filled: true,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(50)),
                            borderSide: BorderSide.none),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(50)),
                            borderSide: BorderSide.none),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(50)),
                            borderSide: BorderSide.none),
                        hintText: 'Enter translation...'),
                    maxLines: 1,
                    keyboardType: TextInputType.text,
                    textAlign: TextAlign.center,
                    style: LamaTextTheme.getStyle(
                        fontSize: 22.5, fontWeight: FontWeight.w500),
                  ),
                ),
              )),
          Container(
            height: (constraints.maxHeight / 100) * 15,
            padding: EdgeInsets.only(left: 15, right: 15),
            child: Stack(children: [
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
                            fontSize: 15, fontWeight: FontWeight.bold),
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
              ),
            ]),
          ),
          Container(
            height: (constraints.maxHeight / 100) * 25,
            child: Center(
              child: InkWell(
                child: Container(
                  height: (constraints.maxHeight / 100) * 15,
                  width: (constraints.maxWidth / 100) * 70,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(25),
                    ),
                    color: LamaColors.greenAccent,
                    boxShadow: [
                      BoxShadow(
                          offset: Offset(0, 2),
                          color: LamaColors.black.withOpacity(0.5))
                    ],
                  ),
                  child: Center(
                    child: Text(
                      "Fertig",
                      style: LamaTextTheme.getStyle(
                        fontSize: 30,
                      ),
                    ),
                  ),
                ),
                onTap: () =>
                    {bloc.add(VocableTestTaskAnswerEvent(controller.text))},
              ),
            ),
          ),
          Container(
            height: (constraints.maxHeight / 100) * 10,
            color: Colors.blueAccent,
          )
        ],
      ),
    );
  }
}
