import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lama_app/app/event/safty_quastion_event.dart';
import 'package:lama_app/app/model/safty_question_model.dart';
import 'package:lama_app/app/model/user_model.dart';
import 'package:lama_app/app/state/safty_question_state.dart';
import 'package:lama_app/db/database_provider.dart';

///[Bloc] for the [SaftyQuestionScreen]
///
/// * see also
///    [SaftyQuestionScreen]
///    [SaftyQuestionEvent]
///    [SaftyQuestionState]
///    [Bloc]
///
/// Author: L.Kammerer
/// latest Changes: 10.09.2021
class SaftyQuestionBloc extends Bloc<SaftyQuestionEvent, SaftyQuestionState> {
  User user;
  SaftyQuestion saftyQuestion;
  SaftyQuestionBloc({SaftyQuestionState initialState, this.user})
      : super(initialState);

  @override
  Stream<SaftyQuestionState> mapEventToState(SaftyQuestionEvent event) async* {
    if (event is SaftyQuestionPull) yield await _saftyQuestionContent();
    if (event is SaftyQuestionPush) _saftyQuestionCheck(event);
  }

  Future<SaftyQuestionContent> _saftyQuestionContent() async {
    saftyQuestion = await DatabaseProvider.db.getSaftyQuestion(user.id);
    if (saftyQuestion == null) return SaftyQuestionContent(null, null);
    return SaftyQuestionContent(saftyQuestion.question, saftyQuestion.answer);
  }

  void _saftyQuestionCheck(SaftyQuestionPush event) {
    if (event.answer == saftyQuestion.answer) {
      Navigator.pop(event.context, true);
    }
  }
}
