import 'package:lama_app/app/screens/admin_menu_folder/taskset_manage/screens/taskset_manage_screen.dart';

/// States used by [TasksetManageScreen] and [TasksetManageBloc]
///
/// Author: N. Soethe
/// latest Changes: 01.06.2022

abstract class TasksetManageState {}

class TasksetManageInitial extends TasksetManageState {}

class ChangeTasksetStatus extends TasksetManageState {}

class WaitingTasksetStatus extends TasksetManageState {}
