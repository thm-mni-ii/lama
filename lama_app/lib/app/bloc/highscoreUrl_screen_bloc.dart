import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lama_app/app/event/highscoreUrl_screen_event.dart';
import 'package:lama_app/app/model/user_model.dart';
import 'package:lama_app/app/screens/admin_menu_screen.dart';
import 'package:lama_app/app/state/highscoreUrl_screen_state.dart';
import 'package:lama_app/db/database_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

///[Bloc] for the [HighscoreUrlOptionsScreen]
///
/// * see also
///    [HighscoreUrlScreenBloc]
///    [HighscoreUrlScreenEvent]
///    [HighscoreUrlScreenState]
///    [Bloc]
///
/// Author: L.Kammerer
/// latest Changes: 26.06.2021
class HighscoreUrlScreenBloc
    extends Bloc<HighscoreUrlScreenEvent, HighscoreUrlScreenState> {
  String _urlChanged;
  String _urlCurrent;
  SharedPreferences _prefs;
  List<User> _userList = [];
  HighscoreUrlScreenBloc({HighscoreUrlScreenState initialState})
      : super(initialState);

  @override
  Stream<HighscoreUrlScreenState> mapEventToState(
      HighscoreUrlScreenEvent event) async* {
    if (event is HighscoreUrlPullEvent) yield await _pull();
    if (event is HighscoreUrlPushEvent) await _push();
    if (event is HighscoreUrlChangeEvent) _urlChanged = event.url;
    if (event is HighscoreUrlReloadEvent) yield HighscoreUrlReloadState();
  }

  Future<HighscoreUrlPullState> _pull() async {
    _prefs = await SharedPreferences.getInstance();
    _urlCurrent = _prefs.getString(AdminUtils.highscoreUploadUrlPref);
    _urlChanged = _urlCurrent;
    _userList = await DatabaseProvider.db.getUser();
    _userList.removeWhere((user) => user.isAdmin);
    return HighscoreUrlPullState(_userList, _urlChanged);
  }

  Future<void> _push() async {
    await _prefs.setString(AdminUtils.highscoreUploadUrlPref, _urlChanged);
  }
}
