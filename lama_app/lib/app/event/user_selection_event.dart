import 'package:flutter/material.dart';
import 'package:lama_app/app/model/user_model.dart';

/// Events used by [UserSelectionScreen] and [UserSelectionBloc]
///
/// Author: L.Kammerer
/// latest Changes: 14.07.2021
abstract class UserSelectionEvent {}

///used to load all [User] stored in the database
class LoadUsers extends UserSelectionEvent {}

///used to select an specific [User] for the [UserLoginScreen]
///starts the [User] login process
///
///{@params}
///[User] user that should logged in
///[BuildContext] as context for navigation
class SelectUser extends UserSelectionEvent {
  User user;
  BuildContext context;
  SelectUser(this.user, this.context);
}
