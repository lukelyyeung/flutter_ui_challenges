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
  List<Questions> _questionList = [];

  // void addQuestion(Questions candidate) {
  //   _questionList.add(candidate);
  // }

  // void removeQuestion(int index) {
  //   _questionList.removeAt(index);
  // }
  // QuestionList.fromJson(){

  // }

  List<Questions> get get {
    return List.unmodifiable(_questionList);
  }
}

//** Abstract class */
class Questions {
  final int id;
  final Enum type;
  final String question;
  final dynamic answerOptions;

  Questions(this.id, this.type, this.question, this.answerOptions);
}

//** String Question */
class TextQuestion implements Questions {
  @override
  final int id;
  @override
  final Enum type;
  @override
  final String question;
  @override
  String? answerOptions;

  TextQuestion(this.id, this.type, this.question);
}

//** Radio Question */
class RadioQuestion implements Questions {
  @override
  final int id;
  @override
  final Enum type;
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
  final Enum type;
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
  final Enum type;
  @override
  final String question;
  @override
  final List<String> answerOptions;

  MultipleChoiceQuestion(this.id, this.type, this.question, this.answerOptions);
}
