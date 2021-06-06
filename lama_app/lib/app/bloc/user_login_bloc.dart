import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lama_app/app/bloc/admin_screen_bloc.dart';
import 'package:lama_app/app/event/user_login_event.dart';
import 'package:lama_app/app/model/user_model.dart';
import 'package:lama_app/app/repository/user_repository.dart';
import 'package:lama_app/app/screens/admin_screen.dart';
import 'package:lama_app/app/screens/home_screen.dart';
import 'package:lama_app/app/state/user_login_state.dart';
import 'package:lama_app/db/database_provider.dart';

class UserLoginBloc extends Bloc<UserLoginEvent, UserLoginState> {
  String _pass;
  UserLoginBloc({UserLoginState initialState}) : super(initialState);

  @override
  Stream<UserLoginState> mapEventToState(UserLoginEvent event) async* {
    if (event is LoadUsers) yield await _loadUsers();
    if (event is SelectUser) yield UserSelected(event.user);
    if (event is UserLogin) yield await validateUserLogin(event);
    if (event is UserLoginAbort) yield await _loadUsers();
    if (event is UserLoginChangePass) _pass = event.pass;
  }

  Future<UserLoginState> validateUserLogin(UserLogin event) async {
    if ((_pass != null && event.user != null) &&
        await DatabaseProvider.db.checkPassword(_pass, event.user) == 1) {
      UserRepository repository = UserRepository(event.user);
      if (event.user.isAdmin) {
        Navigator.pushReplacement(
          event.context,
          MaterialPageRoute(
            builder: (context) => BlocProvider(
              create: (BuildContext context) => AdminScreenBloc(),
              child: AdminScreen(),
            ),
          ),
        );
      } else {
        Navigator.pushReplacement(
            event.context,
            MaterialPageRoute(
                builder: (context) => RepositoryProvider<UserRepository>(
                    create: (context) => repository, child: HomeScreen())));
      }
      _pass = null;
      return UserLoginSuccessful();
    } else {
      return UserLoginFailed(event.user,
          error: 'Das Passwort passt nicht zu diesem Nutzer!');
    }
  }

  Future<UsersLoaded> _loadUsers() async {
    List<User> userList = await DatabaseProvider.db.getUser();
    return UsersLoaded(userList);
  }
}
