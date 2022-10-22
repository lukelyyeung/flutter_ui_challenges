import 'package:flutter/material.dart';
import 'package:ui_challenge/challenges/success_animation.dart';
import 'package:ui_challenge/base_page.dart';

class ChallengeItem {
  final String name;
  final WidgetBuilder builder;

  ChallengeItem({required this.name, required this.builder});
}

void main() {
  runApp(const MyApp());
}

final List<ChallengeItem> challenges = [
  ChallengeItem(
      name: 'Success Animation',
      builder: (_) =>
          const BasePage(title: 'Success Animation', child: Center(child: SuccessAnimation()))),
];

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView(
        children: challenges.map((item) {
          return ListTile(
            title: Text(item.name),
            onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: item.builder)),
          );
        }).toList(),
      ),
    );
  }
}
