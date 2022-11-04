import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

class AnimatedTickAnswer extends StatefulWidget {
  const AnimatedTickAnswer({super.key});

  static const title = 'Animated Tick Answer';

  @override
  State<AnimatedTickAnswer> createState() => _AnimatedTickAnswerState();
}

class _AnimatedTickAnswerState extends State<AnimatedTickAnswer>
    with SingleTickerProviderStateMixin {
  late AnimationController _aniController;

  late Animation<double> tickAnimation;
  late Animation<double> doubleAnimation;

  @override
  void initState() {
    _aniController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1800));

    tickAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _aniController,
        curve: const Interval(0.55, 0.8, curve: Curves.easeInOutBack),
      ),
    );

    doubleAnimation = Tween<double>(begin: 0, end: 45).animate(CurvedAnimation(
        parent: _aniController..forward(),
        curve: const Interval(0.1, 0.5, curve: Curves.elasticInOut)));

    // doubleAnimation = Tween<double>(begin: 0, end: 45).animate(CurvedAnimation(
    //     parent: controller..forward(), curve: Curves.elasticInOut));

    super.initState();
  }

  @override
  void dispose() {
    _aniController.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedBuilder(
            animation: _aniController,
            builder: (context, child) {
              return Stack(
                children: [
                  SizedBox(
                    height: 100,
                    width: 100,
                    child: CustomPaint(
                      painter: CirclePainter(listener: doubleAnimation.value),
                    ),
                  ),
                  SizedBox(
                    height: 100,
                    width: 100,
                    child: CustomPaint(
                      painter: TickPainter(progress: tickAnimation.value),
                    ),
                  ),
                ],
              );
            },
          ),
          SizedBox(height: 30),
          ElevatedButton(
              onPressed: () {
                if (_aniController.isCompleted) {
                  _aniController.reverse();
                  return;
                }
                _aniController.forward();
              },
              child: Text('Toggle')),
        ],
      ),
    );
  }
}

class TickPainter extends CustomPainter {
  double progress;

  TickPainter({required this.progress});

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

  @override
  void paint(Canvas canvas, Size size) {
    double width = size.width;
    double height = size.height;
    Offset origin = Offset(width / 2, height / 2);
    double radius = min(width / 2, height / 2);

    Paint tickPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeJoin = StrokeJoin.round;

    Path tickPath = Path();

    // tickPath.computeMetrics().;
    tickPath.moveTo(size.width * 0.22, size.height * 0.56);
    tickPath.lineTo(size.width * 0.42, size.height * 0.76);
    tickPath.lineTo(size.width * 0.77, size.height * 0.35);
    // print(tickPathMetric.length);
    PathMetric tickPathMetric = tickPath.computeMetrics().first;

    Path tickPathProgress =
        tickPathMetric.extractPath(0, tickPathMetric.length * progress);

    if (progress > 0) canvas.drawPath(tickPathProgress, tickPaint);

    // canvas.drawPath(, );
  }
}

class CirclePainter extends CustomPainter {
  double listener;

  CirclePainter({required this.listener});

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

  @override
  void paint(Canvas canvas, Size size) {
    double width = size.width;
    double height = size.height;
    Offset origin = Offset(width / 2, height / 2);
    double radius = min(width / 2, height / 2);

    Paint circlePaint = Paint()
      ..color = Colors.green
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.fill;

    canvas.drawCircle(origin, listener, circlePaint);
    // canvas.drawPath(tickPath, tickPaint);
    // canvas.drawArc(Rect.fromCenter(center: origin, width: 100, height: 100),
    //     -0.5 * pi, listener.value / 15, false, paint);
    // // canvas.
  }
}
