import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:lama_app/app/bloc/user_login_bloc.dart';
import 'package:lama_app/app/event/user_selection_event.dart';
import 'package:lama_app/app/model/user_model.dart';
import 'package:lama_app/app/screens/user_login_screen.dart';
import 'package:lama_app/app/state/user_selection_state.dart';
import 'package:lama_app/db/database_provider.dart';

class UserSelectionBloc extends Bloc<UserSelectionEvent, UserSelectionState> {
  UserSelectionBloc({UserSelectionState initialState}) : super(initialState);

  @override
  Stream<UserSelectionState> mapEventToState(UserSelectionEvent event) async* {
    if (event is LoadUsers) yield await loadUsers();
    if (event is SelectUser) {
      _userSelected(event.user, event.context);
      yield UserSelected(event.user);
    }
  }

  Future<UsersLoaded> loadUsers() async {
    List<User> userList = await DatabaseProvider.db.getUser();
    return UsersLoaded(userList);
  }

  void _userSelected(User user, BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (BuildContext context) => UserLoginBloc(user: user),
          child: UserLoginScreen(),
        ),
      ),
    ).then((value) => context.read<UserSelectionBloc>().add(LoadUsers()));
  }
}
