import 'package:copid_flutter/constants.dart';
import 'package:copid_flutter/screens/home_screen.dart';
import 'package:copid_flutter/screens/news_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_statusbarcolor_ns/flutter_statusbarcolor_ns.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
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
  int _currentIndex;
  List<Widget> screenIndex;
  PageController _pageController;

  void getThemeMode() async {
    final box = GetStorage();
    String _themeMode = box.read("themeMode");

    if (_themeMode == "light") {
      await FlutterStatusbarcolor.setNavigationBarColor(kPrimaryLightColor);
    } else if (_themeMode == "dark") {
      await FlutterStatusbarcolor.setNavigationBarColor(kPrimaryDarkColor);
    } else if (_themeMode == "same") {
      await FlutterStatusbarcolor.setNavigationBarColor(Colors.black);
    }
  }

  @override
  void initState() {
    super.initState();
    screenIndex = [HomeScreen(), NewsScreen()];
    _currentIndex = 0;
    _pageController = PageController(initialPage: _currentIndex);
    getThemeMode();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

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
              _pageController.jumpToPage(index);
            });
          },
        ),
        body: PageView(
          controller: _pageController,
          physics: NeverScrollableScrollPhysics(),
          children: screenIndex,
        ));
  }
}
