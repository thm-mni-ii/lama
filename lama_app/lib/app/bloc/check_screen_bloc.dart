import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lama_app/app/bloc/create_admin_bloc.dart';
import 'package:lama_app/app/bloc/user_selection_bloc.dart';
import 'package:lama_app/app/event/check_screen_event.dart';
import 'package:lama_app/app/model/user_model.dart';
import 'package:lama_app/app/screens/create_admin_screen.dart';
import 'package:lama_app/app/screens/user_selection_screen.dart';
import 'package:lama_app/app/state/check_screen_state.dart';
import 'package:lama_app/db/database_provider.dart';

class CheckScreenBloc extends Bloc<CheckScreenEvent, CheckScreenState> {
  CheckScreenBloc({CheckScreenState initialState}) : super(initialState);

  @override
  Stream<CheckScreenState> mapEventToState(CheckScreenEvent event) async* {
    if (event is CheckForAdmin) yield await _hasAdmin(event.context);
    if (event is DSGVOAccepted) yield _navigator(event.context);
    if (event is CreateAdminEvent) yield _navigator(event.context);
  }

  Future<CheckScreenState> _hasAdmin(BuildContext context) async {
    List<User> userList = await DatabaseProvider.db.getUser();
    if (userList == null) return ShowDSGVO(await _loadDSGVO());
    for (User user in userList) {
      if (user.isAdmin) {
        _navigateAdminExist(context);
        return AdminExist();
      }
    }
    return _navigator(context);
  }

  CheckScreenState _navigator(BuildContext context) {
    _navigateNoAdmin(context);
    return CreateAdmin();
  }

  Future<String> _loadDSGVO() async {
    return await rootBundle.loadString('assets/md/DSGVO.md');
  }

  void _navigateNoAdmin(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (BuildContext context) => CreateAdminBloc(),
          child: CreateAdminScreen(),
        ),
      ),
    );
  }

  void _navigateAdminExist(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (BuildContext context) => UserSelectionBloc(),
          child: UserSelectionScreen(),
        ),
      ),
    );
  }
}
