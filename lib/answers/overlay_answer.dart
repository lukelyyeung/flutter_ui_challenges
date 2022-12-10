import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

//TODO multiSpot
//TODO closestSpot
//TODO indicatorAnimation
//TODO overlayAnimation
//TODO

class OverlayAnswerPage extends StatefulWidget {
  const OverlayAnswerPage({super.key});

  static const title = 'Overlay Answer';

  @override
  State<OverlayAnswerPage> createState() => _OverlayAnswerPageState();
}

class _OverlayAnswerPageState extends State<OverlayAnswerPage>
    with TickerProviderStateMixin {
  OverlayEntry? entry1;
  Offset? graphOffset;
  bool toShowClickedSpot = false;
  late final AnimationController opacityAni;
  late final AnimationController lineAni;
  late Offset anchorPoint = Offset(0, 0);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    opacityAni = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    lineAni = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1500))
      ..addListener(() {
        setState(() {});
      })
      ..forward()
      ..repeat();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    entry1?.remove();
    opacityAni.dispose();
    lineAni.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    List<double> points = [
      0.3,
      0.6,
      0.2,
      0.8,
      1.0,
    ];

    //https://www.oberlo.com/statistics/how-many-people-have-smartphones
    Map<String, double> statistics = {
      '2016': 3.7,
      '2017': 4.4,
      '2018': 5.1,
      '2019': 5.6,
      '2020': 5.9,
      '2021': 6.3,
      '2022': 6.6,
      '2023': 6.8,
      '2024': 7.1,
      '2025': 7.3,
      '2026': 7.5,
    };

    List<double> listOfPoints = List.generate(statistics.length, (index) {
      return (1 - ((statistics.values.elementAt(index) - 3.2) / 4.8));
    });

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text(
          'No. of Smartphone Users Worldwide (2016-2026)',
          style: TextStyle(decoration: TextDecoration.underline),
        ),
        const SizedBox(height: 10),
        //** */ chart
        SizedBox(
          height: height * 0.25,
          width: width,
          child: LayoutBuilder(
            builder: (context, boxConstraints) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Flexible(
                          flex: 3,
                          child: SizedBox(
                            height: boxConstraints.maxHeight - 30,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: const <Widget>[
                                Text('8.0'),
                                Text('7.2'),
                                Text('6.4'),
                                Text('5.6'),
                                Text('4.8'),
                                Text('4.0'),
                                Text('3.2'),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Expanded(
                          flex: 19,
                          child: GridPaper(
                            color: Colors.grey.withOpacity(0.2),
                            divisions: 5,
                            // subdivisions: 1,
                            child: Container(
                              // width: boxConstraints.maxWidth,
                              height: boxConstraints.maxHeight - 30,
                              color: Colors.grey[50],
                              child: GestureDetector(
                                onTapDown: (tapDownDetails) {
                                  anchorPoint = tapDownDetails.globalPosition;
                                  setState(() {
                                    if (entry1 != null) {
                                      hideOverlay();
                                      opacityAni.reverse();
                                    } else {
                                      showOverLay(anchorPoint, opacityAni);
                                      opacityAni.forward();
                                    }
                                  });
                                  // listOfPoints = getPoints(boxConstraints);
                                  // RenderBox box =
                                  //     context.findRenderObject() as RenderBox;

                                  // bool targetWidth =
                                  //     (tapDownDetails.localPosition.dx <
                                  //             listOfPoints[0].dx + 5) &&
                                  //         (tapDownDetails.localPosition.dx >
                                  //             listOfPoints[0].dx - 5);
                                  // bool targetHeight =
                                  //     (tapDownDetails.localPosition.dy <
                                  //             listOfPoints[0].dy + 5) &&
                                  //         (tapDownDetails.localPosition.dy >
                                  //             listOfPoints[0].dy - 5);

                                  // if (targetWidth && targetHeight) {
                                  //   toShowClickedSpot = true;
                                  //
                                  //   setState(() {
                                  //     hideOverlay();
                                  //     Offset anchorPoint = box.globalToLocal(
                                  //         tapDownDetails.globalPosition);
                                  //     opacityAni.forward();
                                  //     showOverLay(anchorPoint, opacityAni);
                                  //   });
                                  // }
                                  // if (!targetWidth && !targetHeight) {
                                  //   hideOverlay();
                                  //   setState(() {
                                  //     opacityAni.reverse();
                                  //     toShowClickedSpot = false;
                                  //   });
                                  // }
                                },
                                child: CustomPaint(
                                  painter: GraphPaint(
                                      listOfPoints, anchorPoint, lineAni.value),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.end,
                    //   children: <Widget>[
                    //     ...statistics.keys
                    //         .map((e) => Text(
                    //               e,
                    //               style: const TextStyle(fontSize: 10),
                    //             ))
                    //         .toList(),
                    //   ],
                    // ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  void showOverLay(Offset anchorPoint, Animation<double> opacity) {
    final overlay = Overlay.of(context)!;
    entry1 = OverlayEntry(builder: (context) {
      double width = MediaQuery.of(context).size.width;
      return AnimatedPositioned(
        duration: const Duration(milliseconds: 100),
        // height: 110,
        // width: 150,
        top: anchorPoint.dy + 30,
        left: (anchorPoint.dx > width * 0.65)
            ? (anchorPoint.dx - 80)
            : (anchorPoint.dx + 30),
        child: Material(
          type: MaterialType.transparency,
          child: FadeTransition(
            opacity: opacity,
            child: BackdropFilter(
              filter: ImageFilter.blur(),
              child: Container(
                height: 100,
                width: 100,
                decoration: const BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                child: FittedBox(
                  fit: BoxFit.cover,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      children: const <Widget>[
                        Text(
                          'Cat',
                          style: TextStyle(fontSize: 10),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    });
    overlay.insert(entry1!);
  }

  void hideOverlay() {
    if (entry1 != null) {
      entry1?.remove();
      entry1 = null;
    }
  }
}

class GraphPaint extends CustomPainter {
  GraphPaint(this.points, this.anchorPoint, this.lineProgress);
  Offset anchorPoint;
  List<double> points;
  double lineProgress;

  @override
  void paint(Canvas canvas, Size size) {
    // TODO: implement paint
    double height = size.height;
    double width = size.width;
    Offset startingPoint = Offset(0, height * points[0]);
    Offset point1 = Offset(width * 0.1, height * points[1]);
    Offset point2 = Offset(width * 0.2, height * points[2]);
    Offset point3 = Offset(width * 0.3, height * points[3]);
    Offset point4 = Offset(width * 0.4, height * points[4]);
    Offset point5 = Offset(width * 0.5, height * points[5]);
    Offset point6 = Offset(width * 0.6, height * points[6]);
    Offset point7 = Offset(width * 0.7, height * points[7]);
    Offset point8 = Offset(width * 0.8, height * points[8]);
    Offset point9 = Offset(width * 0.9, height * points[9]);
    Offset point10 = Offset(width * 1.0, height * points[10]);

    Offset endPoint = Offset(width, height);

    Paint body = Paint()
      ..color = Colors.green.withOpacity(0.1)
      ..strokeWidth = 7
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.fill;

    Paint border = Paint()
      ..color = Colors.green.shade300
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    Offset getNearestPoint(anchorPoint) {
      print(anchorPoint);
      return Offset(0, 0);
    }

    // nearestClickPoint(anchorPoint);
    // ;

    Path clickPoint = Path()
      ..addOval(Rect.fromCenter(center: anchorPoint, width: 5, height: 5));

    Path bodyPath = Path()
      ..moveTo(startingPoint.dx, startingPoint.dy)
      ..lineTo(point1.dx, point1.dy)
      ..lineTo(point2.dx, point2.dy)
      ..lineTo(point3.dx, point3.dy)
      ..lineTo(point4.dx, point4.dy)
      ..lineTo(point5.dx, point5.dy)
      ..lineTo(point6.dx, point6.dy)
      ..lineTo(point7.dx, point7.dy)
      ..lineTo(point8.dx, point8.dy)
      ..lineTo(point9.dx, point9.dy)
      ..lineTo(point10.dx, point10.dy)
      ..lineTo(endPoint.dx, endPoint.dy)
      ..lineTo(0, height)
      ..close();
    // ..arcToPoint(endPoint);

    Path borderPath = Path()
      ..moveTo(startingPoint.dx, startingPoint.dy)
      ..lineTo(point1.dx, point1.dy)
      ..lineTo(point2.dx, point2.dy)
      ..lineTo(point3.dx, point3.dy)
      ..lineTo(point4.dx, point4.dy)
      ..lineTo(point5.dx, point5.dy)
      ..lineTo(point6.dx, point6.dy)
      ..lineTo(point7.dx, point7.dy)
      ..lineTo(point8.dx, point8.dy)
      ..lineTo(point9.dx, point9.dy)
      ..lineTo(point10.dx, point10.dy);

    PathMetrics linePathMetric = borderPath.computeMetrics();
    PathMetric linePath = linePathMetric.first;
    Path lineProgessPath =
        linePath.extractPath(0, linePath.length * lineProgress);

    canvas.drawPath(lineProgessPath, border);
    canvas.drawPath(bodyPath, body);

    canvas.drawPath(clickPoint, border);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
