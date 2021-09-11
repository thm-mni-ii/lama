import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lama_app/app/event/admin_menu_event.dart';
import 'package:lama_app/app/screens/admin_menu_screen.dart';
import 'package:lama_app/app/state/admin_menu_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

///[Bloc] for the [AdminMenuScreen]
///
/// * see also
///    [AdminMenuScreen]
///    [AdminMenuEvent]
///    [AdminMenuState]
///    [Bloc]
///
/// Author: L.Kammerer
/// latest Changes: 10.09.2021
class AdminMenuBloc extends Bloc<AdminMenuEvent, AdminMenuState> {
  //temporar storage for [SharedPreferences]
  SharedPreferences prefs;

  AdminMenuBloc({AdminMenuState initialState}) : super(initialState);

  @override
  Stream<AdminMenuState> mapEventToState(AdminMenuEvent event) async* {
    if (event is AdminMenuLoadPrefsEvent) yield await _loadPrefs();
    if (event is AdminMenuChangePrefsEvent) await _changePref(event);
    if (event is AdminMenuLoadDefaultEvent) yield AdminMenuDefaultState();
    if (event is AdminMenuGitHubPopUpEvent) yield AdminMenuGitHubPopUpState();
  }

  ///(private)
  ///loading [SharedPreferences] enableDefaultTasksetsPref and stores the
  ///[SharedPreferences] instance in [prefs]
  ///
  ///{@important} to understand why the [AdminMenuPrefLoadedState] is filled with true by default
  ///basic knowledge about [SharedPreferences] is needed
  ///
  ///{@return} [AdminMenuPrefLoadedState]
  Future<AdminMenuState> _loadPrefs() async {
    prefs = await SharedPreferences.getInstance();

    ///if the enableDefaultTasksetsPref value isn't set yet the
    ///[AdminMenuPrefLoadedState] should return the default value of true
    ///to prevent issues and to make sure the [SharedPreferences] can be set at the next change
    return AdminMenuPrefLoadedState(
        prefs.getBool(AdminUtils.enableDefaultTasksetsPref) != null
            ? prefs.getBool(AdminUtils.enableDefaultTasksetsPref)
            : true);
  }

  ///(private)
  ///set value enableDefaultTasksetsPref in [SharedPreferences]
  ///
  ///{@param} AdminMenuChangePrefsEvent as event to use the value in this event
  ///
  ///{@return} [Future]
  Future<void> _changePref(AdminMenuChangePrefsEvent event) async {
    if (event.value is bool) {
      await prefs.setBool(event.key, event.value);
      event.repository.reloadTasksetLoader();
    }
  }
}
