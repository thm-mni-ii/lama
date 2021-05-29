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
    if (_user.isAdmin && await _checkForLastAdmin())
      return EditUserDeleteCheck(
          'HINWEIS: \n Sie sind im Begriff den letzten Admin zu löschen. \n Sind keine Nutzer dieser Art vorhanden, werden Sie nach dem Neustart der App aufgefordert einen neuen Admin Nutzer zu erstellen. \n Dies hat KEINE auswirkungen auf andere Nutzer.');
    else
      return EditUserDeleteCheck(
          'Sie möchten den Nutzer (${_user.name}) löschen.');
  }

  Future<void> _deleteUser(BuildContext context) async {
    await DatabaseProvider.db.deleteUser(_user.id);
    _editUserReturn(context);
  }

  void _editUserReturn(BuildContext context) {
    Navigator.pop(context);
  }

  Future<bool> _checkForLastAdmin() async {
    List<User> list = await DatabaseProvider.db.getUser();
    int count = 0;
    list.forEach((element) {
      if (element.isAdmin) count++;
      if (count >= 2) return false;
    });
    return true;
  }
}
