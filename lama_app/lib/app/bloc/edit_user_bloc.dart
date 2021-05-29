import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:lama_app/app/event/edit_user_event.dart';
import 'package:lama_app/app/model/user_model.dart';
import 'package:lama_app/app/state/edit_user_state.dart';
import 'package:lama_app/db/database_provider.dart';

class EditUserBloc extends Bloc<EditUserEvent, EditUserState> {
  User _user;

  EditUserBloc(User user, {EditUserState initialState}) : super(initialState) {
    this._user = user;
  }

  @override
  Stream<EditUserState> mapEventToState(event) async* {
    if (event is EditUserAbort) _editUserReturn(event.context);
    if (event is EditUserDeleteUserCheck) yield await _deleteUserCheck();
    if (event is EditUserDeleteUserAbrove) _deleteUser(event.context);
    if (event is EditUserDeleteUserAbort) yield EditUserDefault();
  }

  Future<EditUserState> _deleteUserCheck() async {
    return EditUserDeleteCheck(
        'Sind sie sicher, dass sie den Nutzer ${_user.name} löschen möchten?');
  }

  Future<void> _deleteUser(BuildContext context) async {
    await DatabaseProvider.db.deleteUser(_user.id);
    _editUserReturn(context);
  }

  void _editUserReturn(BuildContext context) {
    Navigator.pop(context);
  }

  Future<bool> _checkForLastAdmin() async {
    await DatabaseProvider.db.getUser();
  }
}
