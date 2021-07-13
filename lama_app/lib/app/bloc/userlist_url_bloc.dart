import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:http/http.dart' as http;
import 'package:lama_app/app/event/userlist_url_event.dart';
import 'package:lama_app/app/model/user_model.dart';
import 'package:lama_app/app/state/userlist_url_state.dart';
import 'package:lama_app/db/database_provider.dart';
import 'package:lama_app/util/input_validation.dart';

class UserlistUrlBloc extends Bloc<UserlistUrlEvent, UserlistUrlState> {
  UserlistUrlBloc({UserlistUrlState initialState}) : super(initialState);

  String _url;
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
      yield UserlistUrlDefault();
    }
  }

  Future<UserlistUrlState> _parsUrl() async {
    //Validat URL
    String error = await InputValidation.inputUrlWithJsonValidation(_url);
    if (error != null) return UserlistUrlParsingFailed(error: error);

    _userList.clear();
    final respons = await http.get(Uri.parse(_url));
    return _parsUserList(jsonDecode(respons.body));
  }

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
        return UserlistUrlParsingFailed(error: error + '\n Nutzer: ($i)');
      //Add valid User to _userList
      _userList.add(User.fromJson(userList[i]));
    }
    //return valid _userList to UI
    return UserlistUrlParsingSuccessfull(_userList);
  }

  void _insertList() {
    _userList.forEach((user) async {
      await DatabaseProvider.db.insertUser(user);
    });
  }
}
