
abstract class TTSState {}

class EmptyTTSState extends TTSState {}

class EmptyTTSStateForMatchCategory extends TTSState {}

class AnswerOnInitState extends TTSState {

}

class ReadTaskState extends TTSState {
  String questionForTask = "";
  String questionLanguage = "";

  ReadTaskState(this.questionForTask,this.questionLanguage);
}

class VoiceTtsState extends TTSState {
  //
  //
  //
}

class VoiceAnswerTtsState extends TTSState {
  String selectedAnswer ;
  VoiceAnswerTtsState(this.selectedAnswer);
}

class SetDefaultState extends TTSState {}

class IsNotEmptyState extends TTSState {
  String question;
  IsNotEmptyState(this.question);
}
