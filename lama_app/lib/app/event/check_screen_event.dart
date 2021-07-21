import 'package:flutter/material.dart';

/// Events used by [CheckScreen] and [CheckScreenBloc]
///
/// Author: L.Kammerer
/// latest Changes: 14.06.2021
class CheckScreenEvent {}

///used to triggers the check for admin process
///
///{@param}[BuildContext] as context for navigation
class CheckForAdmin extends CheckScreenEvent {
  BuildContext context;
  CheckForAdmin(this.context);
}

///used to acknowledge the DSGVO
///
///{@param}[BuildContext] as context for navigation
class DSGVOAccepted extends CheckScreenEvent {
  BuildContext context;
  DSGVOAccepted(this.context);
}

///used to navigate to the [CreateAdminScreen]
///
///{@param}[BuildContext] as context for navigation
class CreateAdminEvent extends CheckScreenEvent {
  BuildContext context;
  CreateAdminEvent(this.context);
}

///used to denie the DSGVO
class DSGVODenied extends CheckScreenEvent {}
