import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:lama_app/app/event/user_login_event.dart';
import 'package:lama_app/app/screens/home_screen.dart';
import 'package:lama_app/app/state/user_login_state.dart';

import '../user.dart';

class UserLoginBloc extends Bloc<UserLoginEvent, UserLoginState> {
  UserLoginBloc({UserLoginState initialState}) : super(initialState);

  @override
  Stream<UserLoginState> mapEventToState(UserLoginEvent event) async* {
    if (event is LoadUsers) yield loadUsers();
    if (event is SelectUser) yield UserSelected(event.user);
    if (event is UserLogin) yield validateUserLogin(event);
    if (event is UserLoginAbort) yield loadUsers();
  }

  UserLoginState validateUserLogin(UserLogin event) {
    //TODO Validatin Login
    if (event.pw == 'admin' && event.user.name == 'admin') {
      Navigator.push(
          event.context, MaterialPageRoute(builder: (context) => HomeScreen()));
      return UserLoginSuccessful();
    } else {
      return UserLoginFailed(event.user,
          error: 'Das Passwort ist wohl flasch!');
    }
  }

  UsersLoaded loadUsers() {
    //TODO load all Users from Database
    List<User> userList = [
      new User(1, 'admin', 'path'),
      new User(2, 'Lars', 'path'),
      new User(3, 'Kevin', 'path')
    ];
    return UsersLoaded(userList);
  }
}
