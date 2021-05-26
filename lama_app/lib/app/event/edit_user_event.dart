import 'package:flutter/material.dart';

abstract class EditUserEvent {}

class EditUserAbort extends EditUserEvent {
  BuildContext context;
  EditUserAbort(this.context);
}
