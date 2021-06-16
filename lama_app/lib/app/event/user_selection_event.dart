import 'package:flutter/material.dart';
import 'package:lama_app/app/model/user_model.dart';

abstract class UserSelectionEvent {}

class LoadUsers extends UserSelectionEvent {}

class SelectUser extends UserSelectionEvent {
  User user;
  BuildContext context;
  SelectUser(this.user, this.context);
}
