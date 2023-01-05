import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

//TODO multiSpot
//TODO closestSpot
//TODO indicatorAnimation
//TODO overlayAnimation
//TODO Vertical Index Scale

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
  Offset? anchorPoint;
  GlobalKey stickyKey = GlobalKey();
  RenderBox? chartBox;
  int? selectedIndex;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    opacityAni = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1000));
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

    List<double> sortedList = statistics.values.map((e) => (e)).toList()
      ..sort();
    double upperVal = sortedList[sortedList.length - 1].ceilToDouble();
    double lowerVal = sortedList[0].floorToDouble();
    double range = upperVal - lowerVal;
    List<double> colIndex =
        List.generate(7, (index) => lowerVal + (range / 6 * index));

    List<double> listOfPoints = List.generate(statistics.length, (index) {
      return (1 - ((statistics.values.elementAt(index) - lowerVal) / range));
    });

    Offset getClosestPoint(Offset anchorPoint, Size chartSize) {
      var result = anchorPoint;
      var closestDist = chartSize.width;

      for (var i = 0; i <= listOfPoints.length; i++) {
        var compareWidth = chartSize.width * i * 0.1;

        bool isCloser = (compareWidth - anchorPoint.dx) < closestDist;

        if (isCloser) {
          closestDist = (compareWidth - anchorPoint.dx).abs();
          var resultWidth = compareWidth;
          var resultHeight = listOfPoints[i] * chartSize.height;
          selectedIndex = i;
          result = Offset(resultWidth, resultHeight);
        }
      }

      return result;
    }

    void selectPoints(RenderBox chartBox,
        {DragUpdateDetails? dragUpdateDetails,
        TapDownDetails? tapDownDetails}) {
      if (dragUpdateDetails != null) {
        anchorPoint =
            getClosestPoint(dragUpdateDetails.localPosition, chartBox.size);
      }
      if (tapDownDetails != null) {
        anchorPoint =
            getClosestPoint(tapDownDetails.localPosition, chartBox.size);
      }

      var gloablLocalAnchorPoint = chartBox!.localToGlobal(anchorPoint!);
      var displayText = statistics.keys.elementAt(selectedIndex!);
      var displayVal = statistics.values.elementAt(selectedIndex!);

      hideOverlay();
      opacityAni.reset();
      opacityAni.forward();
      showOverLay(
        gloablLocalAnchorPoint,
        opacityAni,
        width,
        displayText,
        displayVal.toString(),
      );
    }

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
              return Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: boxConstraints.maxWidth * 0.05,
                        height: boxConstraints.maxHeight,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          verticalDirection: VerticalDirection.up,
                          children: <Widget>[
                            ...colIndex.asMap().entries.map((e) => Text(
                                e.value.toStringAsFixed(2),
                                style: const TextStyle(fontSize: 10))),
                          ],
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      SizedBox(
                        width: boxConstraints.maxWidth * 0.8,
                        child: GridPaper(
                          color: Colors.grey.withOpacity(0.2),
                          divisions: 5,
                          // subdivisions: 1,
                          child: Container(
                            key: stickyKey,
                            height: boxConstraints.maxHeight,
                            color: Colors.grey[50],
                            child: GestureDetector(
                              onPanUpdate: (dragUpdateDetails) {
                                final keyContext = stickyKey.currentContext;
                                chartBox =
                                    keyContext!.findRenderObject() as RenderBox;

                                setState(() {
                                  selectPoints(
                                    chartBox!,
                                    dragUpdateDetails: dragUpdateDetails,
                                  );
                                });
                              },
                              onTapDown: (tapDownDetails) {
                                final keyContext = stickyKey.currentContext;
                                chartBox =
                                    keyContext!.findRenderObject() as RenderBox;

                                setState(() {
                                  selectPoints(
                                    chartBox!,
                                    tapDownDetails: tapDownDetails,
                                  );
                                });
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
              );
            },
          ),
        ),
      ],
    );
  }

  void showOverLay(Offset anchorPoint, Animation<double> opacity,
      double pageWidth, String displayText, String displayVal) {
    final overlay = Overlay.of(context)!;
    bool isRightSide = anchorPoint.dx > (pageWidth * 0.5);
    entry1 = OverlayEntry(builder: (context) {
      return AnimatedPositioned(
        duration: const Duration(milliseconds: 100),
        // height: 110,
        // width: 150,
        top: isRightSide ? anchorPoint.dy - 100 : anchorPoint.dy + 10,
        left: isRightSide ? anchorPoint.dx - 140 : anchorPoint.dx + 10,

        child: Material(
          type: MaterialType.transparency,
          child: FadeTransition(
            opacity: opacity,
            child: BackdropFilter(
              filter: ImageFilter.blur(),
              child: Container(
                height: 80,
                width: 130,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.teal.shade100,
                      Colors.teal.shade200,
                      Colors.teal.shade300,
                      Colors.teal.shade400,
                      Colors.teal.shade500,
                    ],
                  ),
                  color: Colors.grey.shade100,
                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                ),
                child: FittedBox(
                  fit: BoxFit.cover,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Year: $displayText',
                          style: const TextStyle(fontSize: 8),
                        ),
                        Text(
                          'Qty: $displayVal',
                          style: const TextStyle(fontSize: 8),
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
  Offset? anchorPoint;
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

    Paint paintBody = Paint()
      ..color = Colors.green.withOpacity(0.1)
      ..strokeWidth = 7
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.fill;

    Paint paintDot = Paint()
      ..color = Colors.grey.shade800
      ..strokeWidth = 7
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.fill;

    Paint paintLine = Paint()
      ..color = Colors.green
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    Paint pPointBorder = Paint()
      ..color = Colors.green
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.fill;

    Paint pPointCore = Paint()
      ..color = Colors.white
      ..strokeWidth = 3
      ..style = PaintingStyle.fill;

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
    Path dotPath = Path()
      ..addOval(Rect.fromCenter(center: point1, width: 3, height: 3))
      ..addOval(Rect.fromCenter(center: point2, width: 3, height: 3))
      ..addOval(Rect.fromCenter(center: point3, width: 3, height: 3))
      ..addOval(Rect.fromCenter(center: point4, width: 3, height: 3))
      ..addOval(Rect.fromCenter(center: point5, width: 3, height: 3))
      ..addOval(Rect.fromCenter(center: point6, width: 3, height: 3))
      ..addOval(Rect.fromCenter(center: point7, width: 3, height: 3))
      ..addOval(Rect.fromCenter(center: point8, width: 3, height: 3))
      ..addOval(Rect.fromCenter(center: point9, width: 3, height: 3))
      ..addOval(Rect.fromCenter(center: point10, width: 3, height: 3));

    Path progressPath = Path()
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

    PathMetrics linePathMetric = progressPath.computeMetrics();
    PathMetric linePath = linePathMetric.first;
    Path lineProgessPath =
        linePath.extractPath(0, linePath.length * lineProgress);

    canvas.drawPath(bodyPath, paintBody);
    canvas.drawPath(lineProgessPath, paintLine);
    canvas.drawPath(dotPath, paintDot);

    if (anchorPoint != null) {
      Path clickPoint = Path()
        ..addOval(Rect.fromCenter(
          center: Offset(anchorPoint!.dx, anchorPoint!.dy),
          width: 15,
          height: 15,
        ));

      Path clickPointCore = Path()
        ..addOval(Rect.fromCenter(
          center: Offset(anchorPoint!.dx, anchorPoint!.dy),
          width: 5,
          height: 5,
        ));
      canvas.drawPath(clickPoint, pPointBorder);
      canvas.drawPath(clickPointCore, pPointCore);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
