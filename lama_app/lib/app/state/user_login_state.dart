import 'package:lama_app/app/user.dart';

abstract class UserLoginState {}

class UserSelected extends UserLoginState {
  User user;
  UserSelected(this.user);
}

class UserLoginSuccessful extends UserLoginState {}
