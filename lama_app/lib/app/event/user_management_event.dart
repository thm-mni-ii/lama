import 'package:flutter/cupertino.dart';
import 'package:lama_app/app/model/user_model.dart';

abstract class UserManagementEvent {}

class LoadAllUsers extends UserManagementEvent {}

class LogoutAdminScreen extends UserManagementEvent {
  BuildContext context;
  LogoutAdminScreen(this.context);
}

class CreateUser extends UserManagementEvent {
  BuildContext context;
  CreateUser(this.context);
}

class CreateAdmin extends UserManagementEvent {
  BuildContext context;
  CreateAdmin(this.context);
}

class EditUser extends UserManagementEvent {
  BuildContext context;
  User user;
  EditUser(this.user, this.context);
}
