import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:lama_app/app/event/buchstabieren_event.dart';
import 'package:lama_app/app/state/buchstabieren_state.dart';
import 'package:lama_app/app/bloc/taskBloc/buchstabieren_bloc.dart';


class BuchstabierenBloc extends Bloc<BuchstabierenEvent,BuchstabierenState> {
  final FlutterTts flutterTts = FlutterTts();

  //
  //
  readText(String text, String lang) async {
    if (lang == "Englisch") {
      await flutterTts.setLanguage("en-EN");
    } else {
      await flutterTts.setLanguage("de-De");
    }
    await flutterTts.setVolume(1.0);
    await flutterTts.speak(text);
  }

  BuchstabierenBloc() : super(EmptyBuchstabierenState()) {
    on<AnswerOnInitEvent>((event, emit) async {
      readText(event.answer, event.questionLanguage);
      //log('data: $AnswerOnInitEvent');
      //log('event.answer: ${event.answer}');
      //readText("sample", "aaa");
    });
  }
}