import 'package:flutter/material.dart';

class CheckScreenEvent {}

class CheckForAdmin extends CheckScreenEvent {
  BuildContext context;
  CheckForAdmin(this.context);
}

class DSGVOAccepted extends CheckScreenEvent {
  BuildContext context;
  DSGVOAccepted(this.context);
}

class CreateAdminEvent extends CheckScreenEvent {
  BuildContext context;
  CreateAdminEvent(this.context);
}

class DSGVODenied extends CheckScreenEvent {}
