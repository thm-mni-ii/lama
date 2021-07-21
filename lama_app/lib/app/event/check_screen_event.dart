import 'package:flutter/material.dart';

/// Events used by [CheckScreen] and [CheckScreenBloc]
///
/// Author: L.Kammerer
/// latest Changes: 14.06.2021
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
