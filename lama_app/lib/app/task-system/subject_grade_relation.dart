import 'package:equatable/equatable.dart';

class SubjectGradeRelation extends Equatable {
  final String subject;
  final int grade;

  SubjectGradeRelation(this.subject, this.grade);

  @override
  List<Object> get props => [subject, grade];
}
