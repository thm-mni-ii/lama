import 'package:equatable/equatable.dart';

///A simple helper class that associates a subject with a grade.
///
///Author: K.Binder
class SubjectGradeRelation extends Equatable {
  final String subject;
  final int grade;

  SubjectGradeRelation(this.subject, this.grade);

  @override
  List<Object> get props => [subject, grade];
}
