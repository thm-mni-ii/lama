import 'package:flutter/material.dart';

class CheckScreenEvent {}

class CheckForAdmin extends CheckScreenEvent {
  BuildContext context;
  CheckForAdmin(this.context);
}
