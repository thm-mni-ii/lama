import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:lama_app/app/event/tts_event.dart';
import 'package:lama_app/app/state/tts_state.dart';
import 'package:lama_app/app/state/home_screen_state.dart';

class TTSBloc extends Bloc<TTSEvent,TTSState> {
  final FlutterTts flutterTts = FlutterTts();
  //
  //
  readText(String text,String lang) async {
    if(!home_screen_state.isTTs()) {
      return;
    }
    if (lang == "Englisch") {
      await flutterTts.setLanguage("en-EN");
    } else {
      await flutterTts.setLanguage("de-De");
    }
    await flutterTts.setVolume(1.0);
    await flutterTts.speak(text);
  }

  TTSBloc() : super(EmptyTTSState()){
    on<AnswerOnInitEvent>((event, emit) async {
       readText(event.answer, event.questionLanguage);
       //log('data: $AnswerOnInitEvent');
       //log('event.answer: ${event.answer}');
       //readText("sample", "aaa");
    });
    on<ClickOnWordQuestion>((event, emit) async {
       readText(event.texttoPlay, event.answerLanguage);
       //log('data: $ClickOnWordQuestion');
      emit(VoiceTtsState());
    });
    on<ClickOnAnswer>((event, emit) async {
       readText(event.answer,event.answerLanguage);
       //log('data: $ClickOnAnswer');
       //log('event.answer: ${event.answer}');
      emit(VoiceAnswerTtsState(event.answer));
    });
    on<SetDefaultEvent>((event, emit) async {

      emit(EmptyTTSState());
    });
  }

  // @override
  // Stream<FourCardState> mapEventToState(FourCardEvent event) async* {
  //
  //
  //
  //   if (event is AnswerOnInitEvent) {
  //     readText(event.answer, event.answerLanguage);
  //   }
  //
  //
  //   if (event is ClickOnWordQuestion) {
  //     readText(event.texttoPlay, event.answerLanguage);
  //     yield VoiceTtsState();
  //   }
  //
  //   if (event is ClickOnAnswer) {
  //     readText(event.answer,event.answerLanguage);
  //     yield VoiceAnswerTtsState(event.answer);
  //   }
  // }



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