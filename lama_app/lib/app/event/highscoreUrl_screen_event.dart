abstract class HighscoreUrlScreenEvent {}

class HighscoreUrlPullEvent extends HighscoreUrlScreenEvent {}

class HighscoreUrlReloadEvent extends HighscoreUrlScreenEvent {}

class HighscoreUrlPushEvent extends HighscoreUrlScreenEvent {}

class HighscoreUrlChangeEvent extends HighscoreUrlScreenEvent {
  String url;
  HighscoreUrlChangeEvent(this.url);
}
