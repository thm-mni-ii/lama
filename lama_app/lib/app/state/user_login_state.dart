import 'package:lama_app/app/user.dart';

abstract class UserLoginState {}

class UserSelectet extends UserLoginState {
  User user;
  UserSelectet(this.user);
}

class UserLoginSuccessful extends UserLoginState {}
