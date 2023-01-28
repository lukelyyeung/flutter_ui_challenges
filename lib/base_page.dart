import 'package:flutter/material.dart';

class BasePage extends StatelessWidget {
  final Widget child;
  final String title;
  List<Widget>? action;
  Widget? fab;
  Widget? bottomBar;

  BasePage({
    Key? key,
    required this.child,
    required this.title,
    this.action,
    this.fab,
    this.bottomBar,
  });

  // static BasePage? of(BuildContext context) {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: action,
        title: Text(title),
        elevation: 0,
        backgroundColor: Colors.teal.withOpacity(0.85),
      ),
      floatingActionButton: fab,
      bottomNavigationBar: bottomBar,
      body: child,
    );
  }
}
