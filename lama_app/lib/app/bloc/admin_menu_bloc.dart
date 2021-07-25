import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lama_app/app/event/admin_menu_event.dart';
import 'package:lama_app/app/screens/admin_menu_screen.dart';
import 'package:lama_app/app/state/admin_menu_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdminMenuBloc extends Bloc<AdminMenuEvent, AdminMenuState> {
  SharedPreferences prefs;

  AdminMenuBloc({AdminMenuState initialState}) : super(initialState);

  @override
  Stream<AdminMenuState> mapEventToState(AdminMenuEvent event) async* {
    if (event is AdminMenuLoadPrefsEvent) yield await _loadPrefs();
    if (event is AdminMenuChangePrefsEvent) await _changePref(event);
    if (event is AdminMenuLoadDefaultEvent) yield AdminMenuDefaultState();
  }

  Future<AdminMenuState> _loadPrefs() async {
    prefs = await SharedPreferences.getInstance();
    print(prefs.getBool(AdminUtils.enableDefaultTasksetsPref));
    return AdminMenuPrefLoadedState(
        prefs.getBool(AdminUtils.enableDefaultTasksetsPref) != null
            ? prefs.getBool(AdminUtils.enableDefaultTasksetsPref)
            : true);
  }

  Future<void> _changePref(AdminMenuChangePrefsEvent event) async {
    if (event.value is bool) {
      await prefs.setBool(event.key, event.value);
      event.repository.reloadTasksetLoader();
    }
  }
}
