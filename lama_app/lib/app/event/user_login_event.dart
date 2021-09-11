import 'package:flutter/cupertino.dart';
import 'package:lama_app/app/model/user_model.dart';

/// Events used by [UserLoginScreen] and [UserLoginBloc]
///
/// Author: L.Kammerer
/// latest Changes: 10.09.2021
abstract class UserLoginEvent {}

///used to try the loggin for an specific [User]
///
///{@params}
///[User] user that try the login
///[BuildContext] as context for navigation
class UserLogin extends UserLoginEvent {
  User user;
  BuildContext context;
  UserLogin(this.user, this.context);
}

///used to load the [User] that should be logged in
class UserLoginPullUser extends UserLoginEvent {}

///used to abort the login process
///
///{@param}[BuildContext] as context
class UserLoginAbort extends UserLoginEvent {
  BuildContext context;
  UserLoginAbort(this.context);
}

///used to change [User] password in Bloc
///
///{@param}[String] pass that should be set
class UserLoginChangePass extends UserLoginEvent {
  String pass;
  UserLoginChangePass(this.pass);
}

class UserLoginForgotPassword extends UserLoginEvent {
  BuildContext context;
  UserLoginForgotPassword(this.context);
}
