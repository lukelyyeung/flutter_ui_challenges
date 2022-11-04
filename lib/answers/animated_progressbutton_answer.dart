import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

class AnimatedProgressButtonAnswer extends StatelessWidget {
  const AnimatedProgressButtonAnswer({super.key});

  static const title = 'Animated Progress Button Answer';

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return SizedBox(
      height: height,
      width: width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            height: 100,
            width: 300,
            child: CustomPaint(
              child: null,
              painter: ProgressPainter(),
            ),
          )
        ],
      ),
    );
  }
}

class ProgressPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    double height = size.height;
    double width = size.width;
    double radius = height / 2;

    Rect rectCL = Rect.fromCenter(
        center: Offset(height / 2, height / 2),
        width: radius * 2,
        height: radius * 2);
    Rect rectCR = Rect.fromCenter(
        center: Offset(width - (height / 2), height / 2),
        width: radius * 2,
        height: radius * 2);

    Paint borderPaint = Paint()
      ..color = Colors.grey.shade300
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round;

    Paint buttonPaint = Paint()
      ..color = Colors.teal
      ..style = PaintingStyle.fill;

    Path buttonPath = Path()
      ..moveTo(0, 0)
      ..addArc(rectCL, -pi * 0.5, -pi)
      ..lineTo(width - radius, height)
      ..addArc(rectCR, pi * 0.5, -pi)
      ..lineTo(radius, 0);

    Path extractedPath;

    var buttonPathMetrics = buttonPath.computeMetrics();
    List<Path> pathList = [];
    for (var PathMetric in buttonPathMetrics) {
      pathList.add(PathMetric.extractPath(0, PathMetric.length));
    }

    Path testPath =
        Path.combine(PathOperation.difference, pathList[0], pathList[1]);

    // Path extractedPath =
    //     buttonMetrics.first.extractPath(0, buttonPathLenght * 0.8);

    canvas.drawPath(buttonPath, buttonPaint);
    for (var i in pathList) {
      int index = pathList.indexOf(i);
      canvas.drawPath(pathList[index], borderPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return true;
  }
}
