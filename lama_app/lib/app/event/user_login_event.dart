import 'package:flutter/cupertino.dart';
import 'package:lama_app/app/model/user_model.dart';

abstract class UserLoginEvent {}

class LoadUsers extends UserLoginEvent {}

class UserLogin extends UserLoginEvent {
  User user;
  BuildContext context;
  UserLogin(this.user, this.context);
}

class SelectUser extends UserLoginEvent {
  User user;
  BuildContext context;
  SelectUser(this.user, this.context);
}

class UserLoginAbort extends UserLoginEvent {}

class UserLoginChangePass extends UserLoginEvent {
  String pass;
  UserLoginChangePass(this.pass);
}
