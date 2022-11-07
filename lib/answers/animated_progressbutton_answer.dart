//TODO: streamline animationFlow, fix CustomPaintPath

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
  late Animation<Offset> uploadSlideAni;
  late Animation<double> uploadOpacity;
  late Animation<Offset> loadingSlideAni;
  late Animation<double> loadingOpacityAni;
  late Animation<Offset> loadedSlideAni;
  late Animation<double> loadedOpacityAni;

  Interval checkPointStart = const Interval(0.1, 0.3);
  Interval checkPointMid = const Interval(0.3, 0.7);
  Interval checkPointEnd = const Interval(0.7, 0.9);

  TextStyle tileButtonTStyle = const TextStyle(
      fontSize: 35, color: Colors.white, fontWeight: FontWeight.bold);

  @override
  void initState() {
    // TODO: implement initState

    _aniController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 3000));
    frame1Ani = Tween<double>(begin: 0, end: 100).animate(_aniController);

    frame2Ani = Tween<double>(begin: 0, end: 100).animate(CurvedAnimation(
      parent: _aniController,
      curve: const Interval(0.16, 0.30, curve: Curves.ease),
    ));
    frame3Ani = Tween<double>(begin: 0, end: 100).animate(CurvedAnimation(
      parent: _aniController,
      curve: const Interval(0.31, 0.70, curve: Curves.ease),
    ));
    widthAni = Tween<double>(begin: 230, end: 270).animate(CurvedAnimation(
      parent: _aniController..forward(),
      curve: const Interval(0.70, 0.875, curve: Curves.elasticInOut),
    ));

    strokeWidthAni = Tween<double>(begin: 11, end: 0).animate(CurvedAnimation(
      parent: _aniController..forward(),
      curve: const Interval(0.70, 0.8, curve: Curves.easeInOut),
    ));
    uploadSlideAni =
        Tween<Offset>(begin: const Offset(0, 0), end: const Offset(0, -1))
            .animate(CurvedAnimation(
      parent: _aniController,
      curve: const Interval(0.25, 0.35, curve: Curves.easeIn),
    ));
    uploadOpacity = Tween<double>(begin: 1.0, end: 0.0).animate(CurvedAnimation(
      parent: _aniController..forward(),
      curve: const Interval(0.25, 0.35, curve: Curves.ease),
    ));
    loadingSlideAni = TweenSequence<Offset>([
      TweenSequenceItem(
          tween:
              Tween<Offset>(begin: const Offset(0, 1), end: const Offset(0, 0))
                  .chain(CurveTween(curve: Curves.easeIn)),
          weight: 30),
      TweenSequenceItem(
          tween:
              Tween<Offset>(begin: const Offset(0, 0), end: const Offset(0, 0)),
          weight: 60),
      TweenSequenceItem(
          tween: Tween<Offset>(
              begin: const Offset(0, 0), end: const Offset(0, -1)),
          weight: 10),
    ]).animate(CurvedAnimation(
        parent: _aniController..forward(), curve: const Interval(0.30, 0.80)));

    loadingOpacityAni = TweenSequence<double>([
      TweenSequenceItem(
          tween: Tween<double>(begin: 0.0, end: 1.0)
              .chain(CurveTween(curve: Curves.easeIn)),
          weight: 20),
      TweenSequenceItem(tween: Tween<double>(begin: 1.0, end: 1.0), weight: 50),
      TweenSequenceItem(tween: Tween<double>(begin: 1.0, end: 0.0), weight: 30),
    ]).animate(CurvedAnimation(
        parent: _aniController..forward(), curve: const Interval(0.35, 0.85)));

    loadedSlideAni =
        Tween<Offset>(begin: const Offset(0, 1), end: const Offset(0, 0))
            .animate(CurvedAnimation(
                parent: _aniController..forward(),
                curve: const Interval(0.75, 0.9, curve: Curves.easeIn)));

    loadedOpacityAni = Tween<double>(begin: 0.0, end: 1.0)
        .chain(CurveTween(curve: Curves.easeIn))
        .animate(CurvedAnimation(
            parent: _aniController..forward(),
            curve: const Interval(0.80, 0.90, curve: Curves.easeIn)));

    super.initState();
  }

  @override
  void dispose() {
    _aniController.dispose();
    super.dispose();
  }

  bool isToogle = false;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Container(
      color: Colors.black87,
      height: height,
      width: width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          InkWell(
            onTap: () {
              if (_aniController.isCompleted) {
                _aniController.reverse();
                isToogle = true;
                return;
              }
              _aniController.forward();
              isToogle = false;
            },
            child: AnimatedBuilder(
              animation: _aniController,
              builder: (context, child) {
                return Container(
                  height: 80,
                  width: widthAni.value,
                  child: CustomPaint(
                    painter: ProgressPainter(
                      frame1Progress: frame1Ani.value,
                      frame2Progress: frame2Ani.value,
                      frame3Progress: frame3Ani.value,
                      strokeWidth: strokeWidthAni.value,
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        WordTransition(
                          opacityAni: uploadOpacity,
                          slidingAni: uploadSlideAni,
                          widgetList: <Widget>[
                            const Icon(
                              Icons.arrow_upward,
                              size: 55,
                              color: Colors.white,
                            ),
                            Text(
                              'Upload',
                              style: tileButtonTStyle,
                            ),
                          ],
                        ),
                        WordTransition(
                          opacityAni: loadingOpacityAni,
                          slidingAni: loadingSlideAni,
                          widgetList: <Widget>[
                            Text(
                              'Uploading',
                              style: tileButtonTStyle,
                            ),
                          ],
                        ),
                        WordTransition(
                            opacityAni: loadedOpacityAni,
                            slidingAni: loadedSlideAni,
                            widgetList: <Widget>[
                              Text(
                                'Uploaded',
                                style: tileButtonTStyle,
                              )
                            ])
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class WordTransition extends StatelessWidget {
  const WordTransition(
      {Key? key,
      required this.opacityAni,
      required this.slidingAni,
      required this.widgetList})
      : super(key: key);

  final Animation<double> opacityAni;
  final Animation<Offset> slidingAni;
  final List<Widget> widgetList;

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: opacityAni,
      child: SlideTransition(
        textDirection: TextDirection.rtl,
        position: slidingAni,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: widgetList,
        ),
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
    double height = size.height;
    double width = size.width;
    double radius = height / 2;
    Offset startPoint = Offset(radius + (width * 0.1), 0);
    Offset archEndLeft = Offset(radius, height);
    Offset archEndRight = Offset(width - radius, 0);

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
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.butt;

    Paint buttonPaint = Paint()
      ..color = Colors.teal
      ..style = PaintingStyle.fill;
    // ..strokeWidth = strokeSize;

    Path buttonPath = Path()
      ..moveTo(startPoint.dx, startPoint.dy)
      ..lineTo(radius, 0)
      ..arcToPoint(archEndLeft, radius: Radius.circular(1), clockwise: false)
      ..lineTo(width - radius, height)
      ..arcToPoint(archEndRight, radius: Radius.circular(1), clockwise: false)
      ..lineTo(radius, 0);
    // ..lineTo(width, 0);

    var PathMetrics = buttonPath.computeMetrics();
    var borderPath = PathMetrics.first;
    var progressPath =
        borderPath.extractPath(0, borderPath.length * frame1Progress / 100);

    canvas.drawPath(progressPath, borderPaint);
    canvas.drawPath(buttonPath, buttonPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return true;
  }
}
