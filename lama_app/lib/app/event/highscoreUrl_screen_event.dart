import 'package:lama_app/app/model/user_model.dart';

abstract class HighscoreUrlScreenEvent {}

class HighscoreUrlPullEvent extends HighscoreUrlScreenEvent {}

class HighscoreUrlChangeEvent extends HighscoreUrlScreenEvent {
  String url;
  HighscoreUrlChangeEvent(this.url);
}
