import 'package:flutter/material.dart';

abstract class EditUserEvent {}

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
