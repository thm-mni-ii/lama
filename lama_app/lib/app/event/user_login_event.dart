import 'package:flutter/cupertino.dart';
import 'package:lama_app/app/model/user_model.dart';

abstract class UserLoginEvent {}

class LoadUsers extends UserLoginEvent {}

class UserLogin extends UserLoginEvent {
  User user;
  String pw;
  BuildContext context;
  UserLogin(this.user, this.pw, this.context);
}

class SelectUser extends UserLoginEvent {
  User user;
  SelectUser(this.user);
}

class UserLoginAbort extends UserLoginEvent {}
