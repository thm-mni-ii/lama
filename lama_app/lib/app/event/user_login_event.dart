import 'package:flutter/cupertino.dart';
import 'package:lama_app/app/model/user_model.dart';

abstract class UserLoginEvent {}

class UserLogin extends UserLoginEvent {
  User user;
  BuildContext context;
  UserLogin(this.user, this.context);
}

class UserLoginPullUser extends UserLoginEvent {}

class UserLoginAbort extends UserLoginEvent {
  BuildContext context;
  UserLoginAbort(this.context);
}

class UserLoginChangePass extends UserLoginEvent {
  String pass;
  UserLoginChangePass(this.pass);
}
