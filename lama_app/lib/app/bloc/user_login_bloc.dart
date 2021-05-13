import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:lama_app/app/event/user_login_event.dart';
import 'package:lama_app/app/model/user_model.dart';
import 'package:lama_app/app/screens/home_screen.dart';
import 'package:lama_app/app/state/user_login_state.dart';

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
          error: 'Das Passwort passt nicht zu diesem Nutzer!');
    }
  }

  UsersLoaded loadUsers() {
    //TODO load all Users from Database
    List<User> userList = [
      new User(name: 'admin', password: 'path'),
      new User(name: 'Lars', password: 'path'),
      new User(name: 'Kevin', password: 'path')
    ];
    return UsersLoaded(userList);
  }
}
