import 'package:flutter/material.dart';

/// Events used by [CreateUserScreen] and [CreateUserBloc]
///
/// Author: L.Kammerer
/// latest Changes: 14.07.2021
class CreateUserEvent {}

///used to insert the [User] in to the database
///to finish the create admin process
///
///{@param}[BuildContext] as context
class CreateUserPush extends CreateUserEvent {}

///used to abort the create [User] process
///
///{@param}[BuildContext] as context
class CreateUserAbort extends CreateUserEvent {
  BuildContext context;
  CreateUserAbort(this.context);
}

///used to change [User]name in Bloc
///
///{@param}[String] name that should be set
class UsernameChange extends CreateUserEvent {
  String name;
  UsernameChange(this.name);
}

///used to change [User] password in Bloc
///
///{@param}[String] password that should be set
//TODO should be password not passwort
class UserPasswortChange extends CreateUserEvent {
  String passwort;
  UserPasswortChange(this.passwort);
}

///used to change [User] grade in Bloc
///
///{@param}[int] grade index of grade that should be set
class UserGradeChange extends CreateUserEvent {
  int grade;
  UserGradeChange(this.grade);
}

///used to load all grades
class LoadGrades extends CreateUserEvent {}
