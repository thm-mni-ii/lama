import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lama_app/app/event/safty_quastion_event.dart';
import 'package:lama_app/app/model/user_model.dart';
import 'package:lama_app/app/state/safty_question_state.dart';

///[Bloc] for the [SaftyQuestionScreen]
///
/// * see also
///    [SaftyQuestionScreen]
///    [SaftyQuestionEvent]
///    [SaftyQuestionState]
///    [Bloc]
///
/// Author: L.Kammerer
/// latest Changes: 09.09.2021
class SaftyQuestionBloc extends Bloc<SaftyQuestionEvent, SaftyQuestionState> {
  User user;
  SaftyQuestionBloc({SaftyQuestionState initialState, this.user})
      : super(initialState);

  @override
  Stream<SaftyQuestionState> mapEventToState(SaftyQuestionEvent event) async* {
    if (event is SaftyQuestionPull) yield _saftyQuestionContent();
    if (event is SaftyQuestionPush) Navigator.pop(event.context, true);
  }

  SaftyQuestionContent _saftyQuestionContent() {
    return SaftyQuestionContent("5+3", "8");
  }
}
