import 'package:flutter/cupertino.dart';

abstract class SaftyQuestionEvent {}

//used to pull the safty question and answer
class SaftyQuestionPull extends SaftyQuestionEvent {}

class SaftyQuestionPush extends SaftyQuestionEvent {
  BuildContext context;
  String answer;
  SaftyQuestionPush(this.context, this.answer);
}
