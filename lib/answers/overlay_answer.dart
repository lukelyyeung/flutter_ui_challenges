import 'package:flutter/material.dart';

class OverlayAnswerPage extends StatefulWidget {
  const OverlayAnswerPage({super.key});

  static const title = 'Overlay Answer';

  @override
  State<OverlayAnswerPage> createState() => _OverlayAnswerPageState();
}

class _OverlayAnswerPageState extends State<OverlayAnswerPage> {
  OverlayEntry? entry1;
  Offset? graphOffset;

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
                        Expanded(
                          flex: 1,
                          child: SizedBox(
                            height: boxConstraints.maxHeight,
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: const <Widget>[
                                Text('100'),
                                Text('80'),
                                Text('60'),
                                Text('40'),
                                Text('20'),
                                Text('0'),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 9,
                          child: Container(
                            // width: boxConstraints.maxWidth,
                            height: boxConstraints.maxHeight,
                            color: Colors.grey[50],
                            child: GestureDetector(
                              // onTap: () => showOverLay(),
                              onTapDown: (tapDownDetails) {
                                RenderBox box =
                                    context.findRenderObject() as RenderBox;

                                Offset point1 =
                                    Offset(width * 0.8 * 0.2, height * 0.3);
                                bool targetWidth =
                                    (tapDownDetails.localPosition.dx <
                                            point1.dx + 10) &&
                                        (tapDownDetails.localPosition.dx >
                                            point1.dx - 10);

                                if (targetWidth) {
                                  showOverLay(box.globalToLocal(
                                      tapDownDetails.globalPosition));
                                  print(tapDownDetails.localPosition);
                                }
                              },
                              child: CustomPaint(
                                painter: GraphPaint(),
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

        // SizedBox(
        //   height: height * 0.1,
        // ),
        // ElevatedButton.icon(
        //   style: ButtonStyle(
        //     shape: MaterialStateProperty.all(
        //       RoundedRectangleBorder(
        //         borderRadius: BorderRadius.circular(18.0),
        //         // side: BorderSide(color: Colors.red),
        //       ),
        //     ),
        //   ),
        //   onPressed: showOverLay,
        //   icon: const Icon(Icons.visibility),
        //   label: const Text('Show Overlay Button'),
        // )
      ],
    );
  }

  void showOverLay(Offset startingPoint) {
    final overlay = Overlay.of(context)!;
    entry1 = OverlayEntry(builder: (context) {
      return Positioned(
        height: 150,
        width: 150,
        top: startingPoint.dx,
        right: startingPoint.dy,
        child: GestureDetector(
          onTapDown: (tapDownDetails) {
            hideOverlay();
          },
          child: Container(
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
                    Text('Cat'),
                  ],
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
  @override
  void paint(Canvas canvas, Size size) {
    // TODO: implement paint
    double height = size.height;
    double width = size.width;
    Offset startingPoint = Offset(0, height / 2);
    Offset point1 = Offset(width * 0.2, height * 0.3);
    Offset point2 = Offset(width * 0.4, height * 0.7);
    Offset point3 = Offset(width * 0.6, height * 0.1);
    Offset point4 = Offset(width * 1.0, height * 0.0);
    Offset point5 = Offset(width, height);
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
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
