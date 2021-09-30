import 'package:flutter/cupertino.dart';

/// Events used by [CreateAdminScreen] and [CreateAdminBloc]
///
/// Author: L.Kammerer
/// latest Changes: 14.07.2021
abstract class CreateAdminEvent {}

///used to insert the admin in to the database
///to finish the create admin process
///
///{@param}[BuildContext] as context
class CreateAdminPush extends CreateAdminEvent {
  BuildContext context;
  CreateAdminPush(this.context);
}

///used to change admin [User]name in Bloc
///
///{@param}[String] name that should be set
class CreateAdminChangeName extends CreateAdminEvent {
  String name;
  CreateAdminChangeName(this.name);
}

///used to change admin [User] password in Bloc
///
///{@param}[String] password that should be set
class CreateAdminChangePassword extends CreateAdminEvent {
  String password;
  CreateAdminChangePassword(this.password);
}

///used to transmit the safty question
///
///{@param}[String] safty question that should be set
class CreateAdminChangeSaftyQuestion extends CreateAdminEvent {
  String saftyQuestion;
  CreateAdminChangeSaftyQuestion(this.saftyQuestion);
}

///used to transmit the safty answer
///
///{@param}[String] safty answer that should be set
class CreateAdminChangeSaftyAnswer extends CreateAdminEvent {
  String saftyAnswer;
  CreateAdminChangeSaftyAnswer(this.saftyAnswer);
}

///used to abort the create admin process
///
///{@param}[BuildContext] as context
class CreateAdminAbort extends CreateAdminEvent {
  BuildContext context;
  CreateAdminAbort(this.context);
}
