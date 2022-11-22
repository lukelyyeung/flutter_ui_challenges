import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class OverlayAnswerPage extends StatefulWidget {
  const OverlayAnswerPage({super.key});

  static const title = 'Overlay Answer';

  @override
  State<OverlayAnswerPage> createState() => _OverlayAnswerPageState();
}

class _OverlayAnswerPageState extends State<OverlayAnswerPage> {
  OverlayEntry? entry1;
  Offset? graphOffset;
  bool toShowClickedSpot = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    entry1?.remove();
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

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        //** */ chart
        SizedBox(
          height: height * 0.3,
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
                            height: boxConstraints.maxHeight,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: const <Widget>[
                                Text('100%'),
                                Text('80%'),
                                Text('60%'),
                                Text('40%'),
                                Text('20%'),
                                Text('0%'),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Expanded(
                          flex: 19,
                          child: Container(
                            // width: boxConstraints.maxWidth,
                            height: boxConstraints.maxHeight,
                            color: Colors.grey[50],
                            child: GestureDetector(
                              // onTap: () => showOverLay(),
                              onTapDown: (tapDownDetails) {
                                List<Offset> listOfPoints = [
                                  Offset(
                                      boxConstraints.maxWidth * 0.8 * 0.2,
                                      boxConstraints.maxHeight *
                                          (1 - points[0])),
                                  Offset(
                                      boxConstraints.maxWidth * 0.8 * 0.4,
                                      boxConstraints.maxHeight *
                                          (1 - points[1])),
                                  Offset(
                                      boxConstraints.maxWidth * 0.8 * 0.6,
                                      boxConstraints.maxHeight *
                                          (1 - points[2])),
                                  Offset(
                                      boxConstraints.maxWidth * 0.8 * 0.8,
                                      boxConstraints.maxHeight *
                                          (1 - points[3])),
                                  Offset(
                                      boxConstraints.maxWidth * 0.8 * 1.0,
                                      boxConstraints.maxHeight *
                                          (1 - points[4])),
                                ];
                                RenderBox box =
                                    context.findRenderObject() as RenderBox;

                                Offset point1 = Offset(
                                    listOfPoints[0].dx, listOfPoints[0].dy);
                                bool targetWidth =
                                    (tapDownDetails.localPosition.dx <
                                            listOfPoints[0].dx + 5) &&
                                        (tapDownDetails.localPosition.dx >
                                            listOfPoints[0].dx - 5);
                                bool targetHeight =
                                    (tapDownDetails.localPosition.dy <
                                            listOfPoints[0].dy + 5) &&
                                        (tapDownDetails.localPosition.dy >
                                            listOfPoints[0].dy - 5);

                                if (targetWidth && targetHeight) {
                                  toShowClickedSpot = true;

                                  setState(() {});
                                  hideOverlay();
                                  showOverLay(box.globalToLocal(
                                      tapDownDetails.globalPosition));
                                }
                                if (!targetWidth && !targetHeight) {
                                  hideOverlay();
                                  setState(() {
                                    toShowClickedSpot = false;
                                  });
                                }
                              },
                              child: CustomPaint(
                                painter: GraphPaint(points, toShowClickedSpot),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(),
                  ],
                ),
              );
            },
          ),
        )
      ],
    );
  }

  void showOverLay(Offset startingPoint) {
    final overlay = Overlay.of(context)!;
    entry1 = OverlayEntry(builder: (context) {
      return Positioned(
        // height: 110,
        // width: 150,
        top: startingPoint.dx + 300,
        left: startingPoint.dy,
        child: Container(
          height: 100,
          width: 150,
          decoration: const BoxDecoration(
            color: Colors.amber,
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
  GraphPaint(this.points, this.toShowClickedSpot);
  bool toShowClickedSpot;
  List<double> points;

  @override
  void paint(Canvas canvas, Size size) {
    // TODO: implement paint
    double height = size.height;
    double width = size.width;
    Offset startingPoint = Offset(0, height / 2);
    Offset point1 = Offset(width * 0.2, height * (1 - points[0]));
    Offset point2 = Offset(width * 0.4, height * (1 - points[1]));
    Offset point3 = Offset(width * 0.6, height * (1 - points[2]));
    Offset point4 = Offset(width * 0.8, height * (1 - points[3]));
    Offset point5 = Offset(width * 1.0, height * (1 - points[4]));
    Offset endPoint = Offset(width, height);

    Paint body = Paint()
      ..color = Colors.green.withOpacity(0.1)
      ..strokeWidth = 10
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.fill;

    Paint border = Paint()
      ..color = Colors.green.shade300
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    Path clickPoint = Path()
      ..addOval(Rect.fromCenter(center: point1, width: 5, height: 5));

    Path path = Path()
      ..moveTo(startingPoint.dx, startingPoint.dy)
      ..lineTo(point1.dx, point1.dy)
      ..lineTo(point2.dx, point2.dy)
      ..lineTo(point3.dx, point3.dy)
      ..lineTo(point4.dx, point4.dy)
      ..lineTo(point5.dx, point5.dy)
      ..lineTo(endPoint.dx, endPoint.dy)
      ..lineTo(0, height)
      ..close();
    // ..arcToPoint(endPoint);

    canvas.drawPath(path, border);
    canvas.drawPath(path, body);
    if (toShowClickedSpot) {
      canvas.drawPath(clickPoint, border);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
