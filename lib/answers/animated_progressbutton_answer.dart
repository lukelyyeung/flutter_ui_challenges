import 'dart:math';

import 'package:flutter/material.dart';

class AnimatedProgressButtonAnswer extends StatefulWidget {
  const AnimatedProgressButtonAnswer({super.key});

  static const title = 'Animated Progress Button Answer';

  @override
  State<AnimatedProgressButtonAnswer> createState() =>
      _AnimatedProgressButtonAnswerState();
}

class _AnimatedProgressButtonAnswerState
    extends State<AnimatedProgressButtonAnswer>
    with SingleTickerProviderStateMixin {
  late AnimationController _aniController;
  late Animation<double> frame1Ani;
  late Animation<double> frame2Ani;
  late Animation<double> frame3Ani;
  late Animation<double> widthAni;
  late Animation<double> heightAni;
  late Animation<double> strokeWidthAni;
  @override
  void initState() {
    // TODO: implement initState
    _aniController =
        AnimationController(vsync: this, duration: const Duration(seconds: 3));
    frame1Ani = Tween<double>(begin: 0, end: 100).animate(CurvedAnimation(
        parent: _aniController..forward(),
        curve: const Interval(0.0, 0.20, curve: Curves.ease)));
    frame2Ani = Tween<double>(begin: 0, end: 100).animate(CurvedAnimation(
        parent: _aniController..forward(),
        curve: const Interval(0.20, 0.50, curve: Curves.ease)));
    frame3Ani = Tween<double>(begin: 0, end: 100).animate(CurvedAnimation(
        parent: _aniController..forward(),
        curve: const Interval(0.50, 0.80, curve: Curves.ease)));
    widthAni = Tween<double>(begin: 220, end: 250).animate(CurvedAnimation(
        parent: _aniController..forward(),
        curve: const Interval(0.75, 1.0, curve: Curves.elasticInOut)));

    strokeWidthAni = Tween<double>(begin: 6, end: 0).animate(CurvedAnimation(
        parent: _aniController..forward(),
        curve: const Interval(0.65, 0.90, curve: Curves.easeInOut)));

    super.initState();
  }

  @override
  void dispose() {
    _aniController.dispose();
    super.dispose();
  }

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
          Stack(
            alignment: Alignment.center,
            children: [
              AnimatedBuilder(
                animation: frame1Ani,
                builder: (context, child) {
                  return SizedBox(
                    height: 100 - 10,
                    width: widthAni.value - 10,
                    child: CustomPaint(
                      painter: ProgressPainter(
                        frame1Progress: frame1Ani.value,
                        frame2Progress: frame2Ani.value,
                        frame3Progress: frame3Ani.value,
                        strokeWidth: strokeWidthAni.value,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(
                            Icons.arrow_upward,
                            size: 45,
                            color: Colors.white,
                          ),
                          Text(
                            'Upload',
                            style: TextStyle(
                                fontSize: 25,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 30),
          ElevatedButton(
              onPressed: () {
                if (_aniController.isCompleted) {
                  _aniController.reverse();
                  return;
                }
                _aniController.forward();
              },
              child: const Text('Toggle'))
        ],
      ),
    );
  }
}

class ProgressPainter extends CustomPainter {
  double frame1Progress;
  double frame2Progress;
  double frame3Progress;
  double strokeWidth;

  ProgressPainter({
    required this.frame1Progress,
    required this.frame2Progress,
    required this.frame3Progress,
    required this.strokeWidth,
  });
  @override
  void paint(Canvas canvas, Size size) {
    double height = size.height - 10;
    double width = size.width - 10;
    double radius = height / 2;
    Offset startPoint = Offset(radius + (width * 0.1), 0);

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
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.butt;

    Paint buttonPaint = Paint()
      ..color = Colors.teal
      ..style = PaintingStyle.fill;
    // ..strokeWidth = strokeSize;

    Path buttonPath = Path()
      ..moveTo(startPoint.dx, startPoint.dy)
      ..lineTo(radius, 0)
      ..addArc(rectCL, -pi * 0.5, -pi)
      ..lineTo(width - radius, height)
      ..addArc(rectCR, pi * 0.5, -pi)
      ..lineTo(radius, 0);

    var buttonPathMetrics = buttonPath.computeMetrics();
    var pathList = buttonPathMetrics.toList();
    var progressList = [frame1Progress, frame2Progress, frame3Progress];
    var drawPathList = List.generate(pathList.length, (index) => Path());

    for (var i = 0; i < drawPathList.length; i++) {
      drawPathList[i] = pathList[i]
          .extractPath(0, pathList[i].length * (progressList[i] / 100));
    }

    canvas.drawPath(buttonPath, buttonPaint);

    for (var i = 0; i < drawPathList.length; i++) {
      if (progressList[i] >= 1) {
        canvas.drawPath(drawPathList[i], borderPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return true;
  }
}
