import 'package:flutter/cupertino.dart';
import 'package:lama_app/app/bloc/taskset_creation_cart_bloc.dart';
import 'package:lama_app/app/screens/admin_menu_folder/taskset_creation_card/screens/taskset_creation_cart_screen.dart';
import 'package:lama_app/util/LamaColors.dart';


/// States used by [TasksetCreationCartScreen] and [TasksetCreationCartBloc]
///
/// Author: N. Soethe
/// latest Changes: 01.06.2022

abstract class CreateTasksetState{
  Color color = LamaColors.redPrimary;

  CreateTasksetState();
}
 class InitialState extends CreateTasksetState {}

class ChangedTasksListState extends CreateTasksetState {}

class CreateTasksetSucessfull extends CreateTasksetState {}