
abstract class FourCardState {}

class EmptyFCardState extends FourCardState {}

class AnswerOnInitState extends FourCardState {

}

class VoiceTtsState extends FourCardState {
  //
  //
  //
}

class VoiceAnswerTtsState extends FourCardState {
  String selectedAnswer ;
  VoiceAnswerTtsState(this.selectedAnswer);
}
