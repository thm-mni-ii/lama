import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:lama_app/app/event/tts_event.dart';
import 'package:lama_app/app/state/tts_state.dart';
import 'package:lama_app/app/state/home_screen_state.dart';

/// Authors: J.Wißbach and A.Grishin

/*
Bloc Klasse mit Methode, um Texte, die übergeben werden, vorgelesen werden.
Und Events, um diese Texte vorzulesen.
 */

class TTSBloc extends Bloc<TTSEvent,TTSState> {
  final FlutterTts flutterTts = FlutterTts();
  String text = "";
  String lang = "";

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
    on<QuestionOnInitEvent>((event, emit) async {
       readText(event.question, event.questionLanguage);
       emit(IsNotEmptyState());
    });
    on<ClickOnQuestionEvent>((event, emit) async {
       readText(event.texttoPlay, event.answerLanguage);
      emit(VoiceTtsState());
    });
    on<ClickOnAnswerEvent>((event, emit) async {
       readText(event.answer,event.answerLanguage);
      emit(VoiceAnswerTtsState(event.answer));
    });
    on<SetDefaultEvent>((event, emit) async {
      emit(EmptyTTSState());
    });
    on<IsNotEmptyStateEvent>((event, emit) async {
      emit(IsNotEmptyState());
    });
    on<ReadQuestionEvent>((event, emit) async {
      readText(event.question, event.questionLanguage);
    });
  }



}