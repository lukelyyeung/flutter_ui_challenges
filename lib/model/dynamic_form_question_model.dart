//TODO Question class Model
class Questions {
  Enum type;
  String question;
  dynamic answers;

  Questions(this.type, this.question, this.answers);
}

//TODO Validation & DisplayWidget
enum QuestionType {
  text,
  radio,
  checkbox,
  email,
  userName,
}

//TODO modify & add questionList Operation
class QuestionList {
  List<Questions> _questionList = [];

  void addQuestion(Questions candidate) {
    _questionList.add(candidate);
  }

  void removeQuestion(int index) {
    _questionList.removeAt(index);
  }

  List<Questions> get get => _questionList;
}
