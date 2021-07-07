import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lama_app/app/event/admin_menu_event.dart';
import 'package:lama_app/app/screens/admin_menu_screen.dart';
import 'package:lama_app/app/state/admin_menu_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdminMenuBloc extends Bloc<AdminMenuEvent, AdminMenuState> {
  AdminMenuBloc({AdminMenuState initialState}) : super(initialState);

  @override
  Stream<AdminMenuState> mapEventToState(AdminMenuEvent event) async* {
    if (event is AdminMenuLoadPrefsEvent) yield await _loadPrefs();
  }

  Future<AdminMenuState> _loadPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return AdminMenuDefaultState(
        prefs.getBool(AdminUtils.enableDefaultTasksetsPref));
  }
}
