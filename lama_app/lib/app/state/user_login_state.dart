import 'package:lama_app/app/model/user_model.dart';

abstract class UserLoginState {
  User get user => null;
}

class UserLoginPulled extends UserLoginState {
  User user;
  UserLoginPulled(this.user);
}

class UserLoginFailed extends UserLoginState {
  User user;
  String error;
  UserLoginFailed(this.user,
      {this.error = 'Da ist wohl etwas gehörig schief gelaufen'});
}

class UserLoginSuccessful extends UserLoginState {}
