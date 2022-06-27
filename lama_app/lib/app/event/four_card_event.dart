import 'package:lama_app/app/bloc/taskBloc/four_card_bloc.dart';

abstract class FourCardEvent {}

class AnswerOnInitEvent extends FourCardEvent {
  String answer;
  String answerLanguage = "";

  AnswerOnInitEvent(this.answer);
}

class ClickOnWordQuestion extends FourCardEvent {
  String answerLanguage;
  String texttoPlay;
  //
  //
  //
  ClickOnWordQuestion.initVoice(this.texttoPlay, this.answerLanguage);

//ClickOnWordEvent(this.selectedAnswer);
}

class ClickOnAnswer extends FourCardEvent {
  String answerLanguage = "";
  int index;
  String answer;


  ClickOnAnswer(this.answer,this.index);
}