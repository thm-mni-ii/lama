import 'package:lama_app/app/model/user_model.dart';

/// States used by [UserSelectionScreen] and [UserSelectionBloc]
///
/// Author: L.Kammerer
/// latest Changes: 14.06.2021
abstract class UserSelectionState {}

///transmit all [User] stored in the database
///
///{@param} [List<User>] userList with all [User] stored in the database
class UsersLoaded extends UserSelectionState {
  List<User> userList;
  UsersLoaded(this.userList);
}

///transmit the [User] which is selected
///
///{@param}[User] user that is selected
class UserSelected extends UserSelectionState {
  User user;
  UserSelected(this.user);
}
