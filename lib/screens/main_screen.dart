import 'package:copid_flutter/screens/home_screen.dart';
import 'package:copid_flutter/screens/news_screen.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List<BottomNavigationBarItem> itemsBottomNavBar = [
    BottomNavigationBarItem(
        icon: Icon(LineIcons.home), label: "Home", tooltip: "Home"),
    BottomNavigationBarItem(
        icon: Icon(LineIcons.newspaper), label: "News", tooltip: "News")
  ];
  int _currentIndex = 0;
  List<Widget> screenIndex = [HomeScreen(), NewsScreen()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          type: BottomNavigationBarType.fixed,
          items: itemsBottomNavBar,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
        ),
        body: screenIndex[_currentIndex]);
  }
}
