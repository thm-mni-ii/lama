abstract class UserlistUrlEvent {}

class UserlistUrlChangeUrl extends UserlistUrlEvent {
  String url;
  UserlistUrlChangeUrl(this.url);
}

class UserlistParseUrl extends UserlistUrlEvent {}
