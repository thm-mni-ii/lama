import 'package:lama_app/app/bloc/taskset_creation_bloc.dart';
import 'package:lama_app/app/screens/admin_menu_folder/taskset_creation_screen.dart';

/// Events used by [TasksetCreationScreen] and [TasksetCreationBloc]
///
/// Author: N. Soethe
/// latest Changes: 01.06.2022
abstract class TasksetCreationEvent {}

class createTaskset extends TasksetCreationEvent {

}