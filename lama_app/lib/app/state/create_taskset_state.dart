import 'package:flutter/cupertino.dart';
import 'package:lama_app/app/bloc/taskset_creation_cart_bloc.dart';
import 'package:lama_app/app/screens/admin_menu_folder/taskset_creation_cart_screen.dart';
import 'package:lama_app/app/screens/admin_menu_folder/taskset_manage/bloc/taskset_manage_event.dart';
import 'package:lama_app/util/LamaColors.dart';

import '../task-system/taskset_model.dart';

/// States used by [TasksetCreationCartScreen] and [TasksetCreationCartBloc]
///
/// Author: N. Soethe
/// latest Changes: 01.06.2022

class CreateTasksetState {
  Taskset taskset;
  Color color = LamaColors.redPrimary;

  CreateTasksetState({
    @required this.taskset,
  });
}