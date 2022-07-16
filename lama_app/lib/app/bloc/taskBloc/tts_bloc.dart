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
  String text = "";
  String lang = "";

  @override
  void onChange(Change<TTSState> change) {
    super.onChange(change);
    print(change);
  }

  @override
  void onTransition(Transition<TTSEvent, TTSState> transition) {
    super.onTransition(transition);
    print(transition);
  }

  //
  //
  readText(String text,String lang) async {
    if(!home_screen_state.isTTs()) {
      return;
    }
    if (lang == "Englisch") {
      await flutterTts.setLanguage("en-US");
      await flutterTts.setSpeechRate(0.4);
      await flutterTts.setPitch(1.1);
    } else {
      await flutterTts.setLanguage("de-De");
    }
    await flutterTts.setVolume(1.0);
    await flutterTts.speak(text);
  }

  TTSBloc() : super(EmptyTTSState()){
    log(' AnswerOnInitEvent in bloc: ${state}');
    on<AnswerOnInitEvent>((event, emit) async {
       readText(event.answer, event.questionLanguage);
       log("AnswerOnInitEvent");
       //log('data: $AnswerOnInitEvent');
       //log('event.answer: ${event.answer}');
       //readText("sample", "aaa");
       emit(IsNotEmptyState(event.answer));
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
    on<IsNotEmptyStateEvent>((event, emit) async {
      log("IsNotEmptyStateEvent");
      emit(IsNotEmptyState(""));
    });
    on<ReadQuestion>((event, emit) async {
    readText(event.question, event.questionLanguage);
    emit(IsNotEmptyState(event.question));
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