///This file contains the Basic Task class with its factory Method and all Task subtypes
///To create a new Task subtype create a class that extends Task and add it to the factory method in Task

class Task {
  factory Task.fromJson(Map<String, dynamic> json) {
    String taskType = json['task_type'];
    switch (taskType) {
      case "4Cards":
        return Task4Cards(taskType, json['task_reward'], json['question'],
            json['right_answer'], List<String>.from(json['wrong_answers']));
      default:
        return null;
    }
  }
  String type;
  int reward;
  String question;
  Task(this.type, this.reward, this.question);
}

class Task4Cards extends Task {
  String rightAnswer;
  List<String> wrongAnswers;

  Task4Cards(String taskType, int reward, String question, this.rightAnswer,
      this.wrongAnswers)
      : super(taskType, reward, question);
}
