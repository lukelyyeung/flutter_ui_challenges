import 'package:flutter/material.dart';

typedef OnLayout = Function(RenderBox box);

class AfterLayout extends StatefulWidget {
  final Widget child;
  final OnLayout onLayout;
  const AfterLayout({Key? key, required this.child, required this.onLayout}) : super(key: key);

  @override
  State<AfterLayout> createState() => _AfterLayoutState();
}

class _AfterLayoutState extends State<AfterLayout> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final box = context.findRenderObject() as RenderBox;
      widget.onLayout(box);
    });
  }

  @override
  void didUpdateWidget(covariant AfterLayout oldWidget) {
    super.didUpdateWidget(oldWidget);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final box = context.findRenderObject() as RenderBox;
      widget.onLayout(box);
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
