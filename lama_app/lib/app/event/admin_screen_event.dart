import 'package:flutter/cupertino.dart';
import 'package:lama_app/app/model/user_model.dart';

abstract class AdminScreenEvent {}

//defaults
class LoadAllUsers extends AdminScreenEvent {}

class LogoutAdminScreen extends AdminScreenEvent {
  BuildContext context;
  LogoutAdminScreen(this.context);
}

//Change User details events
class SelectUser extends AdminScreenEvent {
  User user;
  SelectUser(this.user);
}

//Create new User events
class CreateUser extends AdminScreenEvent {
  BuildContext context;
  CreateUser(this.context);
}
