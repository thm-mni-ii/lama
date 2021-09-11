import 'package:lama_app/app/repository/taskset_repository.dart';

/// Events used by [AdminMenuScreen] and [AdminMenuBloc]
///
/// Author: L.Kammerer
/// latest Changes: 10.09.2021
abstract class AdminMenuEvent {}

///used to load all needed [SharedPreferences]
class AdminMenuLoadPrefsEvent extends AdminMenuEvent {}

///used to change the value of an specific [SharedPreferences]
///
///{@params}
///[String] key to identify the [SharedPreferences] that should be changed
///[var] value which value should be stored
///[TasksetRepository] repository to reload all TaskSets
class AdminMenuChangePrefsEvent extends AdminMenuEvent {
  String key;
  var value;
  TasksetRepository repository;
  AdminMenuChangePrefsEvent(this.key, this.value, this.repository);
}

///used to force the default state
class AdminMenuLoadDefaultEvent extends AdminMenuEvent {}

///used to show the GitHub repository link
class AdminMenuGitHubPopUpEvent extends AdminMenuEvent {}
