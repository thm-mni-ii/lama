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