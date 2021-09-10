import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lama_app/app/event/admin_settings_event.dart';
import 'package:lama_app/app/state/admin_settings_state.dart';

///[Bloc] for the [UserLoginScreen]
///
/// * see also
///    [UserLoginScreen]
///    [UserLoginEvent]
///    [UserLoginState]
///    [Bloc]
///
/// Author: L.Kammerer
/// latest Changes: 26.06.2021
class AdminSettingsBloc extends Bloc<AdminSettingsEvent, AdminSettingsState> {
  AdminSettingsBloc({AdminSettingsState initialState}) : super(initialState);

  @override
  Stream<AdminSettingsState> mapEventToState(AdminSettingsEvent event) async* {}
}
