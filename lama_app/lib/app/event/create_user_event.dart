import 'package:flutter/material.dart';

class CreateUserEvent {}

class CreateUserPush extends CreateUserEvent {}

class CreateUserAbort extends CreateUserEvent {
  BuildContext context;
  CreateUserAbort(this.context);
}

//Change User in Bloc events
class UsernameChange extends CreateUserEvent {
  String name;
  UsernameChange(this.name);
}

class UserPasswortChange extends CreateUserEvent {
  String passwort;
  UserPasswortChange(this.passwort);
}

class UserGradeChange extends CreateUserEvent {
  int grade;
  UserGradeChange(this.grade);
}

class LoadGrades extends CreateUserEvent {}
