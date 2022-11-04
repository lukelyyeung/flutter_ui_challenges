import 'package:flutter/material.dart';
import 'package:ui_challenge/answer_page.dart';
import 'package:ui_challenge/challenges/animated_tick_solution.dart';

Map<String, Widget Function(BuildContext)> pageRoute = {
  AnimatedTickSolution.title: (context) => const AnimatedTickSolution(),
};

Map<String, String> pageMap = {};
