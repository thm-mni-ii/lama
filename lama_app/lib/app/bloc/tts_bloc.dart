import 'package:bloc/bloc.dart';
import 'package:flutter_tts/flutter_tts.dart';

import '../event/tts_event.dart';
import '../state/tts_state.dart';

//enum TtsStateOld { playing, stopped, paused, continued }

class TtsBloc extends Bloc<TtsEvent,TtsState> {

  //TtsBloc() : super(null) ;
  //InitTtsEvent get initialState => InitTtsEvent();


  FlutterTts? flutterTts;
  double? volume;
  double? pitch;
  double? rate;

  String? _newVoiceText;
  int? _inputLength;

  String? language;
  String? engine;

  TtsBloc() : super(InitTts());


  @override
  Stream<TtsState> mapEventToState(
      TtsEvent event,
      ) async* {
        if (event is GetLanguageEvent) {
          yield GetLanguageState(_getLanguages());
        }
        if (event is InitTtsEvent) {
          yield InitTts(); // return state
          initializeTts();
        }
        if (event is PlayTtsEventAnswers || event is PlayTtsEventQuestion  ) {
          yield PlayTtsState();
          await _speak(event.text);
        }
        if (event is StopTtsEvent) {
          yield StopTtsState();
          await _stop();
        }
        if (event is PauseTtsEvent) {
          yield PauseTtsState();
          await _pause();
        }

  }

  initializeTts() {
    this.volume = 0.5;
    this.pitch = 1.0;
    this.rate = 0.5;
  }


  Future<dynamic>? _getLanguages() => flutterTts?.getLanguages;

  Future<dynamic>? _getEngines() => flutterTts?.getEngines;

  Future _speak(_newVoiceText) async {
    await flutterTts?.setVolume(volume!);
    await flutterTts?.setSpeechRate(rate!);
    await flutterTts?.setPitch(pitch!);
    await flutterTts?.setLanguage("de-De");

    if (_newVoiceText != null) {
      if (_newVoiceText.isNotEmpty) {
        await flutterTts?.speak(_newVoiceText);
      }
    }
  }

  Future _setAwaitOptions() async {
    await flutterTts?.awaitSpeakCompletion(true);
  }

  Future<int> _stop() async {
    var result = await flutterTts?.stop();
    return result;
  }

  Future _pause() async {
    var result = await flutterTts?.pause();
  }

}