import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lama_app/app/bloc/create_admin_bloc.dart';
import 'package:lama_app/app/bloc/create_user_bloc.dart';
import 'package:lama_app/app/bloc/edit_user_bloc.dart';
import 'package:lama_app/app/event/user_management_event.dart';
import 'package:lama_app/app/model/user_model.dart';
import 'package:lama_app/app/screens/create_admin_screen.dart';
import 'package:lama_app/app/screens/create_user_screen.dart';
import 'package:lama_app/app/screens/edit_user_screen.dart';
import 'package:lama_app/app/state/user_management_state.dart';
import 'package:lama_app/db/database_provider.dart';

class UserManagementBloc
    extends Bloc<UserManagementEvent, UserManagementState> {
  UserManagementBloc({UserManagementState initialState}) : super(initialState);

  @override
  Stream<UserManagementState> mapEventToState(
      UserManagementEvent event) async* {
    if (event is LoadAllUsers) yield await _loadUsers();
    if (event is LogoutAdminScreen) _logout(event.context);
    if (event is CreateUser) _createUserScreen(event.context);
    if (event is CreateAdmin) _createAdminScreen(event.context);
    if (event is EditUser) _editUserScreen(event.context, event.user);
  }

  void _createUserScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (BuildContext context) => CreateUserBloc(),
          child: CreateUserScreen(),
        ),
      ),
    ).then((value) => context.read<UserManagementBloc>().add(LoadAllUsers()));
  }

  void _createAdminScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (BuildContext context) => CreateAdminBloc(),
          child: CreateAdminScreen(),
        ),
      ),
    ).then((value) => context.read<UserManagementBloc>().add(LoadAllUsers()));
  }

  void _editUserScreen(BuildContext context, User user) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (BuildContext context) => EditUserBloc(user),
          child: EditUserScreen(user),
        ),
      ),
    ).then((value) => context.read<UserManagementBloc>().add(LoadAllUsers()));
  }

  void _logout(BuildContext context) {
    Navigator.pop(context);
  }

  //Operations
  Future<Loaded> _loadUsers() async {
    List<User> userList = await DatabaseProvider.db.getUser();
    return Loaded(userList);
  }
}
