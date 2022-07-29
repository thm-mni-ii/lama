import 'package:flutter/material.dart';
import 'package:lama_app/app/model/user_model.dart';
import 'package:lama_app/app/repository/lamafacts_repository.dart';
import 'package:lama_app/app/repository/user_repository.dart';
import 'package:lama_app/app/screens/check_Screen.dart';

/// States used by [CheckScreen] and [CheckScreenBloc]
///
/// Author: L.Kammerer
/// latest Changes: 14.06.2021
class CheckScreenState {}

///transmit that an admin is stored in the Database
class AdminExist extends CheckScreenState {}

///transmit that no admin is stored in the Database
class NoAdmin extends CheckScreenState {}

///transmit the dsgvo and show them
///
///{@param}[String] dsgvo contains dsgvo
class ShowDSGVO extends CheckScreenState {
  String dsgvo;
  ShowDSGVO(this.dsgvo);
}

///should provide an CreateAdminScreen
class CreateAdmin extends CheckScreenState {}

///shows welcome screen
class ShowWelcome extends CheckScreenState {}

///after guest was created in welcome screen
class HasGuest extends CheckScreenState {
  BuildContext context;
  User user;
  HasGuest(
    this.context,
    this.user,
  );
}

//state thats used when setupurl got entered
class LoadSetup extends CheckScreenState {
  String? userlistUrl;
  String? tasksetUrl;

  LoadSetup(this.userlistUrl, this.tasksetUrl);
}

//state after setup was loaded
class SetupLoaded extends CheckScreenState {}

//state thats used when setupurl got changed
class ChangeUrl extends CheckScreenState {}

//state thats used to indicate that the setup-url threw an error
class SetupError extends CheckScreenState {
  String errorMessage;

  SetupError(this.errorMessage);
}
