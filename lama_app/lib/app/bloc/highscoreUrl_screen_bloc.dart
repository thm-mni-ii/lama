import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lama_app/app/event/highscoreUrl_screen_event.dart';
import 'package:lama_app/app/state/highscoreUrl_screen_state.dart';

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
class HighscoreUrlScreenBloc extends Bloc<HighscoreUrlScreenEvent, HighscoreUrlScreenState> {
  HighscoreUrlScreenBloc({HighscoreUrlScreenState initialState}) : super(initialState);

  @override
  Stream<HighscoreUrlScreenState> mapEventToState(HighscoreUrlScreenEvent event) async* {}
}
