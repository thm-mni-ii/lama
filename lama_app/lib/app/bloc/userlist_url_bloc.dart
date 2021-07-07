import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lama_app/app/event/userlist_url_event.dart';
import 'package:lama_app/app/model/user_model.dart';
import 'package:lama_app/app/state/userlist_url_state.dart';

class UserlistUrlBloc extends Bloc<UserlistUrlEvent, UserlistUrlState> {
  UserlistUrlBloc({UserlistUrlState initialState}) : super(initialState);

  String _url;
  List<User> _userList = [];

  @override
  Stream<UserlistUrlState> mapEventToState(UserlistUrlEvent event) async* {
    if (event is UserlistUrlChangeUrl) _url = event.url;
    if (event is UserlistParseUrl) {
      yield UserlistUrlTesting();
      String error = await _testingUrl();
      if (error != null)
        yield UserlistUrlParsingFailed(error: error);
      else
        yield await _parsUrl();
    }
  }

  Future<String> _testingUrl() async {
    if (!Uri.tryParse(_url).hasAbsolutePath)
      return 'Die Url ist fehlerhaft! \n einige URLs enden mit ".json" oder einem "/"';
    try {
      final response = await http.get(Uri.parse(_url));
      //Check if URL is reachable
      if (response.statusCode == 200) {
        //Check if URL contains valid json code
        try {
          jsonDecode(response.body);
        } on FormatException {
          return 'Der Inhalt der URL ist kein "json" oder fehlerhaft!';
        }
        //Testing successfull
        return null;
      } else {
        return 'URL ist nicht erreichbar!';
      }
    } on SocketException {
      return 'Da ist etwas gewaltig schiefgelaufen!';
    }
  }

  Future<UserlistUrlState> _parsUrl() async {
    for (int i = 0; i < _url.length; i++) {
      var response = await http
          .get(Uri.parse(_url), headers: {'Content-type': 'application/json'});
      if (response.statusCode == 200) {
        _userList = await _loadtUsersFromUrl(utf8.decode(response.bodyBytes));
      }
    }
    return UserlistUrlParsingSuccessfull(_userList);
  }

  Future<List<User>> _loadtUsersFromUrl(userContent) async {
    List<User> list = [];
    User user = User.fromJson(jsonDecode(userContent));
    list.add(user);
  }
}
