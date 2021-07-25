import 'package:shared_preferences/shared_preferences.dart';

abstract class AdminMenuState {}

class AdminMenuDefaultState extends AdminMenuState {}

class AdminMenuPrefLoadedState extends AdminMenuState {
  bool prefDefaultTasksEnable;
  AdminMenuPrefLoadedState(this.prefDefaultTasksEnable);
}
