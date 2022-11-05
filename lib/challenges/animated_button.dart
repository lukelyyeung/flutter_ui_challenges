import 'dart:math';

import 'package:flutter/material.dart';
import 'package:ui_challenge/widgets/after_layout.dart';

class AnimatedButton extends StatefulWidget {
  const AnimatedButton({Key? key}) : super(key: key);

  @override
  State<AnimatedButton> createState() => _AnimatedButtonState();
}

class _AnimatedButtonState extends State<AnimatedButton> with TickerProviderStateMixin {
  late final AnimationController _uploadAnimationController;
  var _isClose = false;
  var _buttonSize = Size.zero;
  late Widget _title = buildUploadTitle();

  @override
  void initState() {
    super.initState();
    _uploadAnimationController =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 1500));
  }

  @override
  void dispose() {
    _uploadAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Animation<double> progress =
        CurvedAnimation(parent: _uploadAnimationController, curve: Curves.easeInOut);

    return Container(
      width: double.maxFinite,
      color: Color(0xFFE3ECF9),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              AnimatedSwitcher(
                switchInCurve: Curves.easeInOut,
                switchOutCurve: Curves.easeInOut,
                duration: const Duration(milliseconds: 150),
                child: _isClose
                    ? SizedBox.shrink(key: ValueKey(_isClose))
                    : SizedBox(
                        key: ValueKey(_isClose),
                        height: _buttonSize.height + 5,
                        width: _buttonSize.width + 5,
                        child: AnimatedBuilder(
                            animation: _uploadAnimationController,
                            builder: (context, _) {
                              return CustomPaint(
                                  painter: OutBorderPainter(progress: progress.value));
                            }),
                      ),
              ),
              GestureDetector(
                onTap: () async {
                  _uploadAnimationController.value = 0;
                  setState(() {
                    _isClose = false;
                    _title = buildUploadingTitle();
                  });

                  await Future.delayed(const Duration(milliseconds: 250));

                  WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
                    await _uploadAnimationController.forward();

                    setState(() {
                      _title = buildUploadedTitle();
                      _isClose = true;
                    });
                  });
                },
                child: AfterLayout(
                  onLayout: (box) {
                    setState(() {
                      if (_buttonSize != box.size) {
                        _buttonSize = box.size;
                      }
                    });
                  },
                  child: AnimatedSize(
                    duration: const Duration(milliseconds: 250),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                      decoration: BoxDecoration(
                          color: const Color(0xFF275EFE), borderRadius: BorderRadius.circular(50)),
                      child: AnimatedSwitcher(
                          transitionBuilder: (child, animation) {
                            final isCurrentTitle = child == _title;
                            final offset = Tween<Offset>(
                                    begin: Offset(0, isCurrentTitle ? 1 : -1), end: Offset.zero)
                                .animate(animation);

                            return FadeTransition(
                                opacity: animation,
                                child: SlideTransition(position: offset, child: child));
                          },
                          duration: const Duration(milliseconds: 250),
                          child: _title),
                    ),
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget buildUploadTitle() {
    return Row(
        key: const ValueKey("upload"),
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: const [
          Icon(
            Icons.arrow_upward_rounded,
            size: 20,
            color: Colors.white,
          ),
          SizedBox(width: 12),
          Text("Upload",
              style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.w600))
        ]);
  }

  Widget buildUploadingTitle() {
    return const Text("Uploading",
        key: ValueKey("uploading"),
        style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.w600));
  }

  Widget buildUploadedTitle() {
    return const UploadedTitle();
  }
}

class OutBorderPainter extends CustomPainter {
  final double progress;

  OutBorderPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = Color(0xFF7497FE)
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final radius = size.height / 2;

    final path = Path()
      ..moveTo(radius + size.width * .2, 0)
      ..lineTo(radius, 0)
      ..arcToPoint(Offset(radius, size.height), radius: Radius.circular(radius), clockwise: false)
      ..lineTo(size.width - radius, size.height)
      ..arcToPoint(Offset(size.width - radius, 0),
          radius: Radius.circular(radius), clockwise: false)
      ..lineTo(radius, 0);

    final tickPathMetric = path.computeMetrics().first;

    final effectiveTickPath = tickPathMetric.extractPath(0, tickPathMetric.length * progress);

    if (progress > 0) {
      canvas.drawPath(effectiveTickPath, paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class UploadedTitle extends StatefulWidget {
  const UploadedTitle({Key? key}) : super(key: key);

  @override
  State<UploadedTitle> createState() => _UploadedTitleState();
}

class _UploadedTitleState extends State<UploadedTitle> with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(duration: const Duration(milliseconds: 500), vsync: this);
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final animation = CurvedAnimation(parent: _animationController, curve: Curves.easeInOut);

    return Row(
        key: const ValueKey("uploaded"),
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
              width: 20,
              height: 20,
              child: AnimatedBuilder(
                  animation: _animationController,
                  builder: (context, _) {
                    return CustomPaint(
                      painter: TickPainter(progress: animation.value),
                    );
                  })),
          const SizedBox(width: 12),
          const Text("Uploaded",
              style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.w600))
        ]);
  }
}

class TickPainter extends CustomPainter {
  final double progress;

  TickPainter({required this.progress});

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final dimension = min(size.height, size.width);

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..color = Colors.white
      ..strokeCap = StrokeCap.round;

    final path = Path()
      ..moveTo(0, .6 * dimension)
      ..lineTo(dimension * .35, dimension)
      ..lineTo(dimension, .1 * dimension);

    final pathMetric = path.computeMetrics().first;

    final effectivePath = pathMetric.extractPath(0, pathMetric.length * progress);

    if (progress > 0) {
      canvas.drawPath(effectivePath, paint);
    }
  }
}
