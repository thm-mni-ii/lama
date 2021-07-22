/// Events used by [UserlistUrlScreen] and [UserlistUrlBloc]
///
/// Author: L.Kammerer
/// latest Changes: 14.07.2021
abstract class UserlistUrlEvent {}

///used to change url in Bloc
///
///{@param}[String] url that should be set
class UserlistUrlChangeUrl extends UserlistUrlEvent {
  String url;
  UserlistUrlChangeUrl(this.url);
}

///used to trigger the parsing of all [User] from the url
class UserlistParseUrl extends UserlistUrlEvent {}

///used to abort the parse userlist process
class UserlistAbort extends UserlistUrlEvent {}

///used to trigger the insert of all parsed [User]
class UserlistInsertList extends UserlistUrlEvent {}
