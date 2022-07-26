import 'package:lama_app/app/bloc/taskBloc/tts_bloc.dart';

abstract class TTSEvent {}

class QuestionOnInitEvent extends TTSEvent {
  String question;
  String questionLanguage = "";

  QuestionOnInitEvent(this.question,this.questionLanguage);
}

class ClickOnQuestionEvent extends TTSEvent {
  String answerLanguage;
  String texttoPlay;

  ClickOnQuestionEvent.initVoice(this.texttoPlay, this.answerLanguage);
}

class ClickOnAnswerEvent extends TTSEvent {
  String answerLanguage = "";
  String answer;
  ClickOnAnswerEvent(this.answer,this.answerLanguage);
}

class ReadQuestionEvent extends TTSEvent {
  String question = "";
  String questionLanguage = "";
  ReadQuestionEvent(this.question, this.questionLanguage);
}

class SetDefaultEvent extends TTSEvent {}

class IsNotEmptyStateEvent extends TTSEvent {}