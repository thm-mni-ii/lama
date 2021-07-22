import 'package:lama_app/app/model/user_model.dart';

/// States used by [UserManagementScreen] and [UserManagementBloc]
///
/// Author: L.Kammerer
/// latest Changes: 14.06.2021
abstract class UserManagementState {}

///transmit all [User] stored in the database
///
///{@param} [List<User>] userList with all [User] stored in the database
class Loaded extends UserManagementState {
  List<User> userList;
  Loaded(this.userList);
}
