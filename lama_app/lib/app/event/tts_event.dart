

abstract class TtsEvent {
  get text => null;
}

class GetLanguageEvent extends TtsEvent {}
// may needed
class InitTtsEvent extends TtsEvent {}
// need
class PlayTtsEventAnswers extends TtsEvent {
  String text = "";
}
//todo
class PlayTtsEventQuestion extends TtsEvent {
  String text;
  PlayTtsEventQuestion(this.text);
}
class StopTtsEvent extends TtsEvent {}

class PauseTtsEvent extends TtsEvent {}
