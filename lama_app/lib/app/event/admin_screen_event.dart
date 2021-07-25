import 'package:flutter/cupertino.dart';
import 'package:lama_app/app/model/user_model.dart';

abstract class AdminScreenEvent {}

class LoadAllUsers extends AdminScreenEvent {}

class LogoutAdminScreen extends AdminScreenEvent {
  BuildContext context;
  LogoutAdminScreen(this.context);
}

class CreateUser extends AdminScreenEvent {
  BuildContext context;
  CreateUser(this.context);
}

class EditUser extends AdminScreenEvent {
  BuildContext context;
  User user;
  EditUser(this.user, this.context);
}

class TasksetOption extends AdminScreenEvent {
  BuildContext context;
  TasksetOption(this.context);
}
