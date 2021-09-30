import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lama_app/app/event/create_admin_event.dart';
import 'package:lama_app/app/model/safty_question_model.dart';
import 'package:lama_app/app/model/user_model.dart';
import 'package:lama_app/app/state/create_admin_state.dart';
import 'package:lama_app/db/database_provider.dart';
import 'package:lama_app/util/input_validation.dart';

///[Bloc] for the [CreateAdminScreen]
///
/// * see also
///    [CreateAdminScreen]
///    [CreateAdminEvent]
///    [CreateAdminState]
///    [Bloc]
///
/// Author: L.Kammerer
/// latest Changes: 14.07.2021
class CreateAdminBloc extends Bloc<CreateAdminEvent, CreateAdminState> {
  ///[User] that is inserted in to the Database later on
  ///incoming events are used to change the values of this [User]
  User _user = User(grade: 1, coins: 0, isAdmin: true, avatar: 'admin');
  SaftyQuestion _saftyQuestion = SaftyQuestion();

  CreateAdminBloc({CreateAdminState initialState}) : super(initialState);

  @override
  Stream<CreateAdminState> mapEventToState(CreateAdminEvent event) async* {
    if (event is CreateAdminPush) _adminPush(event.context);
    if (event is CreateAdminChangeName) _user.name = event.name;
    if (event is CreateAdminChangePassword) _user.password = event.password;
    if (event is CreateAdminChangeSaftyQuestion)
      _saftyQuestion.question = event.saftyQuestion;
    if (event is CreateAdminChangeSaftyAnswer)
      _saftyQuestion.answer = event.saftyAnswer;
    if (event is CreateAdminAbort) _adminAbort(event.context);
  }

  ///(private)
  ///insterting the [User] via [_insterAdmin] and
  ///pops with return value [_user] afterwards
  ///
  ///{@params}
  ///[User] as user that should be stored in the database
  ///[BuildContext] as context
  Future<void> _adminPush(BuildContext context) async {
    await _insterAdmin(_user);
    Navigator.pop(context, _user);
  }

  ///(private)
  ///inserting the given [User] into the Database
  ///
  ///{@param}[User] as user that should be stored in the database
  Future<void> _insterAdmin(User user) async {
    if (user.isAdmin != null || user.isAdmin)
      user = await DatabaseProvider.db.insertUser(user);
    if (!InputValidation.isEmpty(_saftyQuestion.question)) {
      _saftyQuestion.adminID = user.id;
      await DatabaseProvider.db.updateSaftyQuestion(_saftyQuestion);
    }
  }

  ///(private)
  ///abort the action to create an admin
  ///pops the Screen and return null
  ///
  ///{@param}[BuildContext] as context
  void _adminAbort(BuildContext context) {
    Navigator.pop(context, null);
  }
}
