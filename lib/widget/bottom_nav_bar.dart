import 'package:flutter/material.dart';
import 'package:ui_challenge/answers/dynamic_form.answer.dart';

class MultipleBottomNavBar extends StatefulWidget {
  const MultipleBottomNavBar(
      {required this.itemList, this.callBack, super.key});

  final List<BottomNavigationBarItem> itemList;
  final SCallBack? callBack;

  @override
  State<MultipleBottomNavBar> createState() => _MultipleBottomNavBarState();
}

class _MultipleBottomNavBarState extends State<MultipleBottomNavBar> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
        currentIndex: _selectedIndex,
        fixedColor: Colors.teal,
        onTap: (value) {
          _selectedIndex = value;
          setState(() {
            widget.callBack!(_selectedIndex);
          });
        },
        items: widget.itemList);
  }
}
