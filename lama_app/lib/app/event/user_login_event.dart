import 'package:lama_app/app/user.dart';

abstract class UserLoginEvent {}

class UserLogin extends UserLoginEvent {
  User user;
  String pw;
  UserLogin(this.user, this.pw);
}

class UserLoginAbort extends UserLoginEvent {}
