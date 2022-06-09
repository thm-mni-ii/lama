import 'package:flutter/material.dart';
import 'package:lama_app/app/model/user_model.dart';
import 'package:lama_app/app/repository/lamafacts_repository.dart';
import 'package:lama_app/app/repository/user_repository.dart';

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

class CreateGuestEvent extends CheckScreenEvent {
  BuildContext context;
  CreateGuestEvent(this.context);
}

///used to denie the DSGVO
class DSGVODenied extends CheckScreenEvent {}

class LoadGuest extends CheckScreenEvent {
  BuildContext context;
  User user;

  LoadGuest(
    this.context,
    this.user,
  );
}
