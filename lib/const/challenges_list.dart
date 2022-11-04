import 'package:flutter/material.dart';
import 'package:ui_challenge/answers/animated_progressbutton_answer.dart';
import 'package:ui_challenge/answers/animated_tick_answer.dart';
import 'package:ui_challenge/challenges/animated_progressbutton_solution.dart.dart';

import '../base_page.dart';
import '../challenges/animated_tick_solution.dart';

class ChallengeItem {
  final WidgetBuilder solutionBuilder;
  final WidgetBuilder answerBuilder;

  ChallengeItem({required this.solutionBuilder, required this.answerBuilder});
}

Map<String, ChallengeItem> challengesBuilderMap = {
  'Animated Tick': ChallengeItem(
    solutionBuilder: (_) => const BasePage(
        title: AnimatedTickSolution.title, child: AnimatedTickSolution()),
    answerBuilder: (_) => const BasePage(
        title: AnimatedTickAnswer.title,
        child: Center(
          child: AnimatedTickAnswer(),
        )),
  ),
  'Animated Progress Button': ChallengeItem(
    solutionBuilder: (_) => const BasePage(
        title: AnimatedProgressButtonSolution.title,
        child: AnimatedProgressButtonSolution()),
    answerBuilder: (context) => const BasePage(
        title: AnimatedProgressButtonAnswer.title,
        child: AnimatedProgressButtonAnswer()),
  ),
};
