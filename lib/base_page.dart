import 'package:flutter/material.dart';

class BasePage extends StatelessWidget {
  final Widget child;
  final String title;
  List<Widget>? action = [];
  BasePage({Key? key, required this.child, required this.title, this.action})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: action,
        title: Text(title),
        elevation: 0,
        backgroundColor: Colors.teal.withOpacity(0.85),
      ),
      body: child,
    );
  }
}
