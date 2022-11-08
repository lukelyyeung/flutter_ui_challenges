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
    extends State<AnimatedProgressButtonAnswer> with TickerProviderStateMixin {
  late AnimationController _progressAniController;
  late AnimationController _toLoadController;
  late AnimationController _loadedController;
  late AnimationController _loadingController;
  late AnimationController _buttonWidthController;

  late Animation<double> progressAni;
  late Animation<double> buttonWidthAni;
  late Animation<double> heightAni;
  late Animation<double> strokeWidthAni;
  late Animation<Offset> uploadSlideAni;
  late Animation<double> uploadOpacity;
  late Animation<Offset> loadingSlideAni;
  late Animation<double> loadingOpacityAni;
  late Animation<Offset> loadedSlideAni;
  late Animation<double> loadedOpacityAni;
  late RenderBox buttonBox;
  double? _maxWidth = 280;
  final GlobalKey _buttonKey = GlobalKey();

  TextStyle tileButtonTStyle = const TextStyle(
      fontSize: 35, color: Colors.white, fontWeight: FontWeight.bold);

  @override
  void initState() {
    // TODO: implement initState

    _progressAniController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1500))
      ..addListener(() {
        if (_progressAniController.value > 0.1 &&
            _progressAniController.value < 0.90 &&
            _progressAniController.status == AnimationStatus.forward) {
          _toLoadController.forward();
          _loadingController.forward(from: 0.2);
        }
        if (_progressAniController.value > 0.95 &&
            _progressAniController.status == AnimationStatus.forward) {
          _loadedController.forward();
          _loadingController.animateTo(1.0,
              duration: const Duration(milliseconds: 200));
        }

        if (_progressAniController.value < 0.1 &&
            _progressAniController.status == AnimationStatus.reverse) {
          _toLoadController.reverse();
          _loadingController.animateTo(0.0,
              duration: const Duration(milliseconds: 200));
        }
        if (_progressAniController.value < 1.0 &&
            _progressAniController.value > 0.1 &&
            _progressAniController.status == AnimationStatus.reverse) {
          _loadedController.reverse();
          _loadingController.animateTo(0.6,
              duration: const Duration(milliseconds: 200));
        }
      });

    _toLoadController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 200));

    _buttonWidthController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 200));
    _loadedController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 200));
    _loadingController = AnimationController(
        vsync: this, duration: const Duration(microseconds: 5000));

    progressAni =
        Tween<double>(begin: 0, end: 100).animate(_progressAniController);

    strokeWidthAni =
        Tween<double>(begin: 11, end: 0).animate(_loadedController);

    uploadSlideAni =
        Tween<Offset>(begin: const Offset(0, 0), end: const Offset(0, -1))
            .animate(_toLoadController);

    uploadOpacity =
        Tween<double>(begin: 1.0, end: 0.0).animate(_toLoadController);

    loadingSlideAni = TweenSequence<Offset>([
      TweenSequenceItem(
          tween:
              Tween<Offset>(begin: const Offset(0, 1), end: const Offset(0, 0)),
          weight: 20),
      TweenSequenceItem(
          tween:
              Tween<Offset>(begin: const Offset(0, 0), end: const Offset(0, 0)),
          weight: 80),
      TweenSequenceItem(
          tween: Tween<Offset>(
              begin: const Offset(0, 0), end: const Offset(0, -1)),
          weight: 20),
    ]).animate(_loadingController);

    loadingOpacityAni = TweenSequence<double>([
      TweenSequenceItem(tween: Tween<double>(begin: 0.0, end: 1.0), weight: 20),
      TweenSequenceItem(tween: Tween<double>(begin: 1.0, end: 1.0), weight: 80),
      TweenSequenceItem(tween: Tween<double>(begin: 1.0, end: 0.0), weight: 20),
    ]).animate(_loadingController);

    loadedSlideAni =
        Tween<Offset>(begin: const Offset(0, 1), end: const Offset(0, 0))
            .animate(_loadedController);

    loadedOpacityAni =
        Tween<double>(begin: 0.0, end: 1.0).animate(_loadedController);

    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final RenderBox renderBox =
          _buttonKey.currentContext?.findRenderObject() as RenderBox;
      _maxWidth = renderBox.size.width;
    });
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _progressAniController.dispose();
    _loadedController.dispose();
    _loadingController.dispose();
    _toLoadController.dispose();
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
              if (_progressAniController.isCompleted) {
                _progressAniController.reverse();
                isToogle = true;
                return;
              }
              _progressAniController.forward();
              isToogle = false;
            },
            child: AnimatedBuilder(
              animation: _progressAniController,
              builder: (context, child) {
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  height: 80,
                  width: _progressAniController.value > 0.9 ? _maxWidth : 220,
                  child: CustomPaint(
                    painter: ProgressPainter(
                      progress: progressAni.value,
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
                              size: 45,
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
  double progress;
  double strokeWidth;

  ProgressPainter({
    required this.progress,
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
      ..arcToPoint(archEndLeft,
          radius: const Radius.circular(1), clockwise: false)
      ..lineTo(width - radius, height)
      ..arcToPoint(archEndRight,
          radius: const Radius.circular(1), clockwise: false)
      ..lineTo(radius, 0);
    // ..lineTo(width, 0);

    var pathMetrics = buttonPath.computeMetrics();
    var borderPath = pathMetrics.first;
    var progressPath =
        borderPath.extractPath(0, borderPath.length * progress / 100);

    canvas.drawPath(progressPath, borderPaint);
    canvas.drawPath(buttonPath, buttonPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return true;
  }
}
