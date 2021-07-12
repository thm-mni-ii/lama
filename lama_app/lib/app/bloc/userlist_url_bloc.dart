import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:http/http.dart' as http;
import 'package:lama_app/app/event/userlist_url_event.dart';
import 'package:lama_app/app/model/user_model.dart';
import 'package:lama_app/app/state/userlist_url_state.dart';
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
      String error = await InputValidation.inputUrlWithJsonValidation(_url);
      if (error != null)
        yield UserlistUrlParsingFailed(error: error);
      else
        yield await _parsUrl();
    }
  }

  Future<UserlistUrlState> _parsUrl() async {
    final respons = await http.get(Uri.parse(_url));
    List<User> _userList = await _loadtUsersFromUrl(jsonDecode(respons.body));
    return UserlistUrlParsingSuccessfull(_userList);
  }

  Future<List<User>> _loadtUsersFromUrl(Map<String, dynamic> json) async {
    var userList = json['users'] as List;
    return userList.map((e) => User.fromJson(e)).toList();
  }
}
