import 'dart:math';

import 'package:flutter/material.dart';

class SuccessAnimation extends StatefulWidget {
  const SuccessAnimation({Key? key}) : super(key: key);

  @override
  State<SuccessAnimation> createState() => _SuccessAnimationState();
}

class _SuccessAnimationState extends State<SuccessAnimation> with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(duration: const Duration(milliseconds: 1000), vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    Animation<double> radius = TweenSequence<double>([
      TweenSequenceItem(tween: Tween<double>(begin: 0.0, end: 1), weight: 1),
      TweenSequenceItem(tween: Tween<double>(begin: 1, end: 1.2), weight: 1),
      TweenSequenceItem(tween: Tween<double>(begin: 1.2, end: 1), weight: 1),
    ]).animate(CurvedAnimation(parent: _animationController, curve: const Interval(0.0, 0.5, curve: Curves.ease)));
    Animation<double> width = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _animationController, curve: const Interval(0.65, 1, curve: Curves.easeInOut)));

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: 60,
          width: 60,
          child: AnimatedBuilder(
              animation: _animationController,
              builder: (context, _) {
                return CustomPaint(
                    painter: SuccessAnimationPainter(radiusFactor: radius.value, tickWidthFactor: width.value));
              }),
          // decoration:
          //     BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.green)),
        ),
        const SizedBox(height: 16),
        ElevatedButton(
            onPressed: () {
              if ([AnimationStatus.forward, AnimationStatus.completed].contains(_animationController.status)) {
                _animationController.reverse();
              } else {
                _animationController.forward();
              }
            },
            child: const Text("Toggle"))
      ],
    );
  }
}

class SuccessAnimationPainter extends CustomPainter {
  final double radiusFactor;
  final double tickWidthFactor;

  SuccessAnimationPainter({required this.radiusFactor, required this.tickWidthFactor});

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final dimension = min(size.height, size.width);
    final center = Offset(size.width / 2, size.height / 2);

    final path = Path()
      ..moveTo(dimension * .2, dimension * .55)
      ..lineTo(dimension * .4, dimension * .72)
      ..lineTo(dimension * .78, dimension * .3);

    final borderPaint = Paint()..color = Colors.green;

    canvas.drawArc(Rect.fromCircle(center: center, radius: dimension * radiusFactor / 2), 0, 2 * pi, true, borderPaint);

    final tickPathMetric = path.computeMetrics().first;

    final effectiveTickPath = tickPathMetric.extractPath(0, tickPathMetric.length * tickWidthFactor);

    if (tickWidthFactor > 0) {
      canvas.drawPath(effectiveTickPath, paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
