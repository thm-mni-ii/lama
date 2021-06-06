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
class CreateUser extends AdminScreenEvent {}

class CreateUserPush extends AdminScreenEvent {}

class CreateUserAbort extends AdminScreenEvent {}

//Change User in Bloc events
class UsernameChange extends AdminScreenEvent {
  String name;
  UsernameChange(this.name);
}

class UserPasswortChange extends AdminScreenEvent {
  String passwort;
  UserPasswortChange(this.passwort);
}

class UserGradeChange extends AdminScreenEvent {
  int grade;
  UserGradeChange(this.grade);
}
