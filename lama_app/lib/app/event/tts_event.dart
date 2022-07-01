import 'package:lama_app/app/bloc/taskBloc/tts_bloc.dart';

abstract class TTSEvent {}

class AnswerOnInitEvent extends TTSEvent {
  String answer;
  String questionLanguage = "";
  // for test commit

  AnswerOnInitEvent(this.answer,this.questionLanguage);
}

class ClickOnWordQuestion extends TTSEvent {
  String answerLanguage;
  String texttoPlay;
  //
  //
  //
  ClickOnWordQuestion.initVoice(this.texttoPlay, this.answerLanguage);

//ClickOnWordEvent(this.selectedAnswer);
}

class ClickOnAnswer extends TTSEvent {
  String answerLanguage = "";
  int index;
  String answer;
  ClickOnAnswer(this.answer,this.index);
}

class SetDefaultEvent extends TTSEvent {}