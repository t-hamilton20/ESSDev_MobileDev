import 'dart:core';

class trivia_question {
  String question;
  String answer;
  double difficulty;

  trivia_question(this.question, this.answer, this.difficulty);

  String getAnswer() {
    return "The correct answer is " + answer;
  }
}
