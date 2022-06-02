import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:http/http.dart' as http;
import 'package:lama_app/app/event/userlist_url_event.dart';
import 'package:lama_app/app/model/user_model.dart';
import 'package:lama_app/app/state/userlist_url_state.dart';
import 'package:lama_app/db/database_provider.dart';
import 'package:lama_app/util/input_validation.dart';

///[Bloc] for the [UserlistUrlScreen]
///
/// * see also
///    [UserlistUrlScreen]
///    [UserlistUrlEvent]
///    [UserlistUrlState]
///    [Bloc]
///
/// Author: L.Kammerer
/// latest Changes: 15.06.2021
class UserlistUrlBloc extends Bloc<UserlistUrlEvent, UserlistUrlState> {
  UserlistUrlBloc({UserlistUrlState initialState}) : super(initialState);

  ///url that is used to parse the userlist
  ///incoming events are used to change the value
  String _url;
  //list of [User] parsed from the [_url]
  List<User> _userList = [];

  @override
  Stream<UserlistUrlState> mapEventToState(UserlistUrlEvent event) async* {
    if (event is UserlistUrlChangeUrl) _url = event.url;
    if (event is UserlistParseUrl) {
      yield UserlistUrlTesting();
      yield await _parsUrl();
    }
    if (event is UserlistAbort) yield UserlistUrlDefault();
    if (event is UserlistInsertList) {
      _insertList();
      yield UserlistUrlInsertSuccess();
    }
  }

  ///(private)
  ///parsing all users using [_parsUserList] from [_url] and
  ///return them packed in [UserlistUrlParsingSuccessfull]
  ///or return with an specific error message via [UserlistUrlParsingFailed] if an error occurred
  ///validation of [_url] is handelt by [InputValidation.inputUrlWithJsonValidation]
  ///
  ///{@return}
  ///[UserlistUrlParsingFailed] on error
  ///[UserlistUrlParsingSuccessfull] via [_parsUserList] if the parsing was successfull
  Future<UserlistUrlState> _parsUrl() async {
    //Validat URL
    String error = await InputValidation.inputUrlWithJsonValidation(_url);
    if (error != null) return UserlistUrlParsingFailed(error: error);

    _userList.clear();
    try {
      final respons = await http.get(Uri.parse(_url));
      return _parsUserList(jsonDecode(respons.body));
    } on SocketException {
      return UserlistUrlParsingFailed(
        error: 'Kritischer Fehler beim erreichen der URL!',
      );
    }
  }

  ///(private)
  ///used to parse ever [User] providet by json
  ///
  ///the json should provide an key 'users' which is a list
  ///with at least one [User] else an [UserlistUrlParsingFailed] with an suitable error message returns
  ///also if an error from [User.isValidUser] is returned an [UserlistUrlParsingFailed] is returned by this function
  ///if every [User] is successfully parsed an [List] with
  ///all parsed [User] is packed in [UserlistUrlParsingSuccessfull] and returned
  ///
  ///{@param} Map<String, dynamic> as json
  ///
  ///{@return}
  ///[UserlistUrlParsingFailed] with suitable error message if any error occurred
  ///[UserlistUrlParsingSuccessfull] with an [List] of all parsed [User] if no error occurred
  UserlistUrlState _parsUserList(Map<String, dynamic> json) {
    //Check if UserList "users" exist in the json file
    if (!(json.containsKey('users') && json['users'] is List))
      return UserlistUrlParsingFailed(
        error:
            'Feld ("users": [...]) fehlt oder ist fehlerhaft! \n Hinweis: ("users": [NUTZER])',
      );
    var userList = json['users'] as List;
    if (userList == null || userList.length == 0)
      return UserlistUrlParsingFailed(
        error:
            'Feld ("users": [...]) darf nicht leer sein! \n Hinweis: ("users": [NUTZER])',
      );

    for (int i = 0; i < userList.length; i++) {
      //Check if user is valid
      String error = User.isValidUser(userList[i]);
      if (error != null)
        return UserlistUrlParsingFailed(error: error + '\n Nutzer: (${i + 1})');
      //Add valid User to _userList
      _userList.add(User.fromJson(userList[i]));
    }
    //return valid _userList to UI
    return UserlistUrlParsingSuccessfull(_userList);
  }

  ///(private)
  ///stores every [User] given by [_userList] in to the database
  void _insertList() {
    _userList.forEach((user) async {
      await DatabaseProvider.db.insertUser(user);
    });
  }
}
