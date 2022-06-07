import 'package:flutter/material.dart';
import 'package:lama_app/app/bloc/taskset_manage_bloc.dart';
import 'package:lama_app/app/screens/admin_menu_folder/taskset_manage_screen.dart';


/// Events used by [TasksetManageScreen] and [TasksetManageBloc]
///
/// Author: N. Soethe
/// latest Changes: 28.05.2022
abstract class TasksetManageEvent {}

class CreateTaskset extends TasksetManageEvent {

}