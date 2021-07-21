import 'package:flutter/material.dart';

/// Events used by [EditUserScreen] and [EditUserBloc]
///
/// Author: L.Kammerer
/// latest Changes: 14.07.2021
abstract class EditUserEvent {}

///used to apply the changes to the [User] an update the database
class EditUserPush extends EditUserEvent {}

///used to change [User]coins in Bloc
///
///{@param}[String] coins that should be set
class EditUserChangeCoins extends EditUserEvent {
  String coins;
  EditUserChangeCoins(this.coins);
}

///used to change [User]name in Bloc
///
///{@param}[String] name that should be set
class EditUserChangeUsername extends EditUserEvent {
  String name;
  EditUserChangeUsername(this.name);
}

///used to change [User] password in Bloc
///
///{@param}[String] password that should be set
//TODO should be password not passwort
class EditUserChangePasswort extends EditUserEvent {
  String passwort;
  EditUserChangePasswort(this.passwort);
}

///used to change [User] grade in Bloc
///
///{@param}[int] grade index of grade that should be set
class EditUserChangeGrade extends EditUserEvent {
  int grade;
  EditUserChangeGrade(this.grade);
}

///used to abort the edit [User] process
///
///{@param}[BuildContext] as context
class EditUserAbort extends EditUserEvent {
  BuildContext context;
  EditUserAbort(this.context);
}

///used to force an approve of the wish to delet an specific user
class EditUserDeleteUserCheck extends EditUserEvent {}

///approves the wish to delete an user and finish the delete [User] process
//TODO Change name to ...Approve from ...Abrove
class EditUserDeleteUserAbrove extends EditUserEvent {
  BuildContext context;
  EditUserDeleteUserAbrove(this.context);
}

///abort the wish to delete an specific user
class EditUserDeleteUserAbort extends EditUserEvent {}

//TODO delete if not used
class EditUserDeleteUser extends EditUserEvent {
  BuildContext context;
  EditUserDeleteUser(this.context);
}

///used to pop the [EditUserScreen]
///{@param}[BuildContext] as context
class EditUserReturn extends EditUserEvent {
  BuildContext context;
  EditUserReturn(this.context);
}
