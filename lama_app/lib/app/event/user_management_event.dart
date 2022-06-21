import 'package:flutter/cupertino.dart';
import 'package:lama_app/app/model/user_model.dart';

/// Events used by [UserManagementScreen] and [UserManagementBloc]
///
/// Author: L.Kammerer
/// latest Changes: 14.07.2021
abstract class UserManagementEvent {}

///used to load all [User] stored in the database
class LoadAllUsers extends UserManagementEvent {}

///used to pop the screen
///
///{@param} [BuildContext] as context for navigation
//TODO very bad name this event doesn't logout anything
class LogoutAdminScreen extends UserManagementEvent {
  BuildContext context;
  LogoutAdminScreen(this.context);
}

///used to navigate to [CreateUserScreen]
///
///{@param} [BuildContext] as context for navigation
class CreateUser extends UserManagementEvent {
  BuildContext context;
  CreateUser(this.context);
}

///used to navigate to [CreateAdminScreen]
///
///{@param} [BuildContext] as context for navigation
class CreateAdmin extends UserManagementEvent {
  BuildContext context;
  CreateAdmin(this.context);
}

///used to navigate to [EditUserScreen]
///
///{@params}
///[User] user that should be edited
///[BuildContext] as context for navigation
class EditUser extends UserManagementEvent {
  BuildContext context;
  User user;
  EditUser(this.user, this.context);
}
