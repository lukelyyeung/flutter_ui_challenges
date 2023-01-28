//TODO Validation & DisplayWidget
import 'dart:core';

import 'package:flutter/material.dart';

enum QuestionType {
  text,
  radio,
  checkbox,
  email,
  userName,
  title,
}

//TODO modify & add questionList Operation
class QuestionList {
  final List<Questions> _questionList = [];
  final Map<int, QuestionType> _questionMap = {
    1: QuestionType.text,
    2: QuestionType.radio,
    3: QuestionType.checkbox,
  };

  // void addQuestion(Questions candidate) {
  //   _questionList.add(candidate);
  // }

  // void removeQuestion(int index) {
  //   _questionList.removeAt(index);
  // }
  // QuestionList.fromJson(){

  // }

  Map<int, QuestionType> get map {
    return _questionMap;
  }

  List<Questions> get get {
    return List.unmodifiable(_questionList);
  }
}

//** Abstract class */
class Questions {
  final int id;
  final QuestionType type;
  final String question;
  final List<String>? answerOptions;

  Questions(this.id, this.type, this.question, this.answerOptions);
}

//** String Question */
class TextQuestion implements Questions {
  @override
  final int id;
  @override
  final QuestionType type;
  @override
  final String question;
  @override
  List<String>? answerOptions;

  TextQuestion(this.id, this.type, this.question);
}

//** Radio Question */
class RadioQuestion implements Questions {
  @override
  final int id;
  @override
  final QuestionType type;
  @override
  final String question;
  @override
  final List<String> answerOptions;

  RadioQuestion(this.id, this.type, this.question, this.answerOptions);
}

//** Checkbox Question */
class CheckboxQuestion implements Questions {
  @override
  final int id;
  @override
  final QuestionType type;
  @override
  final String question;
  @override
  final List<String> answerOptions;

  CheckboxQuestion(this.id, this.type, this.question, this.answerOptions);
}

//** Multiplechoice Question */
class MultipleChoiceQuestion implements Questions {
  @override
  final int id;
  @override
  final QuestionType type;
  @override
  final String question;
  @override
  final List<String> answerOptions;

  MultipleChoiceQuestion(this.id, this.type, this.question, this.answerOptions);
}
