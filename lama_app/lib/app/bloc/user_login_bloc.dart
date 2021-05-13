import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:lama_app/app/event/user_login_event.dart';
import 'package:lama_app/app/model/user_model.dart';
import 'package:lama_app/app/screens/home_screen.dart';
import 'package:lama_app/app/state/user_login_state.dart';
import 'package:lama_app/db/database_provider.dart';

class UserLoginBloc extends Bloc<UserLoginEvent, UserLoginState> {
  UserLoginBloc({UserLoginState initialState}) : super(initialState);

  @override
  Stream<UserLoginState> mapEventToState(UserLoginEvent event) async* {
    if (event is LoadUsers) yield await loadUsers();
    if (event is SelectUser) yield UserSelected(event.user);
    if (event is UserLogin) yield validateUserLogin(event);
    if (event is UserLoginAbort) yield await loadUsers();
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

  Future<UsersLoaded> loadUsers() async {
    await DatabaseProvider.db
        .insertUser(User(name: 'admin', password: 'admin', isAdmin: true));
    List<User> userList = await DatabaseProvider.db.getUser();
    return UsersLoaded(userList);
  }
}
