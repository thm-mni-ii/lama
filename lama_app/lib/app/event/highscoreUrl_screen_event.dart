abstract class HighscoreUrlScreenEvent {}

class HighscoreUrlPullEvent extends HighscoreUrlScreenEvent {}

class HighscoreUrlChangeEvent extends HighscoreUrlScreenEvent {
  String url;
  HighscoreUrlChangeEvent(this.url);
}
