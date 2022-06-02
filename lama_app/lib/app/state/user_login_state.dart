import 'package:lama_app/app/model/user_model.dart';

/// States used by [UserLoginScreen] and [UserLoginBloc]
///
/// Author: L.Kammerer
/// latest Changes: 14.06.2021
abstract class UserLoginState {
  User get user => null;
}

///used to transmit the [User] which try to login
///
///{@param}[User] user that try to login
class UserLoginPulled extends UserLoginState {
  User user;
  UserLoginPulled(this.user);
}

///used to transmit an failed login state with
///the [User] and an error message
///
///{@params}
///[User] user that try to login
///[String] error message why the login failed
class UserLoginFailed extends UserLoginState {
  User user;
  String error;
  UserLoginFailed(this.user,
      {this.error = 'Da ist wohl etwas gehörig schief gelaufen'});
}

///used to transmit an successfull login
class UserLoginSuccessful extends UserLoginState {}
