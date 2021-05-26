import 'package:flutter/material.dart';
import 'package:lama_app/app/model/user_model.dart';

abstract class EditUserEvent {}

class EditUserDeleteUser extends EditUserEvent {
  User user;
  EditUserDeleteUser(this.user);
}

class EditUserAbort extends EditUserEvent {
  BuildContext context;
  EditUserAbort(this.context);
}
