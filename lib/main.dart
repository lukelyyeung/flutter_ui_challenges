import 'package:flutter/material.dart';
import 'package:ui_challenge/answer_page.dart';
import 'package:ui_challenge/challenges/animated_button.dart';
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
      name: 'Animated Ticket',
      builder: (_) => const BasePage(
          title: 'Success Animation',
          child: Center(child: SuccessAnimation()))),
  ChallengeItem(
      name: 'Animated Button',
      builder: (_) => const BasePage(
          title: 'Animated Button',
          child: Center(child: AnimatedButton()))),
  ChallengeItem(
      name: 'Answer Page',
      builder: (_) => const BasePage(
          title: 'Answer  Animation', child: Center(child: AnswerPage()))),
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
          var index = challenges.indexOf(item);
          return ListTile(
            leading: Text('Question $index'),
            trailing: ElevatedButton(
                onPressed: () => Navigator.of(context)
                    .push(MaterialPageRoute(builder: item.builder)),
                child: Text('Answer')),
            title: Text(item.name),
            onTap: () => Navigator.of(context)
                .push(MaterialPageRoute(builder: item.builder)),
          );
        }).toList(),
      ),
    );
  }
}
