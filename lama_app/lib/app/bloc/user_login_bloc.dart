import 'package:bloc/bloc.dart';
import 'package:lama_app/app/event/user_login_event.dart';
import 'package:lama_app/app/state/user_login_state.dart';

import '../user.dart';

class UserLoginBloc extends Bloc<UserLoginEvent, UserLoginState> {
  UserLoginBloc(UserLoginState initialState) : super(initialState);

  @override
  Stream<UserLoginState> mapEventToState(UserLoginEvent event) async* {
    if (event is LoadUsers) yield loadUsers();
    if (event is SelectUser) yield UserSelected(event.user);
    if (event is UserLogin) yield validateUserLogin(event);
    if (event is UserLoginAbort) yield loadUsers();
  }

  UserLoginState validateUserLogin(UserLogin event) {
    //TODO Validatin Login
    if (event.pw.length > 5) {
      return UserLoginSuccessful();
    } else {
      return UserLoginFailed();
    }
  }

  UsersLoaded loadUsers() {
    //TODO load all Users from Database
    List<User> userList = [
      new User(1, 'Lars', 'path'),
      new User(2, 'Kevin', 'path')
    ];
    return UsersLoaded(userList);
  }
}
