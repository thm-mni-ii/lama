import 'package:flutter/material.dart';

abstract class EditUserEvent {}

class EditUserPush extends EditUserEvent {}

class EditUserChangeCoins extends EditUserEvent {
  String coins;
  EditUserChangeCoins(this.coins);
}

class EditUserChangeUsername extends EditUserEvent {
  String name;
  EditUserChangeUsername(this.name);
}

class EditUserChangePasswort extends EditUserEvent {
  String passwort;
  EditUserChangePasswort(this.passwort);
}

class EditUserChangeGrade extends EditUserEvent {
  int grade;
  EditUserChangeGrade(this.grade);
}

class EditUserAbort extends EditUserEvent {
  BuildContext context;
  EditUserAbort(this.context);
}

class EditUserDeleteUserCheck extends EditUserEvent {}

class EditUserDeleteUserAbrove extends EditUserEvent {
  BuildContext context;
  EditUserDeleteUserAbrove(this.context);
}

class EditUserDeleteUserAbort extends EditUserEvent {}

class EditUserDeleteUser extends EditUserEvent {
  BuildContext context;
  EditUserDeleteUser(this.context);
}

class EditUserReturn extends EditUserEvent {
  BuildContext context;
  EditUserReturn(this.context);
}
