import 'package:lama_app/app/user.dart';

abstract class UserLoginState {}

class UsersLoaded extends UserLoginState {
  List<User> userList;
  UsersLoaded(this.userList);
}

class UserSelected extends UserLoginState {
  User user;
  UserSelected(this.user);
}

class UserLoginFailed extends UserLoginState {
  String error;
  UserLoginFailed({this.error = 'Da ist wohl etwas gehörig schief gelaufen'});
}

class UserLoginSuccessful extends UserLoginState {}
