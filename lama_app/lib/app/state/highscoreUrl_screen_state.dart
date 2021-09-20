import 'package:lama_app/app/model/user_model.dart';

abstract class HighscoreUrlScreenState {}

class HighscoreUrlPullState extends HighscoreUrlScreenState {
  String currentUrl;
  List<User> userList;
  HighscoreUrlPullState(this.userList, this.currentUrl);
}

class HighscoreUrlReloadState extends HighscoreUrlScreenState {}
