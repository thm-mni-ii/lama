import 'package:lama_app/app/bloc/taskBloc/buchstabieren_bloc.dart';

abstract class BuchstabierenEvent {}

class AnswerOnInitEvent extends BuchstabierenEvent {
  String answer;
  String questionLanguage = "";

  AnswerOnInitEvent(this.answer,this.questionLanguage);
}

class ClickOnWordQuestion extends BuchstabierenEvent {
  String answerLanguage;
  String texttoPlay;
  //
  //
  //
  ClickOnWordQuestion.initVoice(this.texttoPlay, this.answerLanguage);

//ClickOnWordEvent(this.selectedAnswer);
}
