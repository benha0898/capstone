import 'package:CapstoneProject/models/generated_question.dart';

class GeneratedDeck {
  List<GeneratedQuestion> questions;
  bool completed = false;

  GeneratedDeck({questions})
      : this.questions = questions ?? List<GeneratedQuestion>();

  void addQuestion(GeneratedQuestion question) {
    questions.add(question);
  }
}
