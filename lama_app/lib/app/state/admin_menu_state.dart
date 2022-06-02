/// States used by [AdminMenuScreen] and [AdminMenuBloc]
///
/// Author: L.Kammerer
/// latest Changes: 14.06.2021
abstract class AdminMenuState {}

///default state
class AdminMenuDefaultState extends AdminMenuState {}

///used to transmit [SharedPreferences] values
///
///{@param}[bool] as prefDefaultTasksEnable
class AdminMenuPrefLoadedState extends AdminMenuState {
  bool prefDefaultTasksEnable;
  AdminMenuPrefLoadedState(this.prefDefaultTasksEnable);
}

///used to show the GitHub repository link
class AdminMenuGitHubPopUpState extends AdminMenuState {}
