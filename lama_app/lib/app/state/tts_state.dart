import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

/// States used by [TtsScreen] and [TtsBloc]
///
/// Author: A.Grishin
/// latest Changes: 28.05.2022
///

@immutable
abstract class TtsState {}

class GetLanguageState extends TtsState {
  Future<dynamic>? languages;
  GetLanguageState(this.languages);
}
// need
class InitTts extends TtsState {}

class PlayTtsState extends TtsState {}

class StopTtsState extends TtsState {}

class PauseTtsState extends TtsState {}

class TtsLoading extends TtsState {}

class TtsTextFieldEmpty extends TtsState {}

//need doing
class TtsLoaded extends TtsState {
  final String text;
  TtsLoaded( this.text );
  //@override
  //String get props => [text];
}

//class TtsDefaultState extends TtsState {}

// todo
// class TtsLoadedState extends TtsState {
//   bool prefDefaultTasksEnable;
//   TtsLoadedState(this.prefDefaultTasksEnable);
// }