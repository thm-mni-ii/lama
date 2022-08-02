
abstract class TTSState {}

class EmptyTTSState extends TTSState {}

class VoiceTtsState extends TTSState {}

class VoiceAnswerTtsState extends TTSState {
  String selectedAnswer ;
  VoiceAnswerTtsState(this.selectedAnswer);
}

class IsNotEmptyState extends TTSState {}
