import 'package:lama_app/app/user.dart';

abstract class UserLoginState {
  User get user => null;
}

class UsersLoaded extends UserLoginState {
  List<User> userList;
  UsersLoaded(this.userList);
}

class UserSelected extends UserLoginState {
  User user;
  UserSelected(this.user);
}

class UserLoginFailed extends UserLoginState {
  User user;
  String error;
  UserLoginFailed(this.user,
      {this.error = 'Da ist wohl etwas gehörig schief gelaufen'});
}

class UserLoginSuccessful extends UserLoginState {}
