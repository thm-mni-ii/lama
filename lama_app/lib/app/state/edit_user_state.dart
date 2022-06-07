import 'package:lama_app/app/model/user_model.dart';

/// States used by [EditUserScreen] and [EditUserBloc]
///
/// Author: L.Kammerer
/// latest Changes: 14.06.2021
abstract class EditUserState {}

///default state transmit user that should be edited
///
///{@param}[User] user that should be edited
class EditUserDefault extends EditUserState {
  User user;
  EditUserDefault(this.user);
}

///acknowledge that all changes where succcesfull
///
///transmit [User] user with old values and [User] changedUser with
///changed values
///
///{@params}
///[User] user with old values
///[User] changedUser with changed values
class EditUserChangeSuccess extends EditUserState {
  User user;
  User changedUser;
  EditUserChangeSuccess(this.user, this.changedUser);
}

///used to double check the wish to delet an specific [User]
///
///tranmit an message that should be displayed (can contain warnings)
///
///{@param}[String] message (can contain warnings)
class EditUserDeleteCheck extends EditUserState {
  String message;
  EditUserDeleteCheck(this.message);
}
