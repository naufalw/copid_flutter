import 'package:copid_flutter/constants.dart';
import 'package:copid_flutter/screens/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Copid App',
      themeMode: Get.isDarkMode ? ThemeMode.light : ThemeMode.dark,
      defaultTransition: Transition.zoom,
      theme: klightTheme,
      darkTheme: kdarkTheme,
      home: MainScreen(),
    );
  }
}
