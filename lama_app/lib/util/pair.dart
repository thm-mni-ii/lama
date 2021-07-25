import 'package:equatable/equatable.dart';

class Pair<T1, T2> extends Equatable {
  final T1 a;
  final T2 b;
  Pair(this.a, this.b);

  @override
  List<Object> get props => [a, b];

  static Pair<String, String> fromJson(Map<String, dynamic> json) {
    return Pair(json['word'], json['translation']);
  }
}
