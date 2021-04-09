import 'package:flutter/material.dart';

const kScaffoldDarkBGColor = Color(0xFF000000);
const kScaffoldLightBGColor = Color(0xFFf8f8f8);
const kAccentColor = Color(0xFF1060f5);
const kPrimaryDarkColor = Color(0xFF20222A);
const kPrimaryLightColor = Color(0xFFffffff);
ThemeData klightTheme = ThemeData.light().copyWith(
    bottomNavigationBarTheme:
        BottomNavigationBarThemeData().copyWith(backgroundColor: Colors.white),
    scaffoldBackgroundColor: kScaffoldLightBGColor,
    accentColor: kAccentColor,
    backgroundColor: kPrimaryLightColor,
    appBarTheme: AppBarTheme(
        backgroundColor: kScaffoldLightBGColor,
        iconTheme: IconThemeData(color: Colors.black)),
    canvasColor: kPrimaryLightColor);
ThemeData kdarkTheme = ThemeData.dark().copyWith(
    backgroundColor: kPrimaryDarkColor,
    scaffoldBackgroundColor: kScaffoldDarkBGColor,
    accentColor: kAccentColor,
    appBarTheme: AppBarTheme(
        backgroundColor: kScaffoldDarkBGColor,
        iconTheme: IconThemeData(color: Colors.white),
        textTheme: TextTheme(headline1: TextStyle(color: Colors.yellow))),
    canvasColor: kPrimaryDarkColor);
