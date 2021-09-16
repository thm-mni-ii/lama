import 'package:flutter/cupertino.dart';

/// Events used by [SaftyQuestionScreen] and [SaftyQuestionBloc]
///
/// Author: L.Kammerer
/// latest Changes: 10.09.2021

abstract class SaftyQuestionEvent {}

//used to pull the safty question and answer
class SaftyQuestionPull extends SaftyQuestionEvent {}

class SaftyQuestionPush extends SaftyQuestionEvent {
  BuildContext context;
  String answer;
  SaftyQuestionPush(this.context, this.answer);
}
