import 'package:equatable/equatable.dart';

///Utility class for associating two values.
///
///Used primarily for the "VocableTest" task.
///
///(The generic implementation may also replace the [SubjectGradeRelation] class in the future.)
///
///Author: K.Binder
class Pair<T1, T2> extends Equatable {
  final T1 a;
  final T2 b;
  Pair(this.a, this.b);

  @override
  List<Object> get props => [a, b];

  ///Returns a pair of strings parsed from json.
  ///
  ///Used for the parsing of the "VocableTest" task.
  static Pair<String, String> fromJson(Map<String, dynamic> json) {
    return Pair(json['word'], json['translation']);
  }
}
