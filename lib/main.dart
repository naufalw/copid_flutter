import 'package:copid_flutter/constants.dart';
import 'package:copid_flutter/screens/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

void main() async {
  await GetStorage.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(411.42857142857144, 820.5714285714286),
      builder: () => GetMaterialApp(
        title: 'Copid App',
        themeMode: ThemeMode.dark,
        defaultTransition: Transition.zoom,
        theme: klightTheme,
        darkTheme: kdarkTheme,
        home: MainScreen(),
      ),
    );
  }
}
