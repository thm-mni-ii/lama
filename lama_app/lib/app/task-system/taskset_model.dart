class Taskset {
  String name;
  String subject;
  int grade;

  Taskset.fromJson(Map<String, dynamic> json)
      : name = json['taskset_name'],
        subject = json['taskset_subject'],
        grade = json['taskset_grade'];
}
