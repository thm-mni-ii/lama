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

///used to create guest
///
///{@param}[BuildContext] to navigate
class CreateGuestEvent extends CheckScreenEvent {
  BuildContext context;
  CreateGuestEvent(this.context);
}

///used to denie the DSGVO
class DSGVODenied extends CheckScreenEvent {}

///used to load a guest and navigate to [HomeScreen]
///
///{@param}[BuildContext] to navigate and [User] for the guest
class LoadGuest extends CheckScreenEvent {
  BuildContext context;
  User user;

  LoadGuest(
    this.context,
    this.user,
  );
}

class LoadWelcomeScreen extends CheckScreenEvent {
  BuildContext context;

  LoadWelcomeScreen(this.context);
}

///used to load setup URL and navigate to [UserSelectionScreen] on success
///
///{@param}[BuildContext] to navigate
class InsertSetupEvent extends CheckScreenEvent {
  BuildContext context;

  InsertSetupEvent(this.context);
}

///used to update the setup URL
///
///{@param}[String] to pass the URL
class SetupChangeUrl extends CheckScreenEvent {
  String? setupUrl;

  SetupChangeUrl(this.setupUrl);
}
