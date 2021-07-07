import 'package:lama_app/app/model/user_model.dart';

abstract class UserlistUrlState {}

class UserlistUrlParsingFailed extends UserlistUrlState {
  String error;
  UserlistUrlParsingFailed(
      {this.error = 'Ein unbestimmter Fehler ist aufgetreten!'});
}

class UserlistUrlTesting extends UserlistUrlState {}

class UserlistUrlTestingSuccessfull extends UserlistUrlState {}

class UserlistUrlParsingSuccessfull extends UserlistUrlState {
  List<User> userList;
  UserlistUrlParsingSuccessfull(this.userList);
}
