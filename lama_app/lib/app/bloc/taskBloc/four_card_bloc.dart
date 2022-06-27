import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:lama_app/app/event/four_card_event.dart';
import 'package:lama_app/app/state/four_card_task_screen_state.dart';

class FourCardBloc extends Bloc<FourCardEvent,FourCardState> {
  final FlutterTts flutterTts = FlutterTts();
  //
  //

  FourCardBloc() : super(EmptyFCardState());

  @override
  Stream<FourCardState> mapEventToState(FourCardEvent event) async* {

    //yield AnswerOnInitState();

    // if (event is EmptyFCardState) {
    //   yield AnswerOnInitState();
    // }
    if (event is AnswerOnInitEvent) {
      readText(event.answer, event.answerLanguage);
    }


    if (event is ClickOnWordQuestion) {

      readText(event.texttoPlay, event.answerLanguage);
      yield VoiceTtsState();
    }
    if (event is ClickOnAnswer) {
      readText(event.answer,event.answerLanguage);
      yield VoiceAnswerTtsState(event.answer);
    }
  }

  readText(String text,String lang) async {
    if (lang == "Englisch") {
      await flutterTts.setLanguage("en-EN");
    } else {
      await flutterTts.setLanguage("de-De");
    }

    await flutterTts.setVolume(1.0);
    await flutterTts.speak(text);
  }

// readText(String text) async {
//   if(task.answerLaguage == "Englisch") {
//     await flutterTts.setLanguage("en-EN");
//   } else {
//     await flutterTts.setLanguage("de-De");
//   }
//   await flutterTts.setVolume(1.0);
//   await flutterTts.speak(text);
// }

}