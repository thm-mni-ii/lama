import 'package:lama_app/app/bloc/taskBloc/tts_bloc.dart';

abstract class TTSEvent {}

class QuestionOnInitEvent extends TTSEvent {
  String answer;
  String questionLanguage = "";

  QuestionOnInitEvent(this.answer,this.questionLanguage);
}

class ClickOnWordQuestion extends TTSEvent {
  String answerLanguage;
  String texttoPlay;

  ClickOnWordQuestion.initVoice(this.texttoPlay, this.answerLanguage);
}

class ClickOnAnswer extends TTSEvent {
  String answerLanguage = "";
  int index;
  String answer;
  ClickOnAnswer(this.answer,this.index,this.answerLanguage);
}

class ReadQuestion extends TTSEvent {
  String question = "";
  String questionLanguage = "";
  ReadQuestion(this.question, this.questionLanguage);
}

class SetDefaultEvent extends TTSEvent {}

class IsNotEmptyStateEvent extends TTSEvent {}