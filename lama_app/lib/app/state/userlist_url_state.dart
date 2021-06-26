abstract class UserlistUrlState {}

class UserlistUrlParsingFailed extends UserlistUrlState {
  String error;
  UserlistUrlParsingFailed(
      {this.error = 'Ein unbestimmter Fehler ist aufgetreten!'});
}

class UserlistUrlTesting extends UserlistUrlState {}

class UserlistUrlTestingSuccessfull extends UserlistUrlState {}

class UserlistUrlParsingSuccessfull extends UserlistUrlState {
  //TODO save all parsed Users and show them in the View
}
