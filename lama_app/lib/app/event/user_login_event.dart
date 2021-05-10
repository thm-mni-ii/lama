import 'package:lama_app/app/user.dart';

abstract class UserLoginEvent {}

class LoadUsers extends UserLoginEvent {}

class UserLogin extends UserLoginEvent {
  User user;
  String pw;
  UserLogin(this.user, this.pw);
}

class SelectUser extends UserLoginEvent {
  User user;
  SelectUser(this.user);
}

class UserLoginAbort extends UserLoginEvent {}
