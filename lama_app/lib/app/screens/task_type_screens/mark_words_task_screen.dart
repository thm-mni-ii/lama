import 'package:bubble/bubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lama_app/app/bloc/taskBloc/markwords_bloc.dart';
import 'package:lama_app/app/bloc/task_bloc.dart';
import 'package:lama_app/app/event/task_events.dart';
import 'package:lama_app/app/task-system/task.dart';
import 'package:lama_app/util/LamaColors.dart';
import 'package:lama_app/util/LamaTextTheme.dart';

/// [StatelessWidget] that contains the screen for the MarkWords TaskType.
/// seperace sentence at space to a list of words.
///
/// Author: F.Leonhardt
class MarkWordsScreen extends StatelessWidget {
  final BoxConstraints constraints;
  final TaskMarkWords task;
  final List<String> sentence = [];
  List<String> providedanswerWords = [];
  MarkWordsBloc neededBloc;

  MarkWordsScreen(this.task, this.constraints) {
    sentence.addAll(task.sentence.split(" "));
    print(sentence.length);
  }

  /// Override build method [StatelessWidget]
  ///
  /// {@param} [BuildContext] as context
  ///
  /// {@return} a [Widget] that contains the sentence in separate containers
  @override
  Widget build(BuildContext context) {
    neededBloc = MarkWordsBloc();
    return BlocProvider(
        create: (context) => neededBloc,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: EdgeInsets.only(left: 15, right: 15),
              height: (constraints.maxHeight / 100) * 30,
              width: (constraints.maxWidth),
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
                            style: LamaTextTheme.getStyle(
                                fontSize: 15, color: LamaColors.black),
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
            Container(
                width: constraints.maxWidth,
                height: (constraints.maxHeight / 100) * 50,
                child: _sentence(sentence)),
            Container(
              width: (constraints.maxWidth / 100) * 50,
              height: (constraints.maxHeight / 100) * 15,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  color: LamaColors.greenAccent,
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: Offset(0, 3))
                  ]),
              child: InkWell(
                onTap: () => BlocProvider.of<TaskBloc>(context).add(
                    AnswerTaskEvent.initMarkWords(neededBloc.givenAnswers)),
                child: Center(
                  child: Text(
                    "Fertig!",
                    textAlign: TextAlign.center,
                    style: LamaTextTheme.getStyle(),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: (constraints.maxHeight / 100) * 5,
            )
          ],
        ));
  }

  /// Returns sentence as [ListView] where each word is stored as [InkWell].
  Widget _sentence(List<String> sentence) {
    return BlocBuilder<MarkWordsBloc, MarkWordState>(
        builder: (context, MarkWordState state) {
      return ListView.builder(
        itemCount: sentence.length,
        itemBuilder: (BuildContext context, index) {
          Color boxcolor = LamaColors.blueAccent;
          if (state.list.contains(sentence[index])) {
            boxcolor = LamaColors.greenAccent;
          }

          return Padding(
            padding: EdgeInsets.all(5),
            child: InkWell(
              onTap: () => BlocProvider.of<MarkWordsBloc>(context)
                  .add(AddAnswerToListEvent(sentence[index])),
              child: Container(
                width: constraints.maxWidth,
                height: (constraints.maxHeight / 100) * 5,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  color: boxcolor,
                ),
                child: Center(
                  child: Text(
                    sentence[index],
                    textAlign: TextAlign.center,
                    style: LamaTextTheme.getStyle(fontSize: 15),
                  ),
                ),
              ),
            ),
          );
        },
      );
    });
  }
}
