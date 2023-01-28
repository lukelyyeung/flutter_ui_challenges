import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ui_challenge/answers/animated_progressbutton_answer.dart';
import 'package:ui_challenge/answers/animated_tick_answer.dart';
import 'package:ui_challenge/answers/dynamic_form_answer_preview.dart';
import 'package:ui_challenge/answers/overlay_answer.dart';
import 'package:ui_challenge/challenges/animated_progressbutton_solution.dart.dart';
import 'package:ui_challenge/challenges/overlay_solution_page.dart';
import 'package:ui_challenge/cubit/survey_cubit.dart';
import 'package:ui_challenge/model/dynamic_form_question_model.dart';

import '../answers/dynamic_form.answer.dart';
import '../base_page.dart';
import '../challenges/animated_tick_solution.dart';

class ChallengeItem {
  final WidgetBuilder solutionBuilder;
  final WidgetBuilder answerBuilder;
  final BuildContext? context;

  ChallengeItem(
      {required this.solutionBuilder,
      required this.answerBuilder,
      this.context});
}

Map<String, ChallengeItem> challengesBuilderMap = {
  'Animated Tick': ChallengeItem(
    solutionBuilder: (_) => BasePage(
        title: AnimatedTickSolution.title, child: const AnimatedTickSolution()),
    answerBuilder: (_) => BasePage(
        title: AnimatedTickAnswer.title, child: const AnimatedTickAnswer()),
  ),
  'Animated Progress Button': ChallengeItem(
    solutionBuilder: (_) => BasePage(
        title: AnimatedProgressButtonSolution.title,
        child: const AnimatedProgressButtonSolution()),
    answerBuilder: (context) => BasePage(
        title: AnimatedProgressButtonAnswer.title,
        child: const AnimatedProgressButtonAnswer()),
  ),
  'Overlay Page': ChallengeItem(
    solutionBuilder: (_) => BasePage(
        title: OverlaySolutionPage.title, child: const OverlaySolutionPage()),
    answerBuilder: (_) => BasePage(
        title: OverlayAnswerPage.title, child: const OverlayAnswerPage()),
  ),
  'Dynamic Form': ChallengeItem(
    solutionBuilder: (_) => BasePage(
      title: DynamicFormAnswerPage.title,
      child: const DynamicFormAnswerPage(),
    ),
    answerBuilder: (context) => BlocProvider(
      create: (context) => SurveyCubit(),
      child: BasePage(
        title: DynamicFormAnswerPage.title,
        // bottomBar: MultipleBottomNavBar(
        //   callBack: (value) => _getQuestionType(value),
        //   itemList: const [
        //     BottomNavigationBarItem(
        //         icon: Icon(Icons.text_fields_outlined), label: 'Text'),
        //     BottomNavigationBarItem(
        //         icon: Icon(Icons.radio_button_checked_outlined), label: 'Radio'),
        //     BottomNavigationBarItem(
        //         icon: Icon(Icons.check_box_outlined), label: 'Multiple'),
        //   ],
        // ),
        // action: [
        //   PopupMenuButton(itemBuilder: ((context) {
        //     return [
        //       const PopupMenuItem(onTap: null, child: Text('Text Question')),
        // action: [
        //   IconButton(
        //       onPressed: () {
        //         Navigator.push(
        //             context,
        //             MaterialPageRoute(
        //                 builder: (context) => const DynamicFormPreviewPage()));
        //       },
        //       icon: const Icon(Icons.preview_outlined)),
        // ],
        //       // PopupMenuItem(child: Text('option 2')),
        //       // PopupMenuItem(child: Text('option 3')),
        //     ];
        //   }))
        // ],
        child: const DynamicFormAnswerPage(),
      ),
    ),
  ),
};
