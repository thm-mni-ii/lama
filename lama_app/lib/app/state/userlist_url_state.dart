import 'package:lama_app/app/model/user_model.dart';

/// States used by [UserlistUrlScreen] and [UserlistUrlBloc]
///
/// Author: L.Kammerer
/// latest Changes: 14.06.2021
abstract class UserlistUrlState {}

///default state
class UserlistUrlDefault extends UserlistUrlState {}

///used to transmit an error in Url parsing process
///with specific error message
///
///{@param}[String] error as specfic error message
class UserlistUrlParsingFailed extends UserlistUrlState {
  String error;
  UserlistUrlParsingFailed(
      {this.error = 'Ein unbestimmter Fehler ist aufgetreten!'});
}

///specific waiting state while an Url is validated
class UserlistUrlTesting extends UserlistUrlState {}

///used to transmit an success after url parsing
///contains [List] with all parsed [User]
///
///{@param}[List<User>] userList contains all parsed [User]
class UserlistUrlParsingSuccessfull extends UserlistUrlState {
  List<User> userList;
  UserlistUrlParsingSuccessfull(this.userList);
}

///used to transmit an successfull insert of all parsed [User]
///and finishes the parsing and inserting [User] list process
class UserlistUrlInsertSuccess extends UserlistUrlState {}
